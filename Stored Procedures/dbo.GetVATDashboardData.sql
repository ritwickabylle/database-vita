SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
    
CREATE   PROCEDURE [dbo].[GetVATDashboardData]    --  exec [GetVATDashboardData]  '2023-03-01', '2023-03-31' ,148     
(    
@fromDate datetime,           
@toDate datetime,        
@tenantId int=null    
)     
    
    
AS    
SET NOCOUNT ON;    
BEGIN    
    
Declare @VATOutput decimal(18,2) = 0    
Declare @VATInput decimal(18,2) = 0    
Declare @VATPayable decimal(18,2) = 0    
Declare @salesAdjustment decimal(18,2) = 0    
Declare @purchaseAdjustment decimal(18,2) = 0    
Declare @salesVATAmount decimal(18,2) = 0    
Declare @purchaseVATAmount decimal(18,2) = 0    
Declare @netVATDue decimal(18,2) = 0    
Declare @correctionPrevYear decimal(18,2) = 0    
Declare @VATCreditCarried decimal(18,2) = 0    
Declare @VATDueDate varchar(100)    
Declare @VatDue datetime    
Declare @VATReturnFillingFrequency nvarchar(100)    
    
--set @VatDue = DATEADD(day, 1, @toDate)   --add one day then taking last date of month <<Last day for filing and payment is on the last day of the month following the close of the taxable month/Quarter>>    
      
declare @VatReport as table      
(id int,      
vatDescription varchar(100),      
Amount decimal (18,2),      
AdjustmentAmount decimal (18,2),      
VatAmount decimal (18,2)      
)      
      
     
      
