SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReportZeroRatedPurchases]   
(  
@fromdate date,  
@todate date,
@tenantId int=NULL
)  
as  
Begin  
  
select 15,'10. Zero rated purchases',isnull(sum((case when (invoicetype like 'Purchase Entry%')   
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)   
 else 0 end) -   
      (case when (invoicetype like 'CN Purchase%')   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate   
   then 0-(isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))   
 else 0 end) +
 (case when (invoicetype like 'DN Purchase%')   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate   
   then 0-(isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))   
 else 0 end)
 ),0) as amount,  
      isnull(sum((case when (invoicetype like 'CN Purchase%')   
   and OrignalSupplyDate < @fromdate    
   then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))   
      else 0 end) -
	  (case when (invoicetype like 'DN Purchase%')   
   and OrignalSupplyDate < @fromdate    
   then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))   
      else 0 end)
	  ),0) as adjamount,  
      isnull(sum((case when (invoicetype like 'Purchase Entry%') then   
   isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)   
      else 0 end) -  
      (case when (invoicetype like 'CN Purchase%' )   
   then 0-(isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))   
 else 0 end) +
 (case when (invoicetype like 'DN Purchase%' )   
   then 0-(isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))   
 else 0 end)
 ),0) as vatamount  
 from VI_importstandardfiles_Processed sales  
 where  (invoicetype like 'CN Purchase%' or invoicetype like 'DN Purchase%' or Invoicetype like 'Purchase Entry%')   
 and vatcategorycode = 'Z'  
--and BuyerCountryCode = 'SA'   
and VatRate=0    
and effdate >= @fromdate and effdate <= @todate 
and TenantId=@tenantId;  
end
GO
