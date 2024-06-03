SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[GetSalesReconciliationReport]  --  exec GetSalesReconciliationReport '2023-01-01','2023-12-31',159 
(  
@FromDate datetime,  
@ToDate datetime,  
@tenantId int=null  
)  
as  
begin   
declare @VatReconSalesTransReport as table    
(id int,    
Description varchar(100),    
InnerAmount decimal (18,2),    
Amount decimal (18,2),    
style int    
)    
  
insert into @VatReconSalesTransReport    
--values(6,'Nominal Supplies',1200,null,3)   
exec VI_VATReconReportSalesReport @Fromdate, @Todate,@tenantId     
  
insert into @VatReconSalesTransReport   
--values(2,'LESS: Invoices (Supplies) reported in Prev Tax Period',1,900,2)  
exec VI_VATReconReportSalesSuppliesofPrevPeriodReport @Fromdate, @Todate,@tenantId     
  
     --(3,'Total Sales Considered',2,2,4)  
insert into @VatReconSalesTransReport  
select 3,'Total Sales Considered',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount ,4   
from @vatReconSalesTransReport t1 cross join @vatReconSalesTransReport t2 where t1.id = 1 and t2.id=2 --group by amount,Description  
  
insert into @VatReconSalesTransReport values(4,'',null,null,6)  
insert into @VatReconSalesTransReport values(5,'LESS: ',null,null,1)  
--     (6,'Nominal Supplies',4,4,3),  
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--insert into @VatReconSalesTransReport    
--values(6,'Nominal Supplies',1200,null,3)   
insert into @VatReconSalesTransReport  
exec VI_ReconNominalSalesReport @FromDate,@ToDate,@tenantid  
  
--     (7,'Exempt Supplies',5,5,3),  
--insert into @VatReconSalesTransReport    
--values(7,'Exempt Supplies',1200,null,3)   
insert into @VatReconSalesTransReport  
exec VI_ReconExemptSalesReport @FromDate,@ToDate,@tenantid  
  
--     (8,'ZERO Rated Supplies',6,6,3),  
--insert into @VatReconSalesTransReport    
--values(8,'ZERO Rated Supplies',1200,null,3)   
insert into @VatReconSalesTransReport  
exec VI_ReconZeroRatedSalesReport @FromDate,@ToDate,@tenantid  
  
--     (9,'Out of Scope Supplies',7,7,3),  
--insert into @VatReconSalesTransReport    
--values(9,'Out of Scope Supplies',1200,null,3)   
insert into @VatReconSalesTransReport  
exec VI_ReconOutofScopeSalesReport @FromDate,@ToDate,@tenantid  
  
--   (10,'Export Supplies',8,8,5),  
  
--insert into @VatReconSalesTransReport    
--values(10,'Export Supplies',1200,null,3)   
insert into @VatReconSalesTransReport  
exec VI_ReconExportSalesReport @FromDate,@ToDate,@tenantid  
  
declare @totalless decimal(18,2)  
set @totalless=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0)+isnull(t5.InnerAmount,0)) from @vatReconSalesTransReport t1 cross join @vatReconSalesTransReport t2 cross join @vatReconSalesTransReport t3 cross join @vatReconSalesTransReport t4 cross join @vatReconSalesTransReport t5  
where t1.id=6 and t2.id=7 and t3.id=8 and t4.id=9 and t5.id=10)  
  
update @VatReconSalesTransReport  
set amount=@totalless where id=10  
  
  
--(11,'Net total',9,9,4),  
insert into @VatReconSalesTransReport  
select 11,'Net Total',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @vatReconSalesTransReport t1 cross join @vatReconSalesTransReport t2   
where t1.id=3 and t2.id=10  
  
insert into @VatReconSalesTransReport values(12,'',null,null,6)  
insert into @VatReconSalesTransReport values(13,'LESS: ',null,null,1)  
  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CREDIT NOTE SET OFF START+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
  
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
insert into @VatReconSalesTransReport  
select 14,'Credit Notes Set off ',null,isnull(amount,0),4 from @VatReconCreditSalesTransReport where id=18  
  
  
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CREDIT NOTE SET OFF END+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  
--     (15,'Net Sales',15,15,4),  
insert into @VatReconSalesTransReport  
select 15,'Net Sales',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @vatReconSalesTransReport t1 cross join @vatReconSalesTransReport t2   
where t1.id=11 and t2.id=14   
  
insert into @VatReconSalesTransReport values(16,'',null,null,6)  
  
insert into @VatReconSalesTransReport values(17,'ADD: ',null,null,1)  
  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++DEBIT NOTE SET OFF START+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
  
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
  
select 8,'Total for Debit Notes-Sales',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconDebitSalesTransReport t1 cross join @VatReconDebitSalesTransReport t2   
where t1.id=1 and t2.id=7   
  
  
  
--(18,'Debit Notes on Supplies',13,13,2),  
insert into @VatReconSalesTransReport  
  select 18,'Total for Debit Notes-Sales',null,  
 t1.Amount - ISNULL((SELECT SUM(t1.InnerAmount) FROM @VatReconDebitSalesTransReport t1 WHERE ID IN (2, 3, 4, 5, 6, 7)), 0)   
 ,4 FROM  
    @VatReconDebitSalesTransReport t1  
WHERE  
    ID = 1   
  
--select 18,'Debit Notes on Supplies',null,isnull(amount,0),4 from @VatReconDebitSalesTransReport where id=8  
--exec VI_ReconDebitNotesReport @FromDate,@ToDate,@tenantid  
  
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++DEBIT NOTE SET OFF END+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  
insert into @VatReconSalesTransReport values(19,'',null,null,6)  
  
--(20,'Total Sales Reportable for VAT',14,14,4)  
insert into @VatReconSalesTransReport  
select 20,'Total Sales Reportable for VAT',null,(isnull(t1.Amount,0)+isnull(t2.Amount,0)) as amount,2 from @vatReconSalesTransReport t1 cross join @vatReconSalesTransReport t2   
where t1.id=15 and t2.id=18   
  
select id,Description, InnerAmount AS InnerAmount,Amount AS Amount,style from @VatReconSalesTransReport  
end
GO