insert into @VatReport--(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportStandardRatedSales15 @Fromdate, @Todate,@tenantId       
       
       
      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportStandardRatedSales5 @Fromdate, @Todate,@tenantId       
      
      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportStandardRatedSalesGovt @Fromdate, @Todate,@tenantId       
      
      
insert into @VatReport values (4,'2. Sales on which the government bears the VAT',0,0,0)      
      
      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportZeroRatedSales @Fromdate, @Todate,@tenantId       
      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportExports @fromdate, @todate,@tenantId     
      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportExemptedSales @fromdate, @todate,@tenantId    
      
      
  
  
-----DEBIT----  
declare @VatReconDebitSalesTransReport as table          
(id int,          
Description varchar(100),          
InnerAmount decimal (18,2),          
Amount decimal (18,2),          
style int          
)          
        
insert into @VatReconDebitSalesTransReport          
--values(1,'Sales as Per Detailed Sales Report',0,1000,2)         
exec VI_VATReconReportDebitSalesReport @Fromdate, @Todate,@tenantId           
        
insert into @VatReconDebitSalesTransReport values(2,'',null,null,6)        
insert into @VatReconDebitSalesTransReport values(3,'LESS: ',null,null,1)        
        
--     (4,'Exempt Supplies',4,4,3),        
insert into @VatReconDebitSalesTransReport        
exec VI_ReconExemptDebitSalesReport @FromDate,@ToDate,@tenantid        
        
--     (5,'ZERO Rated Supplies',5,5,3),        
insert into @VatReconDebitSalesTransReport        
exec VI_ReconZeroRatedDebitSalesReport @FromDate,@ToDate,@tenantid        
        
--     (6,'Out of Scope Supplies',6,6,3),        
insert into @VatReconDebitSalesTransReport        
exec VI_ReconOutofDebitScopeSalesReport @FromDate,@ToDate,@tenantid        
        
--   (7,'Export Supplies',7,7,3),        
insert into @VatReconDebitSalesTransReport        
exec VI_ReconExportDebitSalesReport @FromDate,@ToDate,@tenantid        
        
---------------------------------------------------------------------------------        
        
----(8,'Total Credit Notes Set off Against Supplies',14,14,4)        
insert into @VatReconDebitSalesTransReport       
  select 8,'Total for Debit Notes-Sales',null,  
 t1.Amount - ISNULL((SELECT SUM(t1.InnerAmount) FROM @VatReconDebitSalesTransReport t1 WHERE ID IN (2, 3, 4, 5, 6, 7)), 0)   
 ,4 FROM  
    @VatReconDebitSalesTransReport t1  
WHERE  
    ID = 1   
--select 8,'Total for Debit Notes-Sales',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconDebitSalesTransReport t1 cross join @VatReconDebitSalesTransReport t2         
--where t1.id=1 and t2.id=7         
        
    
      insert into @VatReport        
select 52,'Debit Notes on Supplies',null,isnull(amount,0),4 from @VatReconDebitSalesTransReport where id=8    
  
--(18,'Debit Notes on Supplies',13,13,2),        
      
--exec VI_ReconDebitNotesReport @FromDate,@ToDate,@tenantid        
-----/DEBIT/----  
  
  
  
----CREDIT------  
declare @VatReconCreditSalesTransReport as table          
(id int,          
Description varchar(100),          
InnerAmount decimal (18,2),          
Amount decimal (18,2),          
style int          
)         
        
insert into @VatReconCreditSalesTransReport          
--values(1,'Sales as Per Detailed Sales Report',0,1000,2)         
exec VI_VATReconReportCreditSalesReport @Fromdate, @Todate,@tenantId        
        
insert into @VatReconCreditSalesTransReport         
--values(2,'LESS: Invoices (Supplies) reported in Prev Tax Period',1,900,2)        
exec VI_VATReconReportCreditSalesSuppliesofPrevPeriodReport @Fromdate, @Todate,@tenantId           
        
     --(3,'Total Sales Considered',2,2,4)        
insert into @VatReconCreditSalesTransReport        
select 3,'Total Credit Notes  Considered',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount ,4         
from @VatReconCreditSalesTransReport t1 cross join @VatReconCreditSalesTransReport t2 where t1.id = 1 and t2.id=2        
        
insert into @VatReconCreditSalesTransReport values(4,'',null,null,6)        
insert into @VatReconCreditSalesTransReport values(5,'LESS: ',null,null,1)        
        
--     (6,'Exempt Supplies',4,4,3),        
insert into @VatReconCreditSalesTransReport        
exec VI_ReconExemptCreditSalesReport @FromDate,@ToDate,@tenantid        
        
--     (7,'ZERO Rated Supplies',5,5,3),        
insert into @VatReconCreditSalesTransReport        
exec VI_ReconZeroRatedCreditSalesReport @FromDate,@ToDate,@tenantid        
        
--     (8,'Out of Scope Supplies',6,6,3),        
insert into @VatReconCreditSalesTransReport        
exec VI_ReconOutofCreditScopeSalesReport @FromDate,@ToDate,@tenantid        
        
--   (9,'Export Supplies',7,7,3),        
insert into @VatReconCreditSalesTransReport        
exec VI_ReconExportCreditSalesReport @FromDate,@ToDate,@tenantid        
        
declare @totalless1 decimal(18,2)        
set @totalless1=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0)) from @VatReconCreditSalesTransReport t1 cross join @VatReconCreditSalesTransReport t2 cross join @VatReconCreditSalesTransReport 
  
    
      
t3 cross join @VatReconCreditSalesTransReport t4         
where t1.id=6 and t2.id=7 and t3.id=8 and t4.id=9)        
        
update @VatReconCreditSalesTransReport        
set amount=@totalless1 where id=9        
        
--              (10,'Net total',8,8,5),        
insert into @VatReconCreditSalesTransReport        
        
select 10,'Net Total',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconCreditSalesTransReport t1 cross join @VatReconCreditSalesTransReport t2         
where t1.id=3 and t2.id=9        
        
insert into @VatReconCreditSalesTransReport values(11,'',null,null,6)        
        
--insert into @VatReconCreditSalesTransReport values(12,'',0,0,6)        
insert into @VatReconCreditSalesTransReport values(12,'LESS: ',null,null,1)        
--     (13,'Credit Notes reported under ADJUSTMENTS',11,11,2),        
insert into @VatReconCreditSalesTransReport        
exec VI_ReconCreditNotesSetOffAgainstSupplies  @FromDate,@ToDate,@tenantid        
        
