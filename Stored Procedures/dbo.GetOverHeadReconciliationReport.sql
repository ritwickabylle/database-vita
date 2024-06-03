SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[GetOverHeadReconciliationReport]  --exec GetOverHeadReconciliationReport '2023-02-01','2023-02-28',41  
(  
@FromDate datetime,  
@ToDate datetime,  
@tenantId int=null  
)  
as  
begin   
declare @VatReconOverheadTransReport as table    
(id int,    
Description varchar(100),    
InnerAmount decimal (18,2),    
Amount decimal (18,2),    
style int    
)    
  
insert into @VatReconOverheadTransReport    
--values(1,'Sales as Per Detailed Sales Report',0,1000,2)   
exec VI_VATReconReportOverheadReport @Fromdate, @Todate,@tenantId     
  
  
insert into @VatReconOverheadTransReport values(2,'',null,null,6)  
insert into @VatReconOverheadTransReport values(3,'LESS: ',null,null,1)  
  
-----------------------------------------------------------------------------------------  
  
insert into @VatReconOverheadTransReport  
exec VI_ReconExemptOverheadReport @FromDate,@ToDate,@tenantid  
  
insert into @VatReconOverheadTransReport  
exec VI_ReconOutofScopeOverheadReport @FromDate,@ToDate,@tenantid  
  
insert into @VatReconOverheadTransReport  
exec VI_ReconRestrictedOverheadReport @FromDate,@ToDate,@tenantid  
  
insert into @VatReconOverheadTransReport  
select 7,'Net Overheads for Allocation Computation',null,(isnull(t1.InnerAmount,0)+isnull(t2.InnerAmount,0)+isnull(t3.InnerAmount,0)) as amount,4 from @VatReconOverheadTransReport t1 cross join @VatReconOverheadTransReport t2 cross join @VatReconOverheadTransReport t3  
where t1.id=4 and t2.id=5and t3.id=6  
  
insert into @VatReconOverheadTransReport values(8,'',null,null,6)  

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

insert into @VatReconOverheadTransReport
select 9,'Taxable Supplies for the VAT Period',null,(isnull(t1.Amount,0)+isnull(t2.Amount,0)+isnull(t3.Amount,0)) as amount,4 from @VatReport t1 cross join @VatReport t2 cross join @VatReport t3 
where t1.id=1 and t2.id=2 and t3.id=3


insert into @VatReport(id,vatDescription,amount,AdjustmentAmount,VatAmount)   
exec VI_VATReportExemptedSales @fromdate, @todate,@tenantId

insert into @VatReconOverheadTransReport
select 10,'Exempt Supplies for the VAT Period',null,(isnull(t1.Amount,0)) as amount,4 from @VatReport t1  
where t1.id=7

insert into @VatReconOverheadTransReport  
select 11,'Taxable + Exempt Supplies for the VAT Period',null,(isnull(t1.Amount,0)+isnull(t2.Amount,0)) as amount,4 from @VatReconOverheadTransReport t1 cross join @VatReconOverheadTransReport t2   
where t1.id=9 and t2.id=10   

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  
insert into @VatReconOverheadTransReport values(12,'',null,null,6)  
  
insert into @VatReconOverheadTransReport   
select 13,'Taxable to Taxable + Exempt Supplies ',null,(isnull(t1.Amount,0)/isnull(t2.Amount,0))*100 as amount,4 from @VatReconOverheadTransReport t1 cross join @VatReconOverheadTransReport t2   
where t1.id=9 and t2.id=11
  
insert into @VatReconOverheadTransReport values(14,'',null,null,6)  
  
insert into @VatReconOverheadTransReport  
select 15,'Net Overheads considered for VAT Return',null,(isnull(t1.Amount,0)*isnull(t2.Amount,0)) as amount,2 from @VatReconOverheadTransReport t1 cross join @VatReconOverheadTransReport t2   
where t1.id=13 and t2.id=7   

insert into @VatReconOverheadTransReport values(16,'',null,null,6) 

select * from @VatReconOverheadTransReport
end
GO
