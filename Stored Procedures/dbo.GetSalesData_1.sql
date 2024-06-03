SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create    PROCEDURE [dbo].[GetSalesData_1]    --exec GetSalesData '2022-08-01','2023-08-08',127 ,null,null,null,null,'test',null,null               
@fromDate DATETIME,    
@toDate DATETIME,                        
@tenantId INT,      
@creationDate DATETIME = NULL,    
@customername NVARCHAR(MAX) = NULL,
@salesorderno NVARCHAR(MAX) = NULL,
@purchaseorderno NVARCHAR(MAX) = NULL,
@invoicerefno NVARCHAR(MAX) = NULL,
@buyercode NVARCHAR(MAX) =  NULL,        
@shippedcode NVARCHAR(MAX) = NULL        
AS     
BEGIN    

declare @salesordernumber nvarchar(max)  
declare @purchaseordernumber nvarchar(max)  
declare @shiptonumber nvarchar(max)
declare @exchangeRate nvarchar(max)

select * into #exchangeRate from (                
 select                       
(select exchangeRate from openjson(additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate')) as  ExchangeRate ,TenantId,IRNNo               
from                       
  SalesInvoice) as t;

SELECT
isnull(s.BillingReferenceId,'') as Invoice_Reference_Number,s.PdfUrl as pdf,  
(select invoiceRefDate from openjson(s.additionaldata2) with (invoiceRefDate nvarchar(max) '$.invoice_reference_date')) as  Invoice_Reference_Date,  
b.RegistrationName as Customer_Name, c.ContactNumber + ' ' +c.Email as Contact_Details,
case when s.PdfUrl is null then 'Einvoice not created' else 'Einvoice created' end as [Status], s.InvoiceCurrencyCode as Currency,
case when i.VatRate <> 0 
then
case when s.InvoiceCurrencyCode in ('SAR')
then (i.LineAmountInclusiveVAT + isnull(ii.UnitPrice,0) + (isnull(ii.UnitPrice,0) * isnull(i.VatRate/100,1)))
else
((i.LineAmountInclusiveVAT / (cast(isnull(r.ExchangeRate,1) as float))) + (isnull(ii.UnitPrice,0)/ (cast(isnull(r.ExchangeRate,1) as float))) + ((isnull(ii.UnitPrice,0)/(cast(isnull(r.ExchangeRate,1) as float))) * isnull(i.VatRate/100,1)))
end 
else 
case when s.InvoiceCurrencyCode in ('SAR')
then
(i.LineAmountInclusiveVAT + isnull(ii.UnitPrice,0)) 
else
(i.LineAmountInclusiveVAT / (cast(isnull(r.ExchangeRate,1) as decimal(18,2)))) + (isnull(ii.UnitPrice,0))  
end
end
as Amount,

ISNULL(s.AdditionalData2,'0') AS AdditionalData2,
s.IRNNo as Invoice_Number,
cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as Invoice_Date,
(select ISNULL(salesorderno,0) from openjson(s.additionaldata2) with (salesorderno nvarchar(max) '$.original_order_number')) as Sales_Order_Number,
(select ISNULL(purchaseorderno,0) from openjson(s.additionaldata2) with (purchaseorderno nvarchar(max) '$.purchase_order_no')) as Purchase_Order_Number,
ISNULL(b.CustomerId, ' ') as Payer_Number, (select ISNULL(shiptonumber,0) from openjson(b.additionaldata1) with (shiptonumber nvarchar(max) '$.crNumber')) as Ship_To_Number,
s.CreationTime  
INTO #invoice    
FROM                       
  salesinvoice s  WITH (NOLOCK)
  INNER JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,max(Vatrate) as VatRate
  FROM SalesInvoiceItem   WITH (NOLOCK)
  GROUP BY IRNNo,TenantId) i ON s.IRNNo = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0)

  left JOIN (SELECT SUM(UnitPrice) AS UnitPrice,IRNNo,TenantId
  FROM SalesInvoiceItem   WITH (NOLOCK) where isOtherCharges = 1                  
  GROUP BY IRNNo,TenantId) ii ON s.IRNNo = ii.IRNNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0)

  INNER JOIN IRNMaster m WITH (NOLOCK) ON s.IRNNo = m.IRNNo   AND ISNULL(m.tenantid,0)=ISNULL(@tenantId,0) 

  INNER JOIN #exchangeRate r WITH (NOLOCK) ON s.IRNNo = r.IRNNo   AND ISNULL(r.tenantid,0)=ISNULL(@tenantId,0)
  
  INNER JOIN SalesInvoiceParty b WITH (NOLOCK) ON s.IRNNo = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantId,0)                    
  AND b.Type = 'Buyer' AND ISNULL(b.Language,'EN')='EN'                       
  inner join SalesInvoiceContactPerson c with (nolock) on s.IRNNo = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantId,0)                    
  and c.Type = 'Buyer'  AND ISNULL(b.Language,'EN')='EN'       
  inner join SalesInvoiceParty su with (nolock) on s.IRNNo = su.IRNNo   and Isnull(su.tenantid,0)=isnull(@tenantId,0)                    
  and su.Type = 'Supplier'     AND ISNULL(b.Language,'EN')='EN'     
  inner join logs_xml lg on s.Additional_Info=lg.uuid
  where CAST(s.IssueDate AS DATE)>=CAST(@fromDate as Date) and CAST(s.IssueDate AS DATE)<= CAST(@toDate as Date);     

  IF(@customername IS NOT NULL)    
  BEGIN    
  DELETE FROM #invoice  WHERE Customer_Name not LIKE '%'+ @customername+'%';    
  END    

  IF(@creationDate IS NOT NULL)    
  BEGIN    
  DELETE FROM #invoice WHERE AdditionalData2 IS NOT NULL and AdditionalData2 NOT LIKE '%"invoice_reference_date":"'+cast(format(@creationDate,'yyyy-MM-dd') as nvarchar)+'"%';    
  END    

  IF(@salesorderno IS NOT NULL)     
  BEGIN    
  DELETE FROM #invoice WHERE AdditionalData2 IS NOT NULL AND AdditionalData2 NOT like '%"original_order_number":"'+@salesorderno+'"%';    
  END    

  IF(@purchaseorderno IS NOT NULL)    
  BEGIN    
  DELETE FROM #invoice WHERE AdditionalData2 IS NOT NULL and AdditionalData2 NOT LIKE '%"purchase_order_no":"'+@purchaseorderno+'"%';    
  END   
  
   IF(@buyercode IS NOT NULL)    
  BEGIN    
  DELETE FROM #invoice WHERE Payer_Number <> @buyercode;    
  END 

  IF(@invoicerefno IS NOT NULL)    
  BEGIN    
  DELETE FROM #invoice WHERE Invoice_Reference_Number <> @invoicerefno;    
  END    

  IF(@shippedcode IS NOT NULL)    
  BEGIN    
  DELETE FROM #invoice WHERE Ship_To_Number IS NOT NULL and Ship_To_Number NOT LIKE '%'+@shippedcode+'%';    
  END    

  SELECT * FROM #invoice  ORDER BY CreationTime desc

  IF OBJECT_ID('tempdb..#invoice') IS NOT NULL DROP TABLE #invoice 
    IF OBJECT_ID('tempdb..#exchangeRate') IS NOT NULL DROP TABLE #exchangeRate 
	end
GO