--     (14,'Net Sales Credit Notes',15,15,4),        
insert into @VatReconCreditSalesTransReport        
select 14,'Net Sales Credit Notes',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconCreditSalesTransReport t1 cross join @VatReconCreditSalesTransReport t2         
where t1.id=10 and t2.id=13         
        
insert into @VatReconCreditSalesTransReport values(15,'',null,null,6)        
        
insert into @VatReconCreditSalesTransReport values(16,'',null,null,6)        
        
insert into @VatReconCreditSalesTransReport values(17,'',null,null,6)        
        
----(18,'Total Credit Notes Set off Against Supplies',14,14,4)        
insert into @VatReconCreditSalesTransReport         
        
select 18,'Total Credit Notes Set off Against Supplies',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,2 from @VatReconCreditSalesTransReport t1 cross join @VatReconCreditSalesTransReport t2         
where t1.id=14 and t2.id=17         
        
--(14,'Credit Notes Set off ',11,11,2),        
insert into @VatReport        
select 51,'Credit Notes Set off ',null,isnull(amount,0),4 from @VatReconCreditSalesTransReport where id=18        
        
----/CREDIT/-----  
insert into @VatReport        
  
exec VI_VATReconReportSalesReport @Fromdate, @Todate,@tenantId     
  
update @VatReport set VatAmount=0  
where vatDescription='Sales as Per Detailed Sales Report'  
  
update @VatReport set id=9  
where vatDescription='Sales as Per Detailed Sales Report'  
  
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
select 8,'6. Total Sales',sum(amount),sum(adjustmentamount),sum(vatamount) from @VatReport where id <=3  
  
  
INSERT INTO @VatReport        
SELECT 53,'Net Taxable Amount',ISNULL(        
        (SELECT SUM(CASE WHEN id = 52 THEN AdjustmentAmount ELSE 0 END) FROM @VatReport)    
  -(SELECT SUM(CASE WHEN id = 51 THEN AdjustmentAmount ELSE 0 END) FROM @VatReport)  
        + (SELECT SUM(CASE WHEN id = 8 THEN amount ELSE 0 END) FROM @VatReport),0),  
  ISNULL((SELECT SUM(CASE WHEN id = 8 THEN AdjustmentAmount ELSE 0 END) FROM @VatReport),0)  
  ,ISNULL((SELECT SUM(CASE WHEN id = 8 THEN vatamount ELSE 0 END) FROM @VatReport),0)        
        
Select @VATOutput = VatAmount,    
  @salesAdjustment =AdjustmentAmount,    
  @salesVATAmount = amount    
  from @VatReport    
  where id =8      
      
--insert into @VatReport values (9,'7. Standard Rated Domestic Purchase15%',0,0,0)      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportStandardRatedPurchases15 @fromdate,@todate,@tenantId    
 update    @VatReport set id=18 where vatDescription='7. Standard Rated Domestic Purchase15%'  
