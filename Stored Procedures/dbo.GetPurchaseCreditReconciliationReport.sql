SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[GetPurchaseCreditReconciliationReport]  --exec GetPurchaseCreditReconciliationReport '2023-02-01','2023-02-28',33
(
@FromDate datetime,
@ToDate datetime,
@tenantId int=null
)
as
begin 
declare @VatReconCreditPurchaseTransReport as table  
(id int,  
Description varchar(100),  
InnerAmount decimal (18,2),  
Amount decimal (18,2),  
style int  
)  

insert into @VatReconCreditPurchaseTransReport  
--values(1,'Sales as Per Detailed Sales Report',0,1000,2) 
exec VI_VATReconReportCreditPurchaseReport @Fromdate, @Todate,@tenantId   

insert into @VatReconCreditPurchaseTransReport values(2,'',null,null,6)
insert into @VatReconCreditPurchaseTransReport values(3,'LESS: ',null,null,1)

--			  (4,'Exempt Supplies',4,4,3),
insert into @VatReconCreditPurchaseTransReport
exec VI_ReconExemptCreditPurchaseReport @FromDate,@ToDate,@tenantid

--			  (5,'ZERO Rated Supplies',5,5,3),
insert into @VatReconCreditPurchaseTransReport
exec VI_ReconZeroRatedCreditPurchaseReport @FromDate,@ToDate,@tenantid

--			  (6,'Out of Scope Supplies',6,6,3),
insert into @VatReconCreditPurchaseTransReport
exec VI_ReconOutofScopeSCreditPurchaseReport @FromDate,@ToDate,@tenantid

--	  (7,'Export Supplies',7,7,3),
insert into @VatReconCreditPurchaseTransReport
exec VI_ReconExportCreditPurchaseReport @FromDate,@ToDate,@tenantid

---------------------------------------------------------------------------------

declare @totalless decimal(18,2)
set @totalless=(select (isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)+isnull(t4.InnerAmount,0)) from @VatReconCreditPurchaseTransReport t1 cross join @VatReconCreditPurchaseTransReport t2 cross join @VatReconCreditPurchaseTransReport t3 cross join @VatReconCreditPurchaseTransReport t4 
where t1.id=4 and t2.id=5 and t3.id=6 and t4.id=7)

update @VatReconCreditPurchaseTransReport
set amount=@totalless where id=7

----(8,'Total Credit Notes Set off Against Supplies',14,14,4)
insert into @VatReconCreditPurchaseTransReport 

select 8,'Net Purchase Credit Notes',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,4 from @VatReconCreditPurchaseTransReport t1 cross join @VatReconCreditPurchaseTransReport t2 
where t1.id=1 and t2.id=7 

insert into @VatReconCreditPurchaseTransReport 

select 9,'Total Credit Notes Set off Against Purchase',null,(isnull(t1.Amount,0)-isnull(t2.Amount,0)) as amount,2 from @VatReconCreditPurchaseTransReport t1 
cross join @VatReconCreditPurchaseTransReport t2 
where t1.id=1 and t2.id=7  

select * from @VatReconCreditPurchaseTransReport

end
GO
