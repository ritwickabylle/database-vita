SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE     PROCEDURE [dbo].[GetSalesData]    --exec GetSalesData '2023-08-01','2023-12-23',140 ,'2023-12-03',null,null,null,null,null,null,null,'an'                              
@fromDate DATETIME,                   
@toDate DATETIME,               
@tenantId INT,                     
@creationDate DATETIME = NULL,              
@customername NVARCHAR(MAX) = NULL,              
@salesorderno NVARCHAR(MAX) = NULL,              
@purchaseorderno NVARCHAR(MAX) = NULL,              
@invoicerefno NVARCHAR(MAX) = NULL,              
@buyercode NVARCHAR(MAX) =  NULL,              
@shippedcode NVARCHAR(MAX) = NULL,              
@IRNo NVARCHAR(MAX) = NULL,              
@createdby nvarchar(max)=NULL              
              
AS                    
BEGIN             
set nocount on            
Declare @tenancycode nvarchar(50)              
declare @salesordernumber nvarchar(max)              
declare @purchaseordernumber nvarchar(max)              
declare @shiptonumber nvarchar(max)              
declare @exchangeRate nvarchar(max)              
select @tenancycode=name from abptenants where id=@tenantId               
              
select * into #exchangeRate from (                                
 select                                       
(select iif(exchangeRate is not null and exchangeRate<>'',isnull(exchangeRate,'1'),'1')              
from openjson(additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate')) as  ExchangeRate ,TenantId,IRNNo                               
from SalesInvoice) as t;              
              
select * into #draftexchangeRate from (                                
 select                                       
(select iif(exchangeRate is not null and exchangeRate<>'',isnull(exchangeRate,'1'),'1')              
from openjson(additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate')) as  ExchangeRate ,TenantId,id                               
from draft) as t;              
              
select *  INTO #invoice from               
((SELECT isnull(s.BillingReferenceId,'') as Invoice_Reference_Number,              
s.PdfUrl as pdf,              
((select invoiceRefDate from openjson(s.additionaldata2) with (invoiceRefDate nvarchar(max) '$.invoice_reference_date'))) as  Invoice_Reference_Date,              
b.RegistrationName as Customer_Name,              
isnull(c.ContactNumber,'') + ' ' + isnull(c.Email,'') as Contact_Details,              
case when s.PdfUrl is null then 'Einvoice not created' else 'Einvoice created' end as [Status],              
s.InvoiceCurrencyCode as Currency,              
            
case when i.VatRate <> 0    
then   
 case when s.InvoiceCurrencyCode in ('SAR')               
 then (i.LineAmountInclusiveVAT + isnull(ii.LineAmountInclusiveVAT,0))  
 else (i.LineAmountInclusiveVAT+ isnull(ii.LineAmountInclusiveVAT,0)) end                
 else                
 case when s.InvoiceCurrencyCode in ('SAR') then (ISNULL(i.LineAmountInclusiveVAT,0) + isnull(ii.LineAmountInclusiveVAT,0))               
else (ISNULL(i.LineAmountInclusiveVAT,0) + isnull(ii.LineAmountInclusiveVAT,0))  end end as Amount,     
   
 ISNULL(s.AdditionalData2,'0') AS AdditionalData2,              
 s.IRNNo as Invoice_Number,              
 cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as Invoice_Date,              
 (select ISNULL(salesorderno,'') from openjson(s.additionaldata2) with (salesorderno nvarchar(max) '$.original_order_number')) as Sales_Order_Number,              
 (select ISNULL(purchaseorderno,'') from openjson(s.additionaldata2) with (purchaseorderno nvarchar(max) '$.purchase_order_no')) as Purchase_Order_Number,              
 ISNULL(b.CustomerId, ' ') as Payer_Number,              
 (select ISNULL(shiptonumber,'') from openjson(b.additionaldata1) with (shiptonumber nvarchar(max) '$.crNumber')) as Ship_To_Number,           
 isnull(s.[Source],' ') as Source,          
 case when s.CreatorUserId is null then              
 (select createdby from openjson(s.additionaldata4) with (createdby nvarchar(max) '$.created_by'))else              
  (SELECT Name from AbpUsers where id=s.creatorUserId) end as Created_By,  
    
 s.CreationTime as creationtime   
    
    FROM              
 salesinvoice s  WITH (NOLOCK)              
 INNER JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,max(Vatrate) as VatRate   FROM SalesInvoiceItem   WITH (NOLOCK) where isOtherCharges=0  GROUP BY IRNNo,TenantId) i ON s.IRNNo = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0)              
 left JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId   FROM SalesInvoiceItem   WITH (NOLOCK) where isOtherCharges = 1              
GROUP BY IRNNo,TenantId) ii ON s.IRNNo = ii.IRNNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0)              
INNER JOIN IRNMaster m WITH (NOLOCK) ON s.IRNNo = m.IRNNo   AND ISNULL(m.tenantid,0)=ISNULL(@tenantId,0)              
--INNER JOIN #exchangeRate r WITH (NOLOCK) ON s.IRNNo = r.IRNNo   AND ISNULL(r.tenantid,0)=ISNULL(@tenantId,0)              
INNER JOIN SalesInvoiceParty b WITH (NOLOCK) ON s.IRNNo = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantId,0)                       
AND b.Type = 'Buyer' AND ISNULL(b.Language,'EN')='EN'     
inner join SalesInvoiceContactPerson c with (nolock) on s.IRNNo = c.IRNNo and Isnull(c.tenantid,0)=isnull(@tenantId,0)and c.Type = 'Buyer'              
AND ISNULL(c.Language,'EN')='EN'              
inner join SalesInvoiceParty su with (nolock) on s.IRNNo = su.IRNNo   and Isnull(su.tenantid,0)=isnull(@tenantId,0) and su.Type = 'Supplier'     AND ISNULL(b.Language,'EN')='EN'              
   where CAST(s.IssueDate AS DATE)>=CAST(@fromDate as Date) and CAST(s.IssueDate AS DATE)<= CAST(@toDate as Date))              
              
              
