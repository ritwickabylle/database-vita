SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[GetSalesCreditReconciliationReport]  --exec GetSalesCreditReconciliationReport '2022-08-01','2022-08-31',2
(
@FromDate datetime,
@ToDate datetime,
@tenantId int=null
)
as
begin 
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

--			  (6,'Exempt Supplies',4,4,3),
insert into @VatReconCreditSalesTransReport
exec VI_ReconExemptCreditSalesReport @FromDate,@ToDate,@tenantid

--			  (7,'ZERO Rated Supplies',5,5,3),
insert into @VatReconCreditSalesTransReport
exec VI_ReconZeroRatedCreditSalesReport @FromDate,@ToDate,@tenantid

--			  (8,'Out of Scope Supplies',6,6,3),
insert into @VatReconCreditSalesTransReport
exec VI_ReconOutofCreditScopeSalesReport @FromDate,@ToDate,@tenantid

--	  (9,'Export Supplies',7,7,3),
insert into @VatReconCreditSalesTransReport
exec VI_ReconExportCreditSalesReport @FromDate,@ToDate,@tenantid

declare @totalless decimal(18,2)
set @totalless=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0)) from @VatReconCreditSalesTransReport t1 cross join @VatReconCreditSalesTransReport t2 cross join @VatReconCreditSalesTransReport t3 cross join @VatReconCreditSalesTransReport t4 
where t1.id=6 and t2.id=7 and t3.id=8 and t4.id=9)

update @VatReconCreditSalesTransReport
set amount=@totalless where id=9

--              (10,'Net total',8,8,5),
insert into @VatReconCreditSalesTransReport

select 10,'Net Total',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconCreditSalesTransReport t1 cross join @VatReconCreditSalesTransReport t2 
where t1.id=3 and t2.id=9

insert into @VatReconCreditSalesTransReport values(11,'',null,null,6)

--insert into @VatReconCreditSalesTransReport values(12,'',0,0,6)
insert into @VatReconCreditSalesTransReport values(12,'LESS: ',null,null,1)
--			  (13,'Credit Notes reported under ADJUSTMENTS',11,11,2),
insert into @VatReconCreditSalesTransReport
exec VI_ReconCreditNotesSetOffAgainstSupplies  @FromDate,@ToDate,@tenantid

--			  (14,'Net Sales Credit Notes',15,15,4),
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

select * from @VatReconCreditSalesTransReport

end
GO
