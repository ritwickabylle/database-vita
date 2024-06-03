SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE         procedure [dbo].[VI_VATReportZeroRatedSalesDetailedAdjustment]     --EXEC [VI_VATReportZeroRatedSalesDetailedAdjustment] '2023-10-01', '2023-10-30' ,127
(    
@fromdate date,    
@todate date,  
@tenantId int=null  
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
 where  (invoicetype like 'Credit Note%' or Invoicetype like 'Sales Invoice%' or Invoicetype like 'Debit Note%') and vatcategorycode = 'Z'    
and left(BuyerCountryCode,2) = 'SA' and VatRate=0      
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;   
  SELECT * FROM @temp WHERE NetAmount<> 0 

end
GO
