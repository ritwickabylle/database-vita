SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE          procedure [dbo].[VI_VATReportStandardRatedPurchases5Detailed]     --EXEC [VI_VATReportStandardRatedPurchases5Detailed] '2022-07-01', '2022-07-31' ,127
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
 CAST(IRNNO AS INT) AS InvoiceNumber
 ,isnull((case when (invoicetype like 'Purchase Entry%')     
      then isnull(LineNetAmount ,0)-isnull(AdvanceRcptAmtAdjusted,0)     
 else 0 end) -     
      (case when (invoicetype like 'CN Purchase%')     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate     
   then (isnull(LineNetAmount,0))     
 else 0 end)  
 +     (case when (invoicetype like 'DN Purchase%')     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate     
   then (isnull(LineNetAmount,0))     
 else 0 end),0) as NetAmount,    
     
      isnull((case when (invoicetype like 'Purchase Entry%') then     
   isnull(vatlineamount,0)     
 else 0 end) -    
      (case when (invoicetype like 'CN Purchase%')     
   then 0-(isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))     
 else 0 end) +  
 (case when (invoicetype like 'DN Purchase%')     
   then 0-(isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0))     
 else 0 end),0) as vatamount ,
 isnull((case when (invoicetype like 'Purchase Entry%')     
      then isnull(LineAmountInclusiveVAT ,0)-isnull(AdvanceRcptAmtAdjusted,0)     
 else 0 end) -     
      (case when (invoicetype like 'CN Purchase%')     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate     
   then (isnull(LineAmountInclusiveVAT,0))     
 else 0 end)  
 +     (case when (invoicetype like 'DN Purchase%')     
   and OrignalSupplyDate  >= @fromdate and OrignalSupplyDate <= @todate     
   then (isnull(LineAmountInclusiveVAT,0))     
 else 0 end),0) as TotalAmount
 from VI_importstandardfiles_Processed sales    
 where  (invoicetype like 'CN Purchase%' or InvoiceType like 'DN Purchase%' or Invoicetype like 'Purchase Entry%')     
 and vatcategorycode = 'S'    
and  left(BuyerCountryCode,2) = 'SA' and VatRate=5      
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId     

  SELECT * FROM @temp WHERE NetAmount<> 0 

end
GO
