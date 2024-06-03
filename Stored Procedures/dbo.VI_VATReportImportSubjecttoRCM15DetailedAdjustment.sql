SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VI_VATReportImportSubjecttoRCM15DetailedAdjustment]     --EXEC [VI_VATReportImportSubjecttoRCM15DetailedAdjustment] '2023-10-01', '2023-10-30' ,127
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
 CAST(IRNNO AS INT) AS InvoiceNumber,
	isnull((case when invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt') and (orignalsupplydate is null or orignalSupplydate < @fromdate)
        then (isnull(LineNetAmount,0))
        else 0 end),0) - 
	isnull(
    (case when invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt') and (orignalsupplydate is null or orignalSupplydate < @fromdate)
        then (isnull(LineNetAmount,0))
        else 0
    end), 0) as adjnetamount,

	isnull((case when invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt') and (orignalsupplydate is null or orignalSupplydate < @fromdate)
        then (isnull(VATLineAmount,0))
        else 0 end),0) - 
	isnull(
    (case when invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt') and (orignalsupplydate is null or orignalSupplydate < @fromdate)
        then (isnull(VATLineAmount,0))
        else 0
    end), 0) as adjvatamount,

		isnull((case when invoicetype like 'Credit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt') and (orignalsupplydate is null or orignalSupplydate < @fromdate)
        then (isnull(LineAmountInclusiveVAT,0))
        else 0 end),0) - 
	isnull(
    (case when invoicetype like 'Debit Note%' and (Transtype ='Sales' or Transtype = 'AdvanceReceipt') and (orignalsupplydate is null or orignalSupplydate < @fromdate)
        then (isnull(LineAmountInclusiveVAT,0))
        else 0
    end), 0) as adjtotalamount

 from VI_importstandardfiles_Processed sales    
 where  ((invoicetype like 'CN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment')) or    
         (invoicetype like 'DN Purchase%' and (Transtype = 'Purchases' or Transtype = 'AdvancePayment')) or Invoicetype like 'Purchase Entry%')     
and  left(BuyerCountryCode,2) <> 'SA' and VatRate=15  and (VATDeffered =1 or RCMApplicable =1)    
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;    
end
GO
