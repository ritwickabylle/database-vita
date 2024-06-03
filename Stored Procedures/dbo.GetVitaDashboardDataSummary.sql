SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE   PROCEDURE [dbo].[GetVitaDashboardDataSummary]    --  [GetVitaDashboardDataSummary] '2023-03-01','2023-03-31',148  
(  
@fromDate datetime,         
@toDate datetime,      
@tenantId int=null  
)   
AS  
SET NOCOUNT ON;  
BEGIN  
  
  
--sales summary  
  
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
  
--select 8,'Total for Debit Notes-Sales',null,(isnull(t1.Amount,0)-isnull(t2.InnerAmount,0)) as amount,4 from @VatReconDebitSalesTransReport t1 cross join @VatReconDebitSalesTransReport t2   
--where t1.id=1 and t2.id=7   
  select 8,'Total for Debit Notes-Sales',null,
 t1.Amount - ISNULL((SELECT SUM(t1.InnerAmount) FROM @VatReconDebitSalesTransReport t1 WHERE ID IN (2, 3, 4, 5, 6, 7)), 0) 
 ,4 FROM
    @VatReconDebitSalesTransReport t1
WHERE
    ID = 1 
--(18,'Debit Notes on Supplies',13,13,2),  
insert into @VatReconSalesTransReport  
select 18,'Debit Notes on Supplies',null,isnull(amount,0),4 from @VatReconDebitSalesTransReport where id=8  
--exec VI_ReconDebitNotesReport @FromDate,@ToDate,@tenantid  
  

 
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++DEBIT NOTE SET OFF END+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  
insert into @VatReconSalesTransReport values(19,'',null,null,6)  
  
--(20,'Total Sales Reportable for VAT',14,14,4)  
insert into @VatReconSalesTransReport  
select 20,'Total Sales Reportable for VAT',null,(isnull(t1.Amount,0)+isnull(t2.Amount,0)) as amount,2 from @vatReconSalesTransReport t1 cross join @vatReconSalesTransReport t2   
where t1.id=15 and t2.id=18   
  
insert into @VatReconSalesTransReport   
--values(2,'LESS: Adjustment Credit Note (Supplies) reported in Prev Tax Period',1,900,2)  
exec VI_VATReconReportCreditSalesSuppliesofPrevPeriodReport @Fromdate, @Todate,@tenantId    
  
INSERT INTO @VatReconSalesTransReport  
SELECT 21,'Net Taxable Amount',NULL,ISNULL(  
        (SELECT SUM(CASE WHEN id = 20 THEN amount ELSE 0 END) FROM @VatReconSalesTransReport)  
        - (SELECT SUM(CASE WHEN id = 2 THEN amount ELSE 0 END) FROM @VatReconSalesTransReport),0),4  
  
  
--purchase summary  
  
  
declare @VatReconPurchaseTransReport as table          
(id int,          
Description varchar(100),          
InnerAmount decimal (18,2),          
Amount decimal (18,2),          
style int          
)          
        
create table #temp_table           
(id int,            
Description varchar(100),            
InnerAmount decimal (18,2),            
Amount decimal (18,2),            
style int           
)          
        
insert into @VatReconPurchaseTransReport          
--values(1,'Sales as Per Detailed Sales Report',0,1000,2)         
exec VI_VATReconReportPurchaseReport @Fromdate, @Todate,@tenantId           
        
insert into @VatReconPurchaseTransReport         
--values(2,'LESS: Invoices (Supplies) reported in Prev Tax Period',1,900,2)        
exec VI_VATReconReportPurchaseSuppliesofPrevPeriodReport @Fromdate, @Todate,@tenantId           
        
     --(3,'Total Sales Considered',2,2,4)        
insert into @VatReconPurchaseTransReport        
select 3,'Net Purchase Considered',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount ,4         
from @VatReconPurchaseTransReport t1 cross join @VatReconPurchaseTransReport t2 where t1.id = 1 and t2.id=2 --group by amount,Description        
        
insert into @VatReconPurchaseTransReport values(4,'',null,null,6)        
insert into @VatReconPurchaseTransReport values(5,'LESS: ',null,null,1)        
--     (6,'Nominal Supplies',4,4,3),        
        
-----------------------------------------------------------------------------------------        
--insert into @VatReconPurchaseTransReport        
--exec VI_ReconNominalPurchaseReport @Fromdate, @Todate,@tenantId        
        
--     (7,'Exempt Supplies',5,5,3),        
insert into @VatReconPurchaseTransReport        
exec VI_ReconExemptPurchaseReport  @Fromdate, @Todate,@tenantId         
        
--     (8,'ZERO Rated Supplies',6,6,3),        
insert into @VatReconPurchaseTransReport        
exec VI_ReconZeroRatedPurchaseReport  @Fromdate, @Todate,@tenantId         
        
