SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[VI_VATReportImportSubjecttoRCM15]   
(  
@fromdate date,  
@todate date,
@tenantId int=null
)  
as  
Begin  
  
select 13,'9. Imports subject to VAT accounted for through reverse charge mechanism 15%',

isnull(sum((case when (invoicetype like 'Purchase Entry%')   
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)   
 else 0 end) -   
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate   
   then 0-(isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))   
 else 0 end) +   
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplydate <= @todate   
   then 0-(isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))   
 else 0 end)),0) as amount, 
 
      isnull(sum((case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate < @fromdate then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)) else 0 end)-  
   (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate < @fromdate    
   then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))  
 else 0 end)),0) as adjamount,  

      0 as vatamount  

 from VI_importstandardfiles_Processed sales  
 where  ((invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment')) or  
         (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment')) or Invoicetype like 'Purchase Entry%')   
--and  left(BuyerCountryCode,2) <> 'SA' and VatRate=15  and (VATDeffered =1 or RCMApplicable =1)    -- commented on 05-mar-2024
and   VatRate=15  and (VATDeffered =1 or RCMApplicable =1)    -- added on 05-mar-2024
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;  
end
GO
