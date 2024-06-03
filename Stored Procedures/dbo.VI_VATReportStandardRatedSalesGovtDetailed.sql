SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[VI_VATReportStandardRatedSalesGovtDetailed]   --EXEC   [VI_VATReportStandardRatedSalesGovtDetailed]  '2023-10-01', '2023-10-30' ,127
(@Fromdate date,    
 @Todate date,  
 @tenantId int=null  
) as    
begin    
    
  Select ROW_NUMBER() OVER(ORDER BY InvoiceNumber ASC) AS SlNo,
  BuyerName,
 Format(Issuedate,'dd-MM-yyyy') AS IssueDate,
CAST(IRNNo AS INT) AS  InvoiceNumber,    
isnull((case when (invoicetype like 'Sales Invoice%')      
        then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)     
        else 0 end) -     
        (case when (invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')     
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)     
     then isnull(LineNetAmount,0)    
        else 0 end) +    
  (case when (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')    
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)     
  then isnull(LineNetAmount,0)    
  else 0 end),0)    
 as NetAmount,    
        
      isnull((case when (invoicetype like 'Sales Invoice%') then     
               isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)     
                  else 0 end) -     
                 (case when invoicetype like 'Credit Note%' and     
                  (Transtype ='Sales' or Transtype = 'AdvanceReceipt') then (isnull(vatlineamount,0))    
                 else 0 end) +    
                (case when invoicetype like 'Debit Note%' and     
                (Transtype ='Sales' or Transtype = 'AdvanceReceipt') then (isnull(vatlineamount,0))    
                else 0 end)    
   ,0) as vatamount ,
   isnull((case when (invoicetype like 'Sales Invoice%')      
        then isnull(LineAmountInclusiveVAT,0)-isnull(AdvanceRcptAmtAdjusted,0)     
        else 0 end) -     
        (case when (invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')     
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)     
     then isnull(LineAmountInclusiveVAT,0)    
        else 0 end) +    
  (case when (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')    
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)     
  then isnull(LineAmountInclusiveVAT,0)    
  else 0 end),0)    
 as TotalAmount
 from VI_importstandardfiles_Processed sales    
 where  ((invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt')) or     
 (invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt'))    
 or (Invoicetype like 'Sales Invoice%'     
)) and vatcategorycode = 'S'     
and OrgType = 'GOVERNMENT' and left(BuyerCountryCode,2) = 'SA'       
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId;    
    
end
GO