--     (9,'Out of Scope Supplies',7,7,3),        
insert into @VatReconPurchaseTransReport        
exec VI_ReconOutofScopePurchaseReport  @Fromdate, @Todate,@tenantId         
        
--   (10,'Export Supplies',8,8,5),        
insert into @VatReconPurchaseTransReport        
exec VI_ReconExportPurchaseReport  @Fromdate, @Todate,@tenantId       
        
declare @totallesspurchase decimal(18,2)        
set @totallesspurchase=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0))  
-- +isnull(t5.InnerAmount,0))       
from @VatReconPurchaseTransReport t1 cross join @VatReconPurchaseTransReport t2 cross join @VatReconPurchaseTransReport t3 cross join @VatReconPurchaseTransReport t4   
--cross join @VatReconPurchaseTransReport t5        
where t1.id=7 and t2.id=8 and t3.id=9 and t4.id=10 )  
--and t5.id=10)        
        
update @VatReconPurchaseTransReport        
set amount=@totallesspurchase where id=10        
        
--              (11,'Net total',9,9,4),        
insert into @VatReconPurchaseTransReport        
select 11,'Net Total',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconPurchaseTransReport t1 cross join @VatReconPurchaseTransReport t2         
where t1.id=3 and t2.id=10        
        
insert into @VatReconPurchaseTransReport values(12,'',null,null,6)        
insert into @VatReconPurchaseTransReport values(13,'LESS: ',null,null,1)        
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------        
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CERDIT NOTE SET OFF START++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++        
 --declare @FromDate datetime='2023-02-01',      
 --@ToDate datetime='2023-02-28',      
 --@tenantId int=24,      
 --@totalless decimal      
      
       
 declare @VatReconCreditPurchaseTransReport as table            
(id int,            
Description varchar(100),            
InnerAmount decimal (18,2),            
Amount decimal (18,2),            
style int            
)            
          
insert into @VatReconCreditPurchaseTransReport            
--values(1,'Sales as Per Detailed Sales Report',0,1000,2)           
exec VI_VATReconReportCreditPurchaseReport @FromDate, @ToDate,@tenantId             
          
insert into @VatReconCreditPurchaseTransReport values(2,'',null,null,6)          
insert into @VatReconCreditPurchaseTransReport values(3,'LESS: ',null,null,1)          
          
--     (4,'Exempt Supplies',4,4,3),          
insert into @VatReconCreditPurchaseTransReport          
exec VI_ReconExemptCreditPurchaseReport  @Fromdate, @Todate,@tenantId          
          
--     (5,'ZERO Rated Supplies',5,5,3),          
insert into @VatReconCreditPurchaseTransReport          
exec VI_ReconZeroRatedCreditPurchaseReport  @Fromdate, @Todate,@tenantId           
          
--     (6,'Out of Scope Supplies',6,6,3),          
insert into @VatReconCreditPurchaseTransReport          
exec VI_ReconOutofScopeSCreditPurchaseReport  @Fromdate, @Todate,@tenantId          
          
--   (7,'Export Supplies',7,7,3),          
insert into @VatReconCreditPurchaseTransReport          
exec VI_ReconExportCreditPurchaseReport  @Fromdate, @Todate,@tenantId         
          
---------------------------------------------------------------------------------          
          
declare @totalless2 decimal(18,2)          
set @totalless2=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0))       
from @VatReconCreditPurchaseTransReport t1 cross join @VatReconCreditPurchaseTransReport t2 cross join @VatReconCreditPurchaseTransReport t3 cross join @VatReconCreditPurchaseTransReport t4           
where t1.id=4 and t2.id=5 and t3.id=6 and t4.id=7)          
          
update @VatReconCreditPurchaseTransReport          
set amount=@totalless2 where id=7          
          
----(8,'Total Credit Notes Set off Against Supplies',14,14,4)          
insert into @VatReconCreditPurchaseTransReport           
          
select 8,'Net Purchase Credit Notes',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconCreditPurchaseTransReport t1 cross join @VatReconCreditPurchaseTransReport t2           
where t1.id=1 and t2.id=7           
          
insert into @VatReconCreditPurchaseTransReport           
          
select 9,'Total Credit Notes Set off Against Purchase',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,2 from @VatReconCreditPurchaseTransReport t1 cross join @VatReconCreditPurchaseTransReport t2           
where t1.id=1 and t2.id=7       
      
--select * from @VatReconCreditPurchaseTransReport      
        
