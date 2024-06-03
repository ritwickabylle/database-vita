SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[GetSalesDebitReconciliationReport]  --exec GetSalesDebitReconciliationReport '2023-02-01','2023-03-09',40
(
@FromDate datetime,
@ToDate datetime,
@tenantId int=null
)
as
begin 
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

--			  (4,'Exempt Supplies',4,4,3),
insert into @VatReconDebitSalesTransReport
exec VI_ReconExemptDebitSalesReport @FromDate,@ToDate,@tenantid

--			  (5,'ZERO Rated Supplies',5,5,3),
insert into @VatReconDebitSalesTransReport
exec VI_ReconZeroRatedDebitSalesReport @FromDate,@ToDate,@tenantid

--			  (6,'Out of Scope Supplies',6,6,3),
insert into @VatReconDebitSalesTransReport
exec VI_ReconOutofDebitScopeSalesReport @FromDate,@ToDate,@tenantid

--	  (7,'Export Supplies',7,7,3),
insert into @VatReconDebitSalesTransReport
exec VI_ReconExportDebitSalesReport @FromDate,@ToDate,@tenantid

---------------------------------------------------------------------------------

declare @totalless decimal(18,2)
set @totalless=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0)) from @VatReconDebitSalesTransReport t1 cross join @VatReconDebitSalesTransReport t2 cross join @VatReconDebitSalesTransReport t3 cross join @VatReconDebitSalesTransReport t4 
where t1.id=4 and t2.id=5 and t3.id=6 and t4.id=7)

update @VatReconDebitSalesTransReport
set amount=@totalless where id=7

----(8,'Total Credit Notes Set off Against Supplies',14,14,4)
insert into @VatReconDebitSalesTransReport 

select 8,'Total for Debit Notes-Sales',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconDebitSalesTransReport t1 cross join @VatReconDebitSalesTransReport t2 
where t1.id=1 and t2.id=7 

select * from @VatReconDebitSalesTransReport

end
GO
