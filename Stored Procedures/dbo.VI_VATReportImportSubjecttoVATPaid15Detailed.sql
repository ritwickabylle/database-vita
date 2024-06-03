SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VI_VATReportImportSubjecttoVATPaid15Detailed]     --EXEC VI_VATReportImportSubjecttoVATPaid15Detailed '2023-10-01', '2023-10-30' ,127
(    
@fromdate date,    
@todate date,  
@tenantId int=null  
)    
as    
Begin    
    
 Select ROW_NUMBER() OVER(ORDER BY InvoiceNumber ASC) AS SlNo,
 BuyerName,
 Format(Issuedate,'dd-MM-yyyy') AS IssueDate,
 CAST(IRNNO AS INT) AS InvoiceNumber
 ,isnull((case when (invoicetype like 'Purchase%')     
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)     
 else 0 end) -     
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))     
else 0 end) +     
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))     
    
 else 0 end),0) as NetAmount,    
       
      isnull((case when (invoicetype like 'Purchase%') then     
   isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)     
      else 0 end) -    
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   then (isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))     
  else 0 end) +    
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   then (isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))     
 else 0 end),0) as vatamount  ,
 isnull((case when (invoicetype like 'Purchase%')     
      then isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)     
 else 0 end) -     
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineAmountInclusiveVAT,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))     
else 0 end) +     
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineAmountInclusiveVAT,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0))     
    
 else 0 end),0) as TotalAmount
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
