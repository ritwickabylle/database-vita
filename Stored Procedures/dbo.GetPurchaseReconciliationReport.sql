SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[GetPurchaseReconciliationReport]  --exec GetPurchaseReconciliationReport '2023-03-01','2023-03-31',148      
(      
@FromDate datetime,      
@ToDate datetime,      
@tenantId int=null      
)      
as      
begin       
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
      
declare @totalless decimal(18,2)      
set @totalless=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0))
-- +isnull(t5.InnerAmount,0))     
from @VatReconPurchaseTransReport t1 cross join @VatReconPurchaseTransReport t2 cross join @VatReconPurchaseTransReport t3 cross join @VatReconPurchaseTransReport t4 
--cross join @VatReconPurchaseTransReport t5      
where t1.id=7 and t2.id=8 and t3.id=9 and t4.id=10 )
--and t5.id=10)      
      
update @VatReconPurchaseTransReport      
set amount=@totalless where id=10      
      
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
      
declare @totalless1 decimal(18,2)      
set @totalless1=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0))     
from @VatReconDebitPurchaseTransReport t1 cross join @VatReconDebitPurchaseTransReport t2 cross join @VatReconDebitPurchaseTransReport t3 cross join @VatReconDebitPurchaseTransReport t4       
where t1.id=4 and t2.id=5 and t3.id=6 and t4.id=7)      
      
update @VatReconDebitPurchaseTransReport      
set amount=@totalless1 where id=7      
      
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
      
select * from @VatReconPurchaseTransReport      
end
GO