union               
              
(SELECT isnull(s.BillingReferenceId,'') as Invoice_Reference_Number,              
s.PdfUrl as pdf,              
((select invoiceRefDate from openjson(s.additionaldata2) with (invoiceRefDate nvarchar(max) '$.invoice_reference_date'))) as  Invoice_Reference_Date,              
b.RegistrationName as Customer_Name,              
isnull(c.ContactNumber,'') + ' ' + isnull(c.Email,'') as Contact_Details,              
'Draft' as [Status],              
s.InvoiceCurrencyCode as Currency,       
  
case when i.VatRate <> 0    
then   
 case when s.InvoiceCurrencyCode in ('SAR')               
 then (ISNULL(i.LineAmountInclusiveVAT,0) + isnull(ii.LineAmountInclusiveVAT,0))  
 else (ISNULL(i.LineAmountInclusiveVAT,0)+ isnull(ii.LineAmountInclusiveVAT,0))  end                
 else                
 case when s.InvoiceCurrencyCode in ('SAR') then (ISNULL(i.LineAmountInclusiveVAT,0) + isnull(ii.LineAmountInclusiveVAT,0))               
else (ISNULL(i.LineAmountInclusiveVAT,0) + ISNULL(ii.LineAmountInclusiveVAT,0))   end end as Amount,    
   
 ISNULL(s.AdditionalData2,'0') AS AdditionalData2,              
 s.id as Invoice_Number,              
 cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as Invoice_Date,              
 (select ISNULL(salesorderno,'') from openjson(s.additionaldata2) with (salesorderno nvarchar(max) '$.original_order_number')) as Sales_Order_Number,              
 (select ISNULL(purchaseorderno,'') from openjson(s.additionaldata2) with (purchaseorderno nvarchar(max) '$.purchase_order_no')) as Purchase_Order_Number,              
 ISNULL(b.CustomerId, ' ') as Payer_Number,          
 (select ISNULL(shiptonumber,'') from openjson(b.additionaldata1) with (shiptonumber nvarchar(max) '$.crNumber')) as Ship_To_Number,          
 isnull(s.Source,' ') as Source,          
  (SELECT Name from AbpUsers where id=S.CreatorUserId) as Created_By   ,              
 s.CreationTime              
    from draft s              
 INNER JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,max(Vatrate) as VatRate                 
FROM draftitem   WITH (NOLOCK) where isOtherCharges = 0 and IsDeleted=0   GROUP BY IRNNo,TenantId) i ON s.id = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)              
 left JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId   FROM draftitem   WITH (NOLOCK) where isOtherCharges = 1 and IsDeleted=0              
