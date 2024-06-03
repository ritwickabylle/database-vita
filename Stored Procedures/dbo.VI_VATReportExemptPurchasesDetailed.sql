SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[VI_VATReportExemptPurchasesDetailed]     --EXEC [VI_VATReportExemptPurchasesDetailed] '2023-10-01', '2023-10-30' ,127
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
 ,isnull((case when (invoicetype like 'Purchase Entry%')     
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)     
 else 0 end) -     
      (case when invoicetype like 'CN Purchase%'      
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))    
 else 0 end) +     
      (case when invoicetype like 'DN Purchase%'     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0))        
 else 0 end),0) as NetAmount,    
       
      isnull((case when (invoicetype like 'Purchase Entry%') then     
   isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)     
 else 0 end) -    
      (case when (invoicetype like 'CN Purchase%')     
   then 0-(isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))     
 else 0 end)+    
      (case when (invoicetype like 'DN Purchase%')     
   then 0-(isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))     
 else 0 end),0) as vatamount , 
 
 isnull((case when (invoicetype like 'Purchase Entry%')     
      then isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0)     
 else 0 end) -     
      (case when invoicetype like 'CN Purchase%'      
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0))    
 else 0 end) +     
      (case when invoicetype like 'DN Purchase%'     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0))        
 else 0 end),0) as TotalAmount
 from VI_importstandardfiles_Processed sales    
 where  (invoicetype like 'CN Purchase%'  or    
 invoicetype like 'DN Purchase%'    
 or Invoicetype like 'Purchase Entry%')     
 and vatcategorycode = 'E'    
and left(BuyerCountryCode,2) = 'SA' and VatRate=0      
and effdate >= @fromdate and effdate <= @todate   
and TenantId=@tenantId;    
end
GO
