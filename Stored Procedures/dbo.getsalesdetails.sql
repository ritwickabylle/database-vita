SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   procedure [dbo].[getsalesdetails]      -- getsalesdetails 315,null,127              
                    
(                    
@irrnNo bigint=NULL,
@refNo nvarchar(max)=NULL,
@tenantid int                    
)                    
as                    
begin  
if( @irrnNo = 0 )
begin
set @irrnNo = (select top 1 IRNNo from SalesInvoice where BillingReferenceId=@refNo and TenantId=@tenantid )
end
else
begin
set @irrnNo = cast(@irrnNo as bigint);
end

declare @jsonAdditional nvarchar(max),@jsonShipping nvarchar(max),@jsonAdditional1 nvarchar(max),@jsonShipping1 nvarchar(max)             
set @jsonShipping = ''+(select AdditionalData1 from SalesInvoiceParty where IRNNo=@irrnNo and TenantId=@tenantid and Language In('EN') and AdditionalData1 is not null)+''              
set @jsonAdditional = ''+(select AdditionalData2 from SalesInvoice where IRNNo=@irrnNo and TenantId=@tenantid and AdditionalData2 is not null)+''              
set @jsonShipping1 = ''+(select AdditionalData1 from SalesInvoiceParty where IRNNo=@irrnNo and TenantId=@tenantid  and Language in('AR') and AdditionalData1 is not null)+'' 

declare @registrationName nvarchar(max),@crNumber nvarchar(max),@vatid nvarchar(max),@street nvarchar(max),@buildingNo nvarchar(max),@additionalNo nvarchar(max), @city nvarchar(max),@postalCode nvarchar(max),              
@state nvarchar(max),@neighbourhood nvarchar(max),@countryCode nvarchar(max),@name nvarchar(max),@contactNumber nvarchar(max),              
@invoiceRefDate nvarchar(max),@deliveyDate nvarchar(max),@dueDate nvarchar(max),@purchaseOrderNo nvarchar(max),@originalOrderNo nvarchar(max),@contractId nvarchar(max),@paymentMeans nvarchar(max),              
@carrier nvarchar(max),@deliveryDocumentNo nvarchar(max),@termsOfDelivery nvarchar(max),@vendorNo nvarchar(max),              
@originalQuoteNum nvarchar(max),              
@paymentTerms nvarchar(max),@orderPlacedBy nvarchar(max),              
@deliveryTermsDescription nvarchar(max),@bankInformation nvarchar(max)              
          
select @registrationName = registrationName,@crNumber=crNumber,@vatid=vatid,@street=street,@buildingNo=buildingNo,@additionalNo=additionalNo,          
@city=city,@postalCode=postalCode ,@state=state,@neighbourhood=neighbourhood,@countryCode=countryCode,@name=name,          
@contactNumber=contactNumber from openjson(@jsonShipping)   with(registrationName nvarchar(max) '$.registrationName',crNumber nvarchar(max) '$.crNumber',vatid nvarchar(max) '$.vatid',street nvarchar(max) '$.address.street',          
buildingNo nvarchar(max) '$.address.buildingNo',              
additionalNo nvarchar(max) '$.address.additionalNo',city nvarchar(max) '$.address.city',postalCode nvarchar(max) '$.address.postalCode',state nvarchar(max) '$.address.state',neighbourhood nvarchar(max) '$.address.neighbourhood',        
countryCode nvarchar(max) '$.address.countryCode',              
name nvarchar(max) '$.contactPerson.name',contactNumber nvarchar(max) '$.contactPerson.contactNumber')              

declare @registrationName1 nvarchar(max),@crNumber1 nvarchar(max),@vatid1 nvarchar(max),@street1 nvarchar(max),@buildingNo1 nvarchar(max),@additionalNo1 nvarchar(max), @city1 nvarchar(max),@postalCode1 nvarchar(max),            
@state1 nvarchar(max),@neighbourhood1 nvarchar(max),@countryCode1 nvarchar(max),@name1 nvarchar(max),@contactNumber1 nvarchar(max),                       
@invoiceRefDate1 nvarchar(max),@deliveyDate1 nvarchar(max),@dueDate1 nvarchar(max),@purchaseOrderNo1 nvarchar(max),@originalOrderNo1 nvarchar(max),@contractId1 nvarchar(max),@paymentMeans1 nvarchar(max),            
@carrier1 nvarchar(max),@deliveryDocumentNo1 nvarchar(max),@termsOfDelivery1 nvarchar(max),@vendorNo1 nvarchar(max),            
@originalQuoteNum1 nvarchar(max),            
@paymentTerms1 nvarchar(max),@orderPlacedBy1 nvarchar(max),            
@deliveryTermsDescription1 nvarchar(max),@bankInformation1 nvarchar(max)  

