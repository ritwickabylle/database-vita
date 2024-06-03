SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[VI_VATReportImportSubjecttoRCM5Detailed]     --EXEC [VI_VATReportImportSubjecttoRCM5Detailed] '2023-10-01', '2023-10-30' ,127
(    
@fromdate date,    
@todate date,  
@tenantId int=null  
)    
as    
Begin    
    
 Select ROW_NUMBER() OVER(ORDER BY InvoiceNumber ASC) AS SlNo,
 BuyerName,
 Format(Issuedate,'dd-MM-yyyy'),
 CAST(IRNNO AS INT) AS InvoiceNumber
 ,isnull((case when (invoicetype like 'Purchase Entry%')     
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)     
 else 0 end) -     
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate     
   then 0-(isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))     
 else 0 end) +     
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate >= @fromdate and OrignalSupplyDate <= @todate     
   then 0-(isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))     
 else 0 end),0) as NetAmount,    
          
      0 as vatamount   ,
	  isnull((case when (invoicetype like 'Purchase Entry%')     
      then isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0)+isnull(customSPAID,0)+isnull(excisetaxpaid,0)+isnull(otherchargespaid,0)     
 else 0 end) -     
      (case when (invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate     
   then 0-(isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0))     
 else 0 end) +     
      (case when (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment'))     
   and OrignalSupplyDate >= @fromdate and OrignalSupplyDate <= @todate     
   then 0-(isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0))     
 else 0 end),0) as NetAmount
 from VI_importstandardfiles_Processed sales    
 where  ((invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment')) or     
          (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment')) or Invoicetype like 'Purchase Entry%')     
and  left(BuyerCountryCode,2) <> 'SA' and VatRate=5  and (VATDeffered =1 or RCMApplicable =1)    
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;    
end
GO
