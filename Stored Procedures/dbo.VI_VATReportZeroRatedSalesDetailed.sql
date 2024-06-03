SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE         procedure [dbo].[VI_VATReportZeroRatedSalesDetailed]    --EXEC  [VI_VATReportZeroRatedSalesDetailed] '2023-10-01', '2023-10-30' ,127
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
BuyerName ,
 Format(Issuedate,'dd-MM-yyyy') AS IssueDate,
CAST(IRNNO AS INT) AS InvoiceNumber
 ,isnull((case when (invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt'))     
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)     
 else 0 end) -     
      (case when invoicetype like 'Credit Note%' and (transtype = 'Sales' or transtype='AdvanceReceipt')     
   and OrignalSupplydate >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0))     
 else 0 end) +     
      (case when invoicetype like 'Debit Note%' and (transtype = 'Sales' or transtype='AdvanceReceipt')     
   and OrignalSupplydate >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0))     
 else 0 end),0) as NetAmount,    
       
      isnull((case when (invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt')) then     
   isnull(vatlineamount,0)-isnull(vatonadvancercptamtadjusted,0)     
 else 0 end) -    
      (case when invoicetype like 'Credit Note%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt') then     
   (isnull(vatlineamount,0)) else 0 end)+    
      (case when invoicetype like 'Debit Note%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt') then     
   (isnull(vatlineamount,0)) else 0 end),0) as vatamount  ,

   isnull((case when (invoicetype like 'Sales Invoice%' and (Transtype = 'Sales' or TransType = 'AdvanceReceipt'))     
      then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted,0)     
 else 0 end) -     
      (case when invoicetype like 'Credit Note%' and (transtype = 'Sales' or transtype='AdvanceReceipt')     
   and OrignalSupplydate >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0))     
 else 0 end) +     
      (case when invoicetype like 'Debit Note%' and (transtype = 'Sales' or transtype='AdvanceReceipt')     
   and OrignalSupplydate >= @fromdate and OrignalSupplyDate  <= @todate     
   then (isnull(LineNetAmount,0))     
 else 0 end),0) as TotalAmount
 from VI_importstandardfiles_Processed sales    
 where  (invoicetype like 'Credit Note%' or Invoicetype like 'Sales Invoice%' or Invoicetype like 'Debit Note%') and vatcategorycode = 'Z'    
and left(BuyerCountryCode,2) = 'SA' and VatRate=0      
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ; 

  SELECT * FROM @temp WHERE NetAmount<> 0 

end
GO
