SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE         procedure [dbo].[VI_VATReportStandardRatedSales5Detailed]     --EXEC VI_VATReportStandardRatedSales5Detailed '2020-06-01', '2023-10-30' ,130
(@Fromdate date,    
 @Todate date,  
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
	Format(Issuedate,'dd-MM-yyyy') as IssueDate,
	 CAST(IRNNO AS INT) AS InvoiceNumber,
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
   ,0) as vatamount,
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
and OrgType <> 'GOVERNMENT' and left(BuyerCountryCode,2) = 'SA' and VatRate=5      
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId ;  

SELECT * FROM @temp WHERE NetAmount<> 0 

end
GO
