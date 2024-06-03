SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[VI_VATReportImportSubjecttoVATPaid15]  -- exec [VI_VATReportImportSubjecttoVATPaid15] '2023-03-01','2023-03-31',148 
(  
@fromdate date,  
@todate date,
@tenantId int=null
)  
as  
Begin  
  
select 11,'8. Imports subject to VAT paid at customs 15%',

isnull(sum((case when (invoicetype like 'Purchase%')   
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)   
 else 0 end) -   
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate   
   then (isnull(LineNetAmount,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))   
else 0 end) +   
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate   
   then (isnull(LineNetAmount,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))     
 else 0 end)),0) as amount,  


      isnull(sum((case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate < @fromdate    
   then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))   
 else 0 end) -  
       (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   and OrignalSupplyDate < @fromdate    
   then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))   
 else 0 end)),0) as adjamount,  


      isnull(sum((case when (invoicetype like 'Purchase%') then   
   isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)   
      else 0 end) -  
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   then (isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))   
  else 0 end) +  
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))   
   then (isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))   
 else 0 end)),0) as vatamount 
 
 from VI_importstandardfiles_Processed sales  
 where  (invoicetype like 'CN Purchase%' or  
 invoicetype like 'DN Purchase%' or Invoicetype like 'Purchase%')   
and  left(BuyerCountryCode,2) <> 'SA' and VatRate=15  and VATDeffered =0 and RCMApplicable =0  
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;  
end  

--select * from VI_ImportstandardFiles_Processed where batchid = 1156    and left(BuyerCountryCode,2) <> 'SA' and VatRate=15  and VATDeffered =0 and RCMApplicable =0  and InvoiceType = 'CN Purchase-Imports' and VatCategoryCode = 'S'
--select * from VI_ImportstandardFiles_Processed where batchid = 1155   and left(BuyerCountryCode,2) <> 'SA' and VatRate=15  and VATDeffered =0 and RCMApplicable =0  
--and InvoiceType = 'Purchase Entry-Imports' 
GO
