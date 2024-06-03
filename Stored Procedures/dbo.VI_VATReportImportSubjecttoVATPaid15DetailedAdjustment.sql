SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[VI_VATReportImportSubjecttoVATPaid15DetailedAdjustment]   --EXEC   [VI_VATReportImportSubjecttoVATPaid15DetailedAdjustment] '2023-10-01', '2023-10-30' ,127
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

ISNULL((CASE WHEN (invoicetype LIKE 'CN Purchase%') AND (orignalsupplydate IS NULL OR OrignalSupplyDate < @fromdate)
            THEN (ISNULL(LineNetAmount, 0))
            ELSE 0 END) 
			- (CASE WHEN (invoicetype LIKE 'DN Purchase%') AND (orignalsupplydate IS NULL OR OrignalSupplyDate < @fromdate)
            THEN (ISNULL(LineNetAmount, 0))
			ELSE 0 END),0) AS adjnetamount,

ISNULL((CASE WHEN (invoicetype LIKE 'CN Purchase%') AND (orignalsupplydate IS NULL OR OrignalSupplyDate < @fromdate)
            THEN (ISNULL(VATLineAmount, 0))
            ELSE 0 END) 
			- (CASE WHEN (invoicetype LIKE 'DN Purchase%') AND (orignalsupplydate IS NULL OR OrignalSupplyDate < @fromdate)
            THEN (ISNULL(VATLineAmount, 0))
			ELSE 0 END),0) AS adjvatamount,

ISNULL((CASE WHEN (invoicetype LIKE 'CN Purchase%') AND (orignalsupplydate IS NULL OR OrignalSupplyDate < @fromdate)
            THEN (ISNULL(LineAmountInclusiveVAT, 0))
            ELSE 0 END) 
			- (CASE WHEN (invoicetype LIKE 'DN Purchase%') AND (orignalsupplydate IS NULL OR OrignalSupplyDate < @fromdate)
            THEN (ISNULL(LineAmountInclusiveVAT, 0))
			ELSE 0 END),0) AS adjtotalamount

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
