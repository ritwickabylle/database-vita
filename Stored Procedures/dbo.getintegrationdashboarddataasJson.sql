SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[getintegrationdashboarddataasJson]   -- getintegrationdashboarddataasJson '2023-01-01' ,'2023-12-10' ,140,'Sales',null,'22-08-2023',null,null,null,null,null,null,null,null,null
@fromDate DATETIME,                                        
@toDate DATETIME,                                                            
@tenantId INT=null,                                          
@type nvarchar(max) = 'Sales',                                  
@invoicereferencenumber nvarchar(max) = null, --done                                  
@invoicereferncedate nvarchar(max)= null, --done                                  
@purchaseOrderNo nvarchar(max)= null, --done                                  
@customername nvarchar(max)= null, --done                                  
@activestatus nvarchar(max)= null,                                  
@currency nvarchar(max)= null,                                  
@payernumber NVARCHAR(MAX)= NULL,                                  
@salesorderno NVARCHAR(MAX)= NULL, --done                                  
@shiptono NVARCHAR(MAX)= NULL, --done                                  
@irnno nvarchar(max)=null,                                
@createdby nvarchar(max)=null                                
AS                                         
BEGIN                                        
--set nocount on;                          
declare @salesordernumber nvarchar(max)                                      
declare @purchaseordernumber nvarchar(max)                                      
declare @shiptonumber nvarchar(max)                                      
declare @tenancyname nvarchar(max)
declare @invrefdate nvarchar(max)
                
select @tenancyname = Name from AbpTenants where id=@tenantId                
                       
                      
if(@type = 'Sales')                
BEGIN                                  
SELECT                                   
isnull(s.InvoiceNumber,s.BillingReferenceId) as Invoice_Reference_Number,                                  
iif(s.isSent=0,s.PdfUrl,sa.PdfUrl) as pdf,                                     
Error as Errors,                                  
cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as Issue_date,                  
b.RegistrationName as Customer_Name,                   
                  
--cast((i.LineAmountInclusiveVAT / (select case when len(exchangeRate)=0 then 1 else cast(isnull(exchangeRate,1) as decimal(10,2)) end from openjson(s.additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate'))                        
--+ isnull(ii.UnitPrice,0)+case when isnull(i.VatRate,0)>0 then isnull((ii.UnitPrice*i.VatRate)/100,0)else 0 end) as nvarchar(max)) as Amount,

(isnull(i.LineAmountInclusiveVAT,0)+isnull(ii.LineAmountInclusiveVAT,0))
as Amount,

c.ContactNumber + ' ' +c.Email as Contact_Details,
s.InvoiceCurrencyCode as Currency,                                    
iif(s.isSent=0,'Draft',case when sa.PdfUrl is null then 'Einvoice not created' else 'Einvoice created' end) as [Status],                                  
ISNULL(s.AdditionalData2,'0') AS AdditionalData2,                                    
iif(s.isSent=0,cast(s.id as nvarchar),cast(sa.irnno as nvarchar)) as Invoice_Number,                                  
iif(s.isSent=0,cast(s.id as nvarchar),cast(sa.irnno as nvarchar)) as IRNNo,                                  
cast(format(s.DateOfSupply,'dd-MM-yyyy') as nvarchar(max)) as Invoice_Reference_Date,                                    
(select salesorderno from openjson(s.additionaldata2) with (salesorderno nvarchar(max) '$.original_order_number')) as Sales_Order_Number,                                    
(select purchaseorderno from openjson(s.additionaldata2) with (purchaseorderno nvarchar(max) '$.purchase_order_no')) as Purchase_Order_Number,                                    
b.CustomerId as Payer_Number,                                  
(select shiptonumber from openjson(b.additionaldata1) with (shiptonumber nvarchar(max) '$.crNumber')) as Ship_To_Number   ,              
'SAP' as Source,                    
case when s.isSent=0 then                            
 '' else                            
  (SELECT Name from AbpUsers where id=s.creatorUserId) end as Created_By,  
  
  case when s.isSent=1 then                            
 format(sa.CreationTime,'dd-MM-yyyy HH:MM') else                            
 format(s.CreationTime,'dd-MM-yyyy HH:MM')   end as CreationTime
 
INTO #invoice                       
FROM                                  
  draft s  WITH (NOLOCK)                      
  inner JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,isOtherCharges,max(VATRate) as VatRate                            
  FROM [dbo].[DraftItem]   WITH (NOLOCK)    where IsDeleted=0                        
  GROUP BY IRNNo,TenantId,isOtherCharges) i ON s.id = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0) and i.isOtherCharges=0                                
  left JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId   FROM DraftItem   WITH (NOLOCK) where isOtherCharges = 1                                
