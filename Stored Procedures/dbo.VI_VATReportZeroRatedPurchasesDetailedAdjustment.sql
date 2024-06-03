SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE         procedure [dbo].[VI_VATReportZeroRatedPurchasesDetailedAdjustment]     --EXEC [VI_VATReportZeroRatedPurchasesDetailedAdjustment] '2023-10-01', '2023-10-30' ,127
(    
@fromdate date,    
@todate date,  
@tenantId int=NULL  
)    
as    
Begin    
 declare @temp table
(
	SlNo INT,
	BuyerName NVARCHAR(MAX),
	IssueDate NVARCHAR(MAX),
	InvoiceNumber INT,
	NetAmount INT,
	VatAmount INT,
	TotaLAmount INT
	)
INSERT INTO @temp      
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
 where  (invoicetype like 'CN Purchase%' or invoicetype like 'DN Purchase%' or Invoicetype like 'Purchase Entry%')     
 and vatcategorycode = 'Z'    
--and BuyerCountryCode = 'SA'     
and VatRate=0      
and effdate >= @fromdate and effdate <= @todate   
and TenantId=@tenantId;    

  SELECT * FROM @temp WHERE NetAmount<> 0 

end
GO