insert into @VatReconPurchaseTransReport        
--exec VI_ReconPurchaseCreditNotesSetOff  @FromDate,@ToDate,@tenantid        
select 14,'Credit Notes Set off ',null,                      
      isnull(amount,0) as amount,2                      
 from @VatReconCreditPurchaseTransReport where id = 9        
      
        
 --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CERDIT NOTE SET OFF END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++        
--------------------------------------------------------------------------------------------------------------------------------------------------------------        
        
--     (15,'Net Sales',15,15,4),        
insert into @VatReconPurchaseTransReport        
--select 15,'Net Sales',0,case when id = 11 then amount else 0 end - case when id = 14 then amount else 0 end as amount,4 from @VatReconPurchaseTransReport         
--where id in (11,14)          
        
select 15,'Net Purchase',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconPurchaseTransReport t1 cross join @VatReconPurchaseTransReport t2         
where t1.id=11 and t2.id=14         
        
insert into @VatReconPurchaseTransReport values(16,'',null,null,6)        
        
insert into @VatReconPurchaseTransReport values(17,'ADD: ',null,null,1)        
        
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------        
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++DEBIT NOTE SET OFF START++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++        
        
        
 declare @VatReconDebitPurchaseTransReport as table          
(id int,          
Description varchar(100),          
InnerAmount decimal (18,2),          
Amount decimal (18,2),          
style int          
)          
        
insert into @VatReconDebitPurchaseTransReport          
--values(1,'Sales as Per Detailed Sales Report',0,1000,2)         
exec VI_VATReconReportDebitPurchaseReport @Fromdate, @Todate,@tenantId           
        
insert into @VatReconDebitPurchaseTransReport values(2,'',null,null,6)        
insert into @VatReconDebitPurchaseTransReport values(3,'LESS: ',null,null,1)        
        
--     (4,'Exempt Supplies',4,4,3),        
insert into @VatReconDebitPurchaseTransReport        
exec VI_ReconExemptDebitPurchaseReport  @Fromdate, @Todate,@tenantId        
        
--     (5,'ZERO Rated Supplies',5,5,3),        
insert into @VatReconDebitPurchaseTransReport        
exec VI_ReconZeroRatedDebitPurchaseReport  @Fromdate, @Todate,@tenantId         
        
--     (6,'Out of Scope Supplies',6,6,3),        
insert into @VatReconDebitPurchaseTransReport        
exec VI_ReconOutofScopeSDebitPurchaseReport @Fromdate, @Todate,@tenantId        
        
--   (7,'Export Supplies',7,7,3),        
insert into @VatReconDebitPurchaseTransReport        
exec VI_ReconExportDebitPurchaseReport @Fromdate, @Todate,@tenantId         
        
declare @totalless1purchase decimal(18,2)        
set @totalless1purchase=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0))       
from @VatReconDebitPurchaseTransReport t1 cross join @VatReconDebitPurchaseTransReport t2 cross join @VatReconDebitPurchaseTransReport t3 cross join @VatReconDebitPurchaseTransReport t4         
where t1.id=4 and t2.id=5 and t3.id=6 and t4.id=7)        
        
update @VatReconDebitPurchaseTransReport        
set amount=@totalless1purchase where id=7        
        
----(8,'Total Credit Notes Set off Against Supplies',14,14,4)        
insert into @VatReconDebitPurchaseTransReport         
        
select 8,'Total for Debit Notes-Purchase',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconDebitPurchaseTransReport t1 cross join @VatReconDebitPurchaseTransReport t2         
where t1.id=1 and t2.id=7         
        
insert into @VatReconPurchaseTransReport        
select 18,'Debit Notes on Purchase',null,                      
      isnull(Amount,0) as amount,2                      
 from @VatReconDebitPurchaseTransReport where id = 8        
        
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++DEBIT NOTE SET OFF END++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++        
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------        
        
insert into @VatReconPurchaseTransReport values(19,'',null,null,6)        
        
--(20,'Total Sales Reportable for VAT',14,14,4)        
insert into @VatReconPurchaseTransReport        
select 20,'Total Purchase Reportable for VAT',null,(isnull(t1.Amount,0)+isnull(t2.Amount,0)) as amount,2 from @VatReconPurchaseTransReport t1 cross join @VatReconPurchaseTransReport t2         
where t1.id=15 and t2.id=18      
  
insert into @VatReconPurchaseTransReport         
--values(2,'LESS: Invoices (Supplies) reported in Prev Tax Period',1,900,2)        
exec VI_VATReconReportPurchaseSuppliesofPrevPeriodReport @Fromdate, @Todate,@tenantId           
   
INSERT INTO @VatReconPurchaseTransReport  
SELECT 21,'Net Taxable Amount',NULL,ISNULL(  
        (SELECT SUM(CASE WHEN id = 20 THEN amount ELSE 0 END) FROM @VatReconPurchaseTransReport)  
        - (SELECT SUM(CASE WHEN id = 2 THEN amount ELSE 0 END) FROM @VatReconPurchaseTransReport),0),4  
  