GROUP BY IRNNo,TenantId) ii ON s.id = ii.IRNNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantid,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantid,0)              
--INNER JOIN IRNMaster m WITH (NOLOCK) ON s.id = m.IRNNo   AND ISNULL(m.tenantid,0)=ISNULL(@tenantid,0)              
INNER JOIN draftparty b WITH (NOLOCK) ON s.id = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantid,0)                    
--INNER JOIN #draftexchangeRate r WITH (NOLOCK) ON s.id = r.id   AND ISNULL(r.tenantid,0)=ISNULL(@tenantid,0)              
AND b.Type = 'Buyer' AND ISNULL(b.Language,'EN')='EN'              
inner join draftContactPerson c with (nolock) on s.id = c.IRNNo              
and Isnull(c.tenantid,0)=isnull(@tenantid,0)and c.Type = 'Buyer'              
AND ISNULL(b.Language,'EN')='EN'              
inner join draftparty su with (nolock) on s.id = su.IRNNo   and Isnull(su.tenantid,0)=isnull(@tenantid,0) and su.Type = 'Supplier'     AND ISNULL(b.Language,'EN')='EN'              
where CAST(s.IssueDate AS DATE)>=CAST(@fromDate as Date) and CAST(s.IssueDate AS DATE)<= CAST(@toDate as Date) and s.source in ('UI','API') and s.isSent=0 and s.InvoiceTypeCode='388')              
) as t1; 

              
              
IF(@customername IS NOT NULL)              
BEGIN              
DELETE FROM #invoice  WHERE Customer_Name not LIKE '%'+ @customername+'%';              
END              
IF(@creationDate IS NOT NULL)              
BEGIN

--DELETE FROM #invoice WHERE Invoice_Reference_Date not LIKE '%'+ cast(format(@creationDate,'yyyy-MM-dd') as nvarchar(30))+'%' or Invoice_Reference_Date is null; 
DELETE FROM #invoice WHERE dbo.dateconverter(Invoice_Reference_Date) not LIKE '%'+ dbo.dateconverter(cast(format(@creationDate,'yyyy-MM-dd') as nvarchar(30)))+'%' or Invoice_Reference_Date is null; 

--DELETE FROM #invoice WHERE AdditionalData2 IS NOT NULL and AdditionalData2 NOT LIKE '%"invoice_reference_date":"'+cast(format(@creationDate,'yyyy-MM-dd') as nvarchar)+'"%';              
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
              
 IF(@IRNo IS NOT NULL)                  
  BEGIN                  
  DELETE FROM #invoice WHERE Invoice_Number IS NOT NULL and Invoice_Number NOT LIKE '%'+@IRNo+'%';                  
  END                 
              
  IF(@createdby IS NOT NULL)                      
  BEGIN                      
  DELETE FROM #invoice WHERE (Created_By IS  NULL or Created_By NOT LIKE '%'+@createdby+'%');                        
  END               
              
if lower(@tenancycode) like 'brady%'              
begin              
SELECT Invoice_Reference_Number,dbo.Dateconverter(Invoice_Reference_Date) as Invoice_Reference_Date--CONVERT(VARCHAR(10), Invoice_Reference_Date, 101) as Invoice_Reference_Date
,Customer_Name,format(cast(Amount as decimal(20,2)),'#,0.00') as [Amount_(total)],Currency,pdf, [Status],Sales_Order_Number,Purchase_Order_Number,Payer_Number,Ship_To_Number,Invoice_Number,Invoice_Date,Contact_Details  
,Source,Created_By,format(CreationTime,'dd-MM-yyyy HH:MM') as Creation_Time FROM #invoice  ORDER BY CreationTime desc              
end              
else               
begin              
SELECT Invoice_Number,Invoice_Date,pdf, Customer_Name,[Status],Contact_Details,Currency,format(cast(Amount as decimal(20,2)),'#,0.00') as Amount,Invoice_Reference_Number From #invoice  ORDER BY CreationTime desc              
end              
IF OBJECT_ID('tempdb..#invoice') IS NOT NULL DROP TABLE #invoice              
IF OBJECT_ID('tempdb..#exchangeRate') IS NOT NULL DROP TABLE #exchangeRate              
IF OBJECT_ID('tempdb..#draftexchangeRate') IS NOT NULL DROP TABLE #draftexchangeRate              
              
end
GO