--insert into @VatReport values (10,'7.1 Standard Rated Domestic Purchase 5%',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportStandardRatedPurchases5 @fromdate,@todate,@tenantId      
      
--insert into @VatReport values (11,'8. Imports subject to VAT paid at customs 15%',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportImportSubjecttoVATPaid15 @fromdate,@todate,@tenantId      
      
--insert into @VatReport values (12,'8.1 Imports subject to VAT paid at customs 5%',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportImportSubjecttoVATPaid5 @fromdate,@todate,@tenantId      
      
--insert into @VatReport values (13,'9. Imports subject to VAT accounted for through reverse charge mechanism 15%',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportImportSubjecttoRCM15 @fromdate,@todate,@tenantId      
      
--insert into @VatReport values (14,'9.1 Imports subject to VAT accounted for through reverse charge mechanism 5%',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportImportSubjecttoRCM5 @fromdate,@todate,@tenantId      
      
--insert into @VatReport values (15,'10. Zero rated purchases',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)    
exec VI_VATReportZeroRatedPurchases @fromdate,@todate,@tenantId      
      
--insert into @VatReport values (16,'11. Exempt purchases',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
exec VI_VATReportExemptPurchases @fromdate,@todate,@tenantId      
      
--insert into @VatReport values (17,'12. Total purchases',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
select 17,'12. Total purchases',sum(amount),sum(adjustmentamount),sum(vatamount) from @VatReport where id in(18,10)    
  
      
  Select @VATInput = VatAmount,      
  @purchaseAdjustment = adjustmentamount,     
  @purchaseVATAmount = amount    
  from @VatReport    
  where id =17      
    
--insert into @VatReport values (18,'13. Total VAT due for current period',0,0,0);      
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
select 21,'13. Total VAT due for current period',      
--  sum(case when id = 8 then amount          
--  when id = 17 then 0-amount end),      ' alteration made on 26.08.2023 after input from Diendo during client data review    
0 AS AMOUNT,         
0 AS ADJUSTMENTAMOUNT,    
--  sum(case when id = 8 then adjustmentamount      
--  when id = 17 then 0-AdjustmentAmount end),      
  sum(case when id = 8 then vatamount      
  when id = 17 then 0-vatamount end) from @VatReport where id in (8,17)      
    
insert into @VatReport values (19,'14. Corrections from previous period (betweenSAR 5,000±)',0,0,0);      
insert into @VatReport values (20,'15. VAT credit carried forward from previous period(s)',0,0,0);      
--insert into @VatReport values (21,'16. Net VAT due (or claim)',0,0,0);       
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)       
select 21,'16. Net VAT due (or claim)',      
--  sum(case when id = 8 then amount      
--  when id = 17 then 0-amount end),      
--  sum(case when id = 8 then adjustmentamount      
--  when id = 17 then 0-AdjustmentAmount end),    ' alteration made on 26.08.2023 after input from Diendo during client data review    
0 AS AMOUNT,         
0 AS ADJUSTMENTAMOUNT,    
  sum(case when id = 8 then vatamount      
  when id = 17 then 0-vatamount end) from @VatReport where id in (8,17)      
       
    Select @VATPayable = VatAmount from @VatReport where id =21      
 Select @netVATDue = VatAmount from @VatReport where id =21      
 Select @correctionPrevYear = VatAmount from @VatReport where id =19      
 Select @VATCreditCarried = VatAmount from @VatReport where id =20    
    
 -- select @VatDue = [LastReturnFiled], @VATReturnFillingFrequency = VATReturnFillingFrequency from TenantBasicDetails  where TenantId = @tenantId    
     
 --if @VATReturnFillingFrequency = 'Quarterly'    
 --Begin    
 -- set @VATDueDate = 'Last Day for Filing your VAT : ' + CONVERT(VARCHAR, EOMONTH(DATEADD(month, 3, EOMONTH(@VatDue))))     
 --end    
 --else    
 --Begin    
 -- set @VATDueDate = 'Last Day for Filing your VAT : ' + CONVERT(VARCHAR, EOMONTH(DATEADD(day, 1, EOMONTH(@VatDue))))     
 --end     
    
 set @VatDue = DATEADD(day, 1, @toDate)   --add one day then taking last date of month <<Last day for filing and payment is on the last day of the month following the close of the taxable month/Quarter>>    
 set @VATDueDate = CONVERT(VARCHAR, EOMONTH(@VatDue), 120)     
  
 SELECT    
  @VATOutput as VATOutput,    
  @salesAdjustment as salesAdjustment,    
  @salesVATAmount as salesVATAmount,    
      
  @VATInput as VATInput,      
  @purchaseAdjustment as purchaseAdjustment,     
  @purchaseVATAmount as purchaseVATAmount,    
    
  @VATPayable as VATPayable,    
  @netVATDue as netVATDue,    
  @correctionPrevYear as correctionPrevYear,    
  @VATCreditCarried as VATCreditCarried,    
  @VATDueDate as VATDueDate    
   
    
END
GO