select @registrationName1 = registrationName,@crNumber1=crNumber,@vatid1=vatid,@street1=street,@buildingNo1=buildingNo,@additionalNo1=additionalNo,        
@city1=city,@postalCode1=postalCode ,@state1=state,@neighbourhood1=neighbourhood,@countryCode1=countryCode,@name1=name,        
@contactNumber1=contactNumber from openjson(@jsonShipping1)   with(registrationName nvarchar(max) '$.registrationName',crNumber nvarchar(max) '$.crNumber',vatid nvarchar(max) '$.vatid',street nvarchar(max) '$.address.street',        
buildingNo nvarchar(max) '$.address.buildingNo',            
additionalNo nvarchar(max) '$.address.additionalNo',city nvarchar(max) '$.address.city',postalCode nvarchar(max) '$.address.postalCode',state nvarchar(max) '$.address.state',neighbourhood nvarchar(max) '$.address.neighbourhood',      
countryCode nvarchar(max) '$.address.countryCode',            
name nvarchar(max) '$.contactPerson.name',contactNumber nvarchar(max) '$.contactPerson.contactNumber') 
        
select @invoiceRefDate =invoice_reference_date,@deliveyDate=delivery_date,@dueDate=invoice_due_date,@purchaseOrderNo=purchase_order_no,@originalOrderNo=original_order_number,          
@contractId=contact_id,@paymentMeans=payment_means,          
@carrier=carrier_and_services,@deliveryDocumentNo=delivery_document_no,@termsOfDelivery=terms_of_delivery, @vendorNo=we_are_your_vendor,@originalQuoteNum=original_quote_number,@paymentTerms=payment_terms,          
@orderPlacedBy=order_placed_by,@deliveryTermsDescription =delivery_terms_description,@bankInformation=bank_information              
from openjson (@jsonAdditional)   with(invoice_reference_date nvarchar(max) '$.invoice_reference_date',delivery_date nvarchar(max) '$.delivery_date',invoice_due_date nvarchar(max) '$.invoice_due_date',          
purchase_order_no nvarchar(max) '$.purchase_order_no',original_order_number nvarchar(max) '$.original_order_number',              
contact_id nvarchar(max) '$.contact_id',payment_means nvarchar(max) '$.payment_means',carrier_and_services nvarchar(max) '$.carrier_and_services',delivery_document_no nvarchar(max) '$.delivery_document_no',        
terms_of_delivery nvarchar(max) '$.terms_of_delivery',              
we_are_your_vendor nvarchar(max) '$."we_are_your_vendor#"',original_quote_number nvarchar(max) '$.original_quote_number',payment_terms nvarchar(max) '$.payment_terms',order_placed_by nvarchar(max) '$.order_placed_by',          
delivery_terms_description nvarchar(max) '$.delivery_terms_description',bank_information nvarchar(max) '$.bank_information')              
              
select                     
SP.RegistrationName as Name,                    
SC.ContactNumber,                    
SC.Email,                    
SI.IRNNo,
SI.BillingReferenceId,
SI.AdditionalData1 as Exchange,                    
SI.IssueDate,                    
SA.Street,						
SA.AdditionalStreet,                    
SA.BuildingNo,                    
SA.AdditionalNo,                    
SA.City,                    
SA.PostalCode,                    
SA.State,                    
SA.Neighbourhood,                    
SA.CountryCode,                    
SA.Type,                    
SS.NetInvoiceAmount,                    
SS.SumOfInvoiceLineNetAmount,                    
SS.TotalAmountWithoutVAT,                    
SS.TotalAmountWithVAT,                
SP.VATID,              
SI.InvoiceNotes,            
SI.InvoiceCurrencyCode,            
SA.AdditionalNo,          
SP.CustomerId,  
SI.AdditionalData2,
SC.Name as billToAttn,
SC.Email,
@registrationName as registrationName,              
@crNumber as crNumber,              
@vatid as vatnumber,              
@street as Add_street,              
@buildingNo as Add_buildingNo,              
@city as Add_city,              
@additionalNo as Add_additionalNo,            
@postalCode as Add_postalCode,              
@state as Add_state,              
@neighbourhood as Add_neighbourhood,              
@countryCode as Add_countryCode,              
@name as Contact_name,              
@contactNumber as Contact_number,           
--case when @invoiceRefDate <> '' then convert(date,@invoiceRefDate,103) else  '' end  as Additional_invoiceRefDate,              
--case when @deliveyDate <>'' then convert(date,@deliveyDate,103) else '' end as Additional_deliveyDate,              
--case when @duedate <> '' then convert(date,@duedate,103) else '' end as Additional_dueDate,              
@purchaseOrderNo as Additional_purchaseOrderNo,            
@contractId as Additional_contractId,          
@originalOrderNo as Additional_originalOrderNo,                
@paymentMeans as Additional_paymentMeans ,@carrier as Additional_carrier,@deliveryDocumentNo as Additional_deliveryDocumentNo,@termsOfDelivery as Additional_termsOfDelivery, @vendorNo as Additional_vendorNo,      
@originalQuoteNum as Additional_originalQuoteNum,@paymentTerms as Additional_paymentTerms,@orderPlacedBy as Additional_orderPlacedBy ,
@deliveryTermsDescription as Additional_deliveryTermsDescription,@bankInformation as Additional_bankInformation,         
SA.Language,
SP.OtherDocumentTypeId
      
