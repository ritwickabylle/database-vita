SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[VI_RefereshSalesSummaryData]    -- exec VI_RefereshSalesSummaryData 33  
(  
@tenantId int=null
)  
as  
Begin  
--  select * from apportionmentbasedata
declare @fromdate as datetime,
@todate as datetime


declare @SummarySales as table  
(Amount decimal(18,2),  
effmonth nvarchar(2),
effyear nvarchar(4),
Particular varchar(100)
)

declare @SummarySalesdata as table  
(taxableSupply decimal(18,2),
 exemptsupply decimal(18,2),
 totalsupply decimal(18,2),
 finyear nvarchar(9),
 type nvarchar(20),
 date nvarchar(20)
)  

declare @Avlcount int=0


set @fromdate = (select top 1 EffectiveFromDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid) --in (select tenantid from ImportBatchData where BatchId=@batchno))                  
                  
set @todate = (select top 1 EffectiveTillEndDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid)  --in (select tenantid from ImportBatchData where BatchId=@batchno))                  

--select * from apportionmentbasedata 

--select * from VI_importstandardfiles_Processed 

insert into @SummarySales(Amount,effmonth,effyear,Particular)
select  isnull(sum((case when (invoicetype like 'Sales Invoice%')    
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)   
        else 0 end) -   
        (case when (invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')   
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
     then isnull(LineNetAmount,0)  
        else 0 end) +  
  (case when (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')  
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
  then isnull(LineNetAmount,0)  
  else 0 end)),0)  
 as amount,  
 month(effdate) as effmonth,
 year(effdate) as effyear,
 'Taxable'  
 from VI_importstandardfiles_Processed   
 where  ((invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')) or   
 (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt'))  
 or (Invoicetype like 'Sales Invoice%'   
)) and vatcategorycode = 'S'  
and left(BuyerCountryCode,2) = 'SA' and VatRate=15    
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId
group by year(effdate),month(effdate)

select month(effdate),year(effdate),effdate from vi_importoverheadfiles_processed  
insert into @SummarySales(Amount,effmonth,effyear,Particular)
select  isnull(sum((case when (invoicetype like 'Sales Invoice%')    
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)   
        else 0 end) -   
        (case when (invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')   
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
     then isnull(LineNetAmount,0)  
        else 0 end) +  
  (case when (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')  
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
  then isnull(LineNetAmount,0)  
  else 0 end)),0)  
 as amount,  
 month(effdate) as effmonth,
 year(effdate) as effyear,
 'Total'  
 from VI_importstandardfiles_Processed   
 where  ((invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')) or   
 (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt'))  
 or (Invoicetype like 'Sales Invoice%'   
)) and vatcategorycode in ('S','E')  and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId
group by year(effdate),month(effdate)



set @AvlCount = (select  COUNT(TYPE)  from ApportionmentBaseData where tenantid = @tenantid and type = 'Current' and date in 
(select effmonth + '-' + effyear from @summarysales))
if @avlcount > 0 
begin
 delete from ApportionmentBaseData where tenantid = @tenantid and type = 'Current' and date in (select effmonth + '-' + effyear from @summarysales)
 delete from ApportionmentBaseData where tenantid = @tenantid and type = 'Current' and date ='Total'
end


insert into @SummarySalesdata (taxableSupply,exemptsupply,totalsupply,finyear, type, date)
 select 0,0,amount,cast(year(@fromdate) as nvarchar(4)) +'-'+ cast(year(@todate) as nvarchar(4)),'Total',
 effmonth+'-'+effyear from @SummarySales where Particular = 'Total'

insert into @SummarySalesdata (taxableSupply,exemptsupply,totalsupply,finyear, type, date)
 select amount,0,0,cast(year(@fromdate) as nvarchar(4)) +'-'+ cast(year(@todate) as nvarchar(4)),'Taxable',
 effmonth+'-'+effyear from @SummarySales where Particular = 'Taxable'

 
 INSERT INTO ApportionmentBaseData           
 (UniqueIdentifier,TenantId, [TaxableSupply], [ExemptSupply], [TotalExemptSales], TaxablePurchase, [ExemptPurchase], [TotalExemptPurchase],
 [ApportionmentSupplies],[ApportionmentPurchases],[Type], [Date],CreationTime,IsDeleted,FinYear,EffectiveFromDate,EffectiveTillEndDate,TotalSupply,
 TotalPurchase ) 
 
 select newid(),@tenantid,sum(taxableSupply),sum(totalsupply-taxablesupply),0,0,0,0,0,0,'Current',date,getdate(),0, finyear, @fromdate, @todate,sum(totalsupply), 0 from @SummarySalesData group by date,finyear

 INSERT INTO ApportionmentBaseData           
 (UniqueIdentifier,TenantId, [TaxableSupply], [ExemptSupply], [TotalExemptSales], TaxablePurchase, [ExemptPurchase], [TotalExemptPurchase],
 [ApportionmentSupplies],[ApportionmentPurchases],[Type], [Date],CreationTime,IsDeleted,FinYear,EffectiveFromDate,EffectiveTillEndDate,TotalSupply,
 TotalPurchase )            
 select newid(),@tenantid,sum(taxableSupply),sum(totalsupply-taxablesupply),0,0,0,0,0,0,'Current','Total',getdate(),0,
 finyear,@fromdate,@todate,sum(totalsupply),0 from @SummarySalesData group by finyear

 update ApportionmentBaseData set ApportionmentSupplies = round(TaxableSupply / totalsupply * 100,2) where tenantid = @tenantid and 
 finyear = cast(year(@fromdate) as nvarchar(4)) +'-'+ cast(year(@todate) as nvarchar(4)) and date = 'Total' and type = 'Current'
 


end

--select cast(month(effdate) as nvarchar(2)) + '-' + cast(year(effdate) as nvarchar(4)) from vi_importoverheadfiles_processed 

--select * from ApportionmentBaseData 
GO