GROUP BY irnno,TenantId) ii ON s.Id = ii.IrnNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0)                          
  --INNER JOIN IRNMaster m WITH (NOLOCK) ON s.UniqueIdentifier = m.UniqueIdentifier   AND ISNULL(m.tenantid,0)=ISNULL(@tenantId,0)                                                        
  INNER JOIN [dbo].[DraftParty] b WITH (NOLOCK) ON s.id = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantId,0)                                                     
  AND b.Type = 'Buyer' and b.IRNNo=s.id and s.TransTypeDescription='388'                                  
  inner join [dbo].[DraftContactPerson] c with (nolock) on s.id = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantId,0)                                                        
  and c.Type = 'Buyer'  and c.IRNNo=s.id and s.TransTypeDescription='388'                                         
  inner join [dbo].[DraftParty] su with (nolock) on s.id = su.IRNNo   and Isnull(su.tenantid,0)=isnull(@tenantId,0)                                                        
  and su.Type = 'Supplier'  and su.IRNNo=s.id and s.TransTypeDescription='388'                                            
  left join dbo.SalesInvoice sa on sa.UniqueIdentifier = s.UniqueIdentifier                                                  
  where CAST(s.IssueDate AS DATE)>=CAST(@fromDate as Date) and CAST(s.IssueDate AS DATE)<= CAST(@toDate as Date) and s.invoicetypecode='388'                          
  and s.source not in ('UI','API')  
  

  --set @invrefdate = cast(format(cast(@invoicereferncedate as datetime2),'dd-MM-yyyy') as nvarchar(30));
  --print @invrefdate
                      
  IF(@customername IS NOT NULL)                                
  BEGIN                                        
  DELETE FROM #invoice  WHERE Customer_Name not LIKE '%'+ @customername+'%';                                        
  END                                        
                      
                      
  IF(@invoicereferncedate IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #invoice  WHERE(Invoice_Reference_Date) not like '%'+dbo.dateconverter(@invoicereferncedate)+'%';                                        
  END                                        
                  
  IF(@salesorderno IS NOT NULL)                                         
  BEGIN                                        
  DELETE FROM #invoice  WHERE Sales_Order_Number <> @salesorderno;                                        
  END                                        
                  
  IF(@purchaseOrderNo IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #invoice  WHERE Purchase_Order_Number <> @purchaseOrderNo;                                        
  END                                        
                             
  IF(@invoicereferencenumber IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #invoice WHERE Invoice_Reference_Number <> @invoicereferencenumber;                                        
  END                                        
     IF(@payernumber IS NOT NULL)                                  
  BEGIN                                        
  DELETE FROM #invoice WHERE Payer_Number <> @payernumber;                                        
  END        
  IF(@shiptono IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #invoice WHERE Ship_To_Number IS NOT NULL and Ship_To_Number <> @shiptono;                                        
  END                                   
  IF(@createdby IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #invoice WHERE (Created_By IS NULL or Created_By NOT LIKE '%'+@createdby+'%');                                           
  END                                  
IF(@irnno IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #invoice WHERE (IRNNo IS  NULL or IRNNo <> @irnno);                                
  END                                 
                      
  SELECT Invoice_Reference_Number,pdf,Errors,Invoice_Reference_Date,Customer_Name,format(cast(Amount as decimal(20,2)),'#,0.00') as [Amount_(total)],Currency,Status,AdditionalData2,Sales_Order_Number,Purchase_Order_Number,Payer_Number,Ship_To_Number,Invoice_Number,Issue_date as Invoice_Date,Contact_Details,Source,Created_By,CreationTime as Creation_Time,IRNNo            
  FROM #invoice  ORDER BY CreationTime desc              
            
  IF OBJECT_ID('tempdb..#invoice') IS NOT NULL DROP TABLE #invoice                                  
  END                                  
                 
  if(@type = 'Credit')                                  
begin                                
select                                  
(select sap_cn_number from openjson(s.additionaldata2) with (sap_cn_number nvarchar(max) '$.sap_cn_number')) as SAP_Invoice_Number,                
iif(s.isSent=0,s.PdfUrl,sa.PdfUrl) as pdf,                                     
Error as Errors,                                  
cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as Issue_date,                
b.RegistrationName as Customer_Name,                 
                
(select invoice_due_date from openjson(s.additionaldata2) with (invoice_due_date nvarchar(max) '$.invoice_due_date')) as sap_invoice_date,                                    
(select invoice_reference_date from openjson(s.additionaldata2) with (invoice_reference_date nvarchar(max) '$.sap_cn_date')) as sap_cn_reference_date,                
(select original_quote_number from openjson(s.additionaldata2) with (original_quote_number nvarchar(max) '$.original_quote_number')) as original_quote_number,                
                
                  
--cast((i.LineAmountInclusiveVAT / (select cast(isnull(exchangeRate,1) as decimal(10,2)) from openjson(s.additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate'))                        
--+ isnull(ii.UnitPrice,0)+case when isnull(i.VatRate,0)>0 then isnull((ii.UnitPrice*i.VatRate)/100,0)else 0 end) as nvarchar(max)) as Amount,                  
                  
--cast((i.LineAmountInclusiveVAT / (select case when len(exchangeRate)=0 then 1 else cast(isnull(exchangeRate,1) as decimal(10,2)) end from openjson(s.additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate'))                        
--+ isnull(ii.UnitPrice,0)+case when isnull(i.VatRate,0)>0 then isnull((ii.UnitPrice*i.VatRate)/100,0)else 0 end) as nvarchar(max)) as Amount,          

(isnull(i.LineAmountInclusiveVAT,0)+isnull(ii.LineAmountInclusiveVAT,0))
as Amount,

c.ContactNumber + ' ' +c.Email as Contact_Details,                    
s.InvoiceCurrencyCode as Currency,                                    
iif(s.isSent=0,'Draft',case when sa.PdfUrl is null then 'Einvoice not created' else 'Einvoice created' end) as [Status],                                  
ISNULL(s.AdditionalData2,'0') AS AdditionalData2,                                    
iif(s.isSent=0,cast(s.InvoiceNumber as nvarchar),cast(sa.irnno as nvarchar)) as Invoice_Number,                                  
iif(s.isSent=0,cast(s.id as nvarchar),cast(sa.irnno as nvarchar)) as IRNNo,                                  
cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as credit_note_date,                                    
(select salesorderno from openjson(s.additionaldata2) with (salesorderno nvarchar(max) '$.cn_order_number')) as credit_note_Number,                                    
(select purchaseorderno from openjson(s.additionaldata2) with (purchaseorderno nvarchar(max) '$.cn_po_number')) as Purchase_Order_Number,                                    
b.CustomerId as Payer_Number ,                                  
(select shiptonumber from openjson(b.additionaldata1) with (shiptonumber nvarchar(max) '$.crNumber')) as Ship_To_Number,                     
'SAP' as Source,                    
case when s.isSent=0 then                            
 ''else                
  (SELECT Name from AbpUsers where id=s.creatorUserId) end as Created_By, 
  
  case when s.isSent=1 then                            
 format(sa.CreationTime,'dd-MM-yyyy HH:MM') else                            
 format(s.CreationTime,'dd-MM-yyyy HH:MM')  end as creation_time                
                
INTO #Credit                                        
FROM                                        
draft s  WITH (NOLOCK)                                  
  inner JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,isOtherCharges,max(VATRate) as VatRate                            
  FROM [dbo].[DraftItem]   WITH (NOLOCK) where IsDeleted=0                         
  GROUP BY IRNNo,TenantId,isOtherCharges) i ON s.id = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0) and i.isOtherCharges=0                                
  left JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId   FROM DraftItem   WITH (NOLOCK) where isOtherCharges = 1                                
GROUP BY irnno,TenantId) ii ON s.Id = ii.IrnNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0)                          
  --INNER JOIN IRNMaster m WITH (NOLOCK) ON s.UniqueIdentifier = m.UniqueIdentifier   AND ISNULL(m.tenantid,0)=ISNULL(@tenantId,0)                                                        
  INNER JOIN [dbo].[DraftParty] b WITH (NOLOCK) ON s.id = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantId,0)                                                        
  AND b.Type = 'Buyer' and b.IRNNo=s.id and s.TransTypeDescription='381'                                  
  inner join [dbo].[DraftContactPerson] c with (nolock) on s.id = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantId,0)                                                        
  and c.Type = 'Buyer'  and c.IRNNo=s.id and s.TransTypeDescription='381'                                         
  inner join [dbo].[DraftParty] su with (nolock) on s.id = su.IRNNo   and Isnull(su.tenantid,0)=isnull(@tenantId,0)                                                        
  and su.Type = 'Supplier'  and su.IRNNo=s.id and s.TransTypeDescription='381'                                         
left join dbo.CreditNote sa on sa.UniqueIdentifier = s.UniqueIdentifier                                                  
  where CAST(s.IssueDate AS DATE)>=CAST(@fromDate as Date) and CAST(s.IssueDate AS DATE)<= CAST(@toDate as Date) and s.TransTypeDescription='381'                         
  and s.source not in ('UI','API');                                
                      
                       
                      
IF(@customername IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Credit  WHERE Customer_Name not LIKE '%'+ @customername+'%';                                        
  END                                        
                  
  IF(@invoicereferncedate IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Credit WHERE dbo.dateconverter(sap_cn_reference_date) not like '%'+dbo.dateconverter(@invoicereferncedate)+'%'--cast(format(cast(@invoicereferncedate as datetime2),'dd-MM-yyyy') as nvarchar(30));                                        
  END                                        
                 
  IF(@salesorderno IS NOT NULL)                                         
  BEGIN                                        
  DELETE FROM #Credit  WHERE credit_note_Number <> @salesorderno;                                        
  END                        
                      
                       
                      
  IF(@purchaseOrderNo IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Credit  WHERE Purchase_Order_Number <> @purchaseOrderNo;                                        
  END                                          
               
                       
                      
  IF(@invoicereferencenumber IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Credit WHERE SAP_Invoice_Number <> @invoicereferencenumber;                                        
  END                                        
                      
                       
                      
  IF(@shiptono IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Credit WHERE Ship_To_Number IS NOT NULL and Ship_To_Number <> @shiptono;                                        
  END                   
                  
                
   IF(@createdby IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Credit WHERE (Created_By IS  NULL or Created_By NOT LIKE '%'+@createdby+'%');                                           
  END                                  
  IF(@irnno IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Credit WHERE (IRNNo IS  NULL or IRNNo <> @irnno);                                
  END                                 
               
    SELECT  SAP_Invoice_Number as SAP_CN_NR,dbo.dateconverter(sap_cn_reference_date) AS SAP_CN_DATE,Customer_Name,format(cast(Amount as decimal(20,2)),'#,0.00') as [Amount_(total)],Currency,Status,credit_note_Number as Sales_Order_Number      
 ,Purchase_Order_Number,Payer_Number,Ship_To_Number,IRNNo as credit_note_Number,Issue_date as credit_note_date,Contact_Details,Source,Created_By,creation_time,pdf,Errors,AdditionalData2,IRNNo                        
                  
                      
 FROM #Credit    order by creation_time desc                                   
                      
                       
                      
  IF OBJECT_ID('tempdb..#Credit') IS NOT NULL DROP TABLE #Credit                                  
  end                                  
                      
                       
                      
if(@type = 'Debit')                          
begin                                 
select                                 
(select sap_dn_number from openjson(s.additionaldata2) with (sap_dn_number nvarchar(max) '$.sap_dn_number')) as Invoice_Reference_Number,                                  
iif(s.isSent=0,s.PdfUrl,sa.PdfUrl) as pdf,                                     
Error as Errors,                                  
cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as Issue_date,                                      
b.RegistrationName as Customer_Name,                   
                
(select invoice_due_date from openjson(s.additionaldata2) with (invoice_due_date nvarchar(max) '$.invoice_due_date')) as sap_invoice_date,                                    
(select invoice_reference_date from openjson(s.additionaldata2) with (invoice_reference_date nvarchar(max) '$.sap_dn_date')) as sap_dn_reference_date,                
(select original_quote_number from openjson(s.additionaldata2) with (original_quote_number nvarchar(max) '$.original_quote_number')) as original_quote_number,                
          
--cast((i.LineAmountInclusiveVAT / (select cast(isnull(exchangeRate,1) as decimal(10,2)) from openjson(s.additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate'))                        
--+ isnull(ii.UnitPrice,0)+case when isnull(i.VatRate,0)>0 then isnull((ii.UnitPrice*i.VatRate)/100,0)else 0 end) as nvarchar(max)) as Amount,                   
                  
--cast((i.LineAmountInclusiveVAT / (select case when len(exchangeRate)=0 then 1 else cast(isnull(exchangeRate,1) as decimal(10,2)) end from openjson(s.additionaldata1) with (exchangeRate nvarchar(max) '$.exchangeRate'))                
--+ isnull(ii.UnitPrice,0)+case when isnull(i.VatRate,0)>0 then isnull((ii.UnitPrice*i.VatRate)/100,0)else 0 end) as nvarchar(max)) as Amount,        

(isnull(i.LineAmountInclusiveVAT,0)+isnull(ii.LineAmountInclusiveVAT,0))
as Amount,

c.ContactNumber + ' ' +c.Email as Contact_Details,                                    
s.InvoiceCurrencyCode as Currency,                                    
iif(s.isSent=0,'Draft',case when sa.PdfUrl is null then 'Einvoice not created' else 'Einvoice created' end) as [Status],                               
ISNULL(s.AdditionalData2,'0') AS AdditionalData2,                                    
iif(s.isSent=0,cast(s.InvoiceNumber as nvarchar),cast(sa.irnno as nvarchar)) as Invoice_Number,                                  
iif(s.isSent=0,cast(s.id as nvarchar),cast(sa.irnno as nvarchar)) as IRNNo,    
cast(format(s.IssueDate,'dd-MM-yyyy') as nvarchar(max)) as Invoice_Reference_Date,                                    
(select salesorderno from openjson(s.additionaldata2) with (salesorderno nvarchar(max) '$.dn_order_number')) as Debit_Note_Number,                                    
(select purchaseorderno from openjson(s.additionaldata2) with (purchaseorderno nvarchar(max) '$.dn_po_number')) as Purchase_Order_Number,                                    
b.CustomerId as Payer_Number,                                  
(select shiptonumber from openjson(b.additionaldata1) with (shiptonumber nvarchar(max) '$.crNumber')) as Ship_To_Number   ,                     
'SAP' as Source,                    
case when isSent=0 then                            
 '' else                            
  (SELECT Name from AbpUsers where id=s.creatorUserId) end as Created_By,                     
  case when s.isSent=1 then                            
 format(sa.CreationTime,'dd-MM-yyyy HH:MM') else                            
 format(s.CreationTime,'dd-MM-yyyy HH:MM')   end as creation_time            
                      
INTO #Debit                                        
FROM                                  
draft s  WITH (NOLOCK)                                  
  inner JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId,isOtherCharges,max(VATRate) as VatRate                            
  FROM [dbo].[DraftItem]   WITH (NOLOCK) where IsDeleted=0                         
  GROUP BY IRNNo,TenantId,isOtherCharges) i ON s.id = i.IRNNo  AND ISNULL(i.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0) and i.isOtherCharges=0                                
  left JOIN (SELECT SUM(LineAmountInclusiveVAT) AS LineAmountInclusiveVAT,IRNNo,TenantId   FROM DraftItem   WITH (NOLOCK) where isOtherCharges = 1                                
GROUP BY irnno,TenantId) ii ON s.Id = ii.IrnNo  AND ISNULL(ii.tenantid,0)=ISNULL(@tenantId,0) AND ISNULL(s.tenantid,0)=ISNULL(@tenantId,0)                              
  --INNER JOIN IRNMaster m WITH (NOLOCK) ON s.UniqueIdentifier = m.UniqueIdentifier   AND ISNULL(m.tenantid,0)=ISNULL(@tenantId,0)                                                        
  INNER JOIN [dbo].[DraftParty] b WITH (NOLOCK) ON s.id = b.IRNNo   AND ISNULL(b.tenantid,0)=ISNULL(@tenantId,0)                                                        
  AND b.Type = 'Buyer' and b.IRNNo=s.id and s.TransTypeDescription='383'                                  
  inner join [dbo].[DraftContactPerson] c with (nolock) on s.id = c.IRNNo   and Isnull(c.tenantid,0)=isnull(@tenantId,0)                                                        
  and c.Type = 'Buyer'  and c.IRNNo=s.id and s.TransTypeDescription='383'                                         
  inner join [dbo].[DraftParty] su with (nolock) on s.id = su.IRNNo   and Isnull(su.tenantid,0)=isnull(@tenantId,0)                     
  and su.Type = 'Supplier'  and su.IRNNo=s.id and s.TransTypeDescription='383'                                           
  left join dbo.DebitNote sa on sa.UniqueIdentifier = s.UniqueIdentifier                                                  
  where CAST(s.IssueDate AS DATE)>=CAST(@fromDate as Date) and CAST(s.IssueDate AS DATE)<= CAST(@toDate as Date) and s.invoicetypecode='383'                                
  and s.source not in ('UI','API') ;                                         
                      
                       
                      
  IF(@customername IS NOT NULL)                                        
  BEGIN                                   
  DELETE FROM #Debit  WHERE Customer_Name not LIKE '%'+ @customername+'%';                                        
  END                                        
                      
                       
                      
  IF(@invoicereferncedate IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Debit  WHERE dbo.dateconverter(sap_dn_reference_date) not like dbo.dateconverter(@invoicereferncedate);                                        
  END                              
                      
                       
                      
IF(@salesorderno IS NOT NULL)                                         
  BEGIN                                        
  DELETE FROM #Debit  WHERE Debit_Note_Number <> @salesorderno;                                        
END                                        
                      
                       
                      
  IF(@purchaseOrderNo IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Debit  WHERE Purchase_Order_Number <> @purchaseOrderNo;                                        
  END                                          
                      
                       
                      
  IF(@invoicereferencenumber IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Debit WHERE Invoice_Reference_Number <> @invoicereferencenumber;                                        
  END                                        
                      
                       
                      
  IF(@shiptono IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Debit WHERE Ship_To_Number IS NOT NULL and Ship_To_Number <> @shiptono;                                        
  END                                
  IF(@createdby IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Debit WHERE (Created_By IS  NULL or Created_By NOT LIKE '%'+@createdby+'%');                                          
  END                                  
  IF(@irnno IS NOT NULL)                                        
  BEGIN                                        
  DELETE FROM #Debit WHERE (IRNNo IS  NULL or IRNNo NOT LIKE '%'+@irnno+'%');                                
  END                                 
              
                
 SELECT  Invoice_Reference_Number as SAP_DN_NR,dbo.dateconverter(sap_dn_reference_date) AS SAP_DN_DATE,Customer_Name,format(cast(Amount as decimal(20,2)),'#,0.00') as [Amount_(total)],Currency,      
 Status,Debit_Note_Number as Sales_Order_Number,Purchase_Order_Number,Payer_Number,Ship_To_Number,IRNNo as Debit_Note_Number,Issue_date as debit_note_date,Contact_Details,Source,Created_By,creation_time,pdf,Errors,AdditionalData2,IRNNo                   
 FROM #Debit  order by creation_time desc                          
                
  IF OBJECT_ID('tempdb..#Debit') IS NOT NULL DROP TABLE #Debit                                  
  END                                  
              
  end
GO