from SalesInvoice SI                    
inner join SalesInvoiceAddress  SA on SI.IRNNo=SA.IRNNo AND SI.TenantId=SA.TenantId                    
inner join SalesInvoiceSummary SS ON SI.IRNNo=SS.IRNNo AND SI.TenantId=SS.TenantId                    
inner join SalesInvoiceContactPerson SC on SC.IRNNo=SI.IRNNo and SI.TenantId=SC.TenantId                     
inner join SalesInvoiceParty SP on SP.IRNNo=SI.IRNNo and SI.TenantId=SP.TenantId          
--where SI.IRNNo=@irrnNo AND SI.TenantId=@tenantid AND SA.Type='Buyer' and sc.Type='buyer'  AND SP.Type='buyer'      
--where SI.IRNNo=164 AND SI.TenantId=33 AND SA.Type='Buyer' and SA.Language='EN'  and sc.Type='buyer' and  sc.Language='EN' AND SP.Type='buyer'  and SP.Language='EN' 
where SI.IRNNo=@irrnNo AND SI.TenantId=@tenantid AND SA.Type='Buyer' and isnull(SA.Language,'EN') in ('EN')  and sc.Type='buyer' and  isnull(SA.Language,'EN') in ('EN') AND SP.Type='buyer'  and isnull(SP.Language,'EN') in ('EN')  
UNION
 select                   
SP.RegistrationName as Name,                    
SC.ContactNumber,                    
SC.Email,                    
SI.IRNNo,
SI.BillingReferenceId,
SI.AdditionalData1 as Exchange,                    
SI.IssueDate,                    
SA.Street,						
SA.AdditionalStreet,                    
SA.BuildingNo,                    
SA.AdditionalNo,                    
SA.City,                    
SA.PostalCode,                    
SA.State,                    
SA.Neighbourhood,                    
SA.CountryCode,                    
SA.Type,                    
SS.NetInvoiceAmount,                    
SS.SumOfInvoiceLineNetAmount,                    
SS.TotalAmountWithoutVAT,                    
SS.TotalAmountWithVAT,                
SP.VATID,              
SI.InvoiceNotes,            
SI.InvoiceCurrencyCode,            
SA.AdditionalNo,          
SP.CustomerId,  
SI.AdditionalData2, 
SC.Name as billToAttn,
SC.Email,
@registrationName1 as registrationName,            
@crNumber1 as crNumber,            
@vatid1 as vatnumber,            
@street1 as Add_street,            
@buildingNo1 as Add_buildingNo,            
@city1 as Add_city,            
@additionalNo1 as Add_additionalNo,          
@postalCode1 as Add_postalCode,            
@state1 as Add_state,            
@neighbourhood1 as Add_neighbourhood,            
@countryCode1 as Add_countryCode,            
@name1 as Contact_name,            
@contactNumber1 as Contact_number,            
--format(cast(@invoiceRefDate1 as date),'dd-MM-yyyy')  as Additional_invoiceRefDate,            
--format(cast(@deliveyDate1 as date),'dd-MM-yyyy') as Additional_deliveyDate,            
--format(cast(@dueDate1 as date) ,'dd-MM-yyyy') as Additional_dueDate,            
@purchaseOrderNo1 as Additional_purchaseOrderNo,          
@contractId1 as Additional_contractId,        
@originalOrderNo1 as Additional_originalOrderNo,              
@paymentMeans1 as Additional_paymentMeans ,@carrier1 as Additional_carrier,@deliveryDocumentNo1 as Additional_deliveryDocumentNo,@termsOfDelivery1 as Additional_termsOfDelivery, @vendorNo1 as Additional_vendorNo,    
@originalQuoteNum1 as Additional_originalQuoteNum1 ,@paymentTerms1 as Additional_paymentTerms,@orderPlacedBy1 as Additional_orderPlacedBy , @deliveryTermsDescription1 as Additional_deliveryTermsDescription,@bankInformation1 as Additional_bankInformation,       
SA.Language ,
SP.OtherDocumentTypeId

from SalesInvoice SI                  
inner join SalesInvoiceAddress  SA on SI.IRNNo=SA.IRNNo AND SI.TenantId=SA.TenantId  and sa.Type='buyer'                
inner join SalesInvoiceSummary SS ON SI.IRNNo=SS.IRNNo AND SI.TenantId=SS.TenantId               
inner join SalesInvoiceContactPerson SC on SC.IRNNo=SI.IRNNo and SI.TenantId=SC.TenantId and sc.Type='buyer'                   
inner join SalesInvoiceParty SP on SP.IRNNo=SI.IRNNo and SI.TenantId=SP.TenantId and sp.Type='buyer'       
--where SI.IRNNo=166 AND SI.TenantId=33 AND SA.Type='Buyer' and sc.Type='buyer'  AND SP.Type='buyer'    
where SI.IRNNo=@irrnNo AND SI.TenantId=@tenantid AND SA.Type='Buyer' and SA.Language in ('AR')  and sc.Type='buyer'  AND SP.Type='buyer'  and SP.Language in ('AR')  

end
GO