-- vat output  
  
  
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
    
insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
select 8,'6. Total Sales',sum(amount),sum(adjustmentamount),sum(vatamount) from @VatReport where id <=7    
  
INSERT INTO @VatReconSalesTransReport  
SELECT 22,'VAT Output Data',NULL,VatAmount,4 from @VatReport  where id = 8  
  
 
-- vat Input  
  
declare @VatReportPurchase as table    
(id int,    
vatDescription varchar(100),    
Amount decimal (18,2),    
AdjustmentAmount decimal (18,2),    
VatAmount decimal (18,2)    
)    
    
--insert into @VatReportPurchase values (9,'7. Standard Rated Domestic Purchase15%',0,0,0)    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportStandardRatedPurchases15 @fromdate,@todate,@tenantId  
    
--insert into @VatReportPurchase values (10,'7.1 Standard Rated Domestic Purchase 5%',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportStandardRatedPurchases5 @fromdate,@todate,@tenantId    
    
--insert into @VatReportPurchase values (11,'8. Imports subject to VAT paid at customs 15%',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportImportSubjecttoVATPaid15 @fromdate,@todate,@tenantId    
    
--insert into @VatReportPurchase values (12,'8.1 Imports subject to VAT paid at customs 5%',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportImportSubjecttoVATPaid5 @fromdate,@todate,@tenantId    
    
--insert into @VatReportPurchase values (13,'9. Imports subject to VAT accounted for through reverse charge mechanism 15%',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportImportSubjecttoRCM15 @fromdate,@todate,@tenantId    
    
--insert into @VatReportPurchase values (14,'9.1 Imports subject to VAT accounted for through reverse charge mechanism 5%',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportImportSubjecttoRCM5 @fromdate,@todate,@tenantId    
    
--insert into @VatReportPurchase values (15,'10. Zero rated purchases',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportZeroRatedPurchases @fromdate,@todate,@tenantId    
    
--insert into @VatReportPurchase values (16,'11. Exempt purchases',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
exec VI_VATReportExemptPurchases @fromdate,@todate,@tenantId    
    
--insert into @VatReportPurchase values (17,'12. Total purchases',0,0,0);    
insert into @VatReportPurchase(id,vatDescription,amount,AdjustmentAmount,VatAmount)     
select 17,'12. Total purchases',sum(amount),sum(adjustmentamount),sum(vatamount) from @VatReportPurchase where id in(9,10)
     
INSERT INTO @VatReconPurchaseTransReport  
SELECT 22,'VAT Input Data',NULL,VatAmount,4 from @VatReportPurchase  where id = 17;  

--select * from @VatReconPurchaseTransReport;
 
 WITH DummyData AS (  
  select   
  sum(case when id=11 then Amount else 0 end) as Amount,  
  sum(case when id=14 then Amount else 0 end) as LessCreditNote,  
  sum(case when id=18 then Amount else 0 end) as LessDebitNote,  
  sum(case when id=20 then Amount else 0 end) as TaxableAmount,  
  sum(case when id=2 then Amount else 0 end) as Adjustment,  
  sum(case when id=21 then Amount else 0 end) as NetTaxableAmount,  
  sum(case when id=22 then Amount else 0 end) as VAT  
  from @VatReconSalesTransReport WHERE id IN(11,14,18,20,2,21,22)  
    ),  
 DummyPurchaseData AS (  
  select   
  sum(case when id=11 then Amount else 0 end) as Amount,  
  sum(case when id=14 then Amount else 0 end) as LessCreditNote,  
  sum(case when id=18 then Amount else 0 end) as LessDebitNote,  
  sum(case when id=20 then Amount else 0 end) as TaxableAmount,  
  sum(case when id=2 then Amount else 0 end) as Adjustment,  
  sum(case when id=21 then Amount else 0 end) as NetTaxableAmount,  
  sum(case when id=22 then Amount else 0 end) as VAT  
  from @VatReconPurchaseTransReport WHERE id IN(11,14,18,20,2,21,22)  
    )  
    SELECT  
        Type,  
        Field,  
        Value  
    FROM (  
        SELECT  
            'Sales' AS Type, *  
        FROM  
            DummyData  
        UNION ALL  
        SELECT  
            'Purchase' AS Type, *  
        FROM   
   DummyPurchaseData  
    ) src  
    UNPIVOT (  
        Value FOR Field IN (  
   Amount,LessCreditNote,LessDebitNote,TaxableAmount,Adjustment,NetTaxableAmount,VAT  
        )  
    ) AS unpvt  
END
GO
