SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE      procedure [dbo].[FileUploadSalesT1Brady]                                
(@batchid int =8024,                                        
@tenantId int = 140,                                        
@json nvarchar(max) ='')                                        
as                   
begin                            
insert into logs
values(@json,getdate(),@batchid);
declare @uuid uniqueidentifier = NEWID();    
declare @freight decimal(18,2);
declare @customs decimal(18,2);
declare @othercharges decimal(18,2);
declare @handlingcharges decimal(18,2);
select * into #file from(                            
select * from                            
OPENJSON(@json) with (                            
xml_uuid uniqueidentifier '$."xml_uuid"',                                      
--InvoiceType nvarchar(max) '$."Invoice Type"',                                               
TransType nvarchar(max) '$."TransactionType"',                                      
SAPInvoiceNumber nvarchar(max) '$."SAPDocumentNumber"',                            
SAPInvoiceDate nvarchar(max) '$."SAPDocumentDate"',                                      
SAPInvoiceDueDate nvarchar(max) '$."SAPInvoiceDueDate"',                                      
SupplyDate nvarchar(max) '$."SupplyDate"',                                      
SupplyEndDate nvarchar(max) '$."SupplyEndDate"',                            
PurchaseOrderId nvarchar(max) '$."PurchaseOrderID"',
ContractId nvarchar(max) '$."SAPSalesOrder"',                        
                   
OrderPlacedBy nvarchar(max) '$."OrderPlacedBy"',                                      
PaymentMeans nvarchar(max) '$."PaymentMeans"',                            
PaymentTerms nvarchar(max) '$."PaymentTerms"',                                    
OriginalQuoteNumber nvarchar(max) '$."OriginalQuote Number"',                        
                       
DeliveryDocumentNo nvarchar(max) '$."DeliveryDocumentNo"',                            
CarrierAndService nvarchar(max) '$."CarrierAndService"',                            
TermsOfDelivery nvarchar(max) '$."TermsOfDelivery"',                                      
InvoiceCurrencyCode nvarchar(max) '$."DocumentCurrencyCode"',                            
ExchangeRate nvarchar(max) '$."ExchangeRate"',                           
WeAreYourVendor nvarchar(max) '$."WeAreYourVendor"',                                     
BillingReferenceID nvarchar(max) '$."BillingReferenceID"',                                       
CreditOrDebitReasons nvarchar(max) '$."Reason for Issuance of Credit/Debit Note"',                                       
Notes nvarchar(max) '$."Notes"',                                       
BankName nvarchar(max) '$."BankName"',                                     
AccountName nvarchar(max) '$."AccountName"',                            
SARAccount nvarchar(max) '$."SARAccount"',                            
IBAN nvarchar(max) '$."IBAN"',                            
SWIFT nvarchar(max) '$."SWIFT"',                            
PayerMasterCode nvarchar(max) '$."PayerMasterCode"',                                      
PayerName nvarchar(max) '$."PayerName"',                                       
PayerVATNumber nvarchar(max) '$."PayerVATNumber"',                                       
                                    
PayerStreet nvarchar(max) '$."PayerStreet"',                                      
PayerAdditionalStreet nvarchar(max) '$."PayerAdditional Street"',                      
PayerBuildingNumber nvarchar(max) '$."PayerBuilding Number"',                      
PayerAdditionalNumber nvarchar(max) '$."PayerAdditional Number"',                      
PayerCity nvarchar(max) '$."PayerCity"',                      
PayerPostalCode nvarchar(max) '$."PayerPostalCode"',                                       
PayerDistrictOrNeighbourhood nvarchar(max) '$."PayerDistrictOrNeighbourhood"',                      
PayerProvinceOrState nvarchar(max) '$."Payer ProvinceOrState"',                      
PayerCountryCode nvarchar(max) '$."PayerCountry Code"',                      
                                     
Attn nvarchar(max) '$."Attn"', --not mapped             
                                    
PayerOtherID nvarchar(max) '$."PayerOtherID"',                      
PayerContactNumber nvarchar(max) '$."PayerContactNumber"', --buyer contact number                          
         
ShipToMasterCode nvarchar(max) '$."ShipToMaster Code"',                              
ShipToName nvarchar(max) '$."ShipToName"',                      
                                     
ShipToStreet nvarchar(max) '$."ShipToStreet"',                      
ShipToAdditionalStreet nvarchar(max) '$."ShipToAdditional Street"',                    
ShipToBuildingNumber nvarchar(max) '$."ShipToBuilding Number"',                              
ShipToAdditionalNumber nvarchar(max) '$."ShipToAdditional Number"',                      
ShipToCity nvarchar(max) '$."ShipToCity"',                      
ShipToPostalCode nvarchar(max) '$."ShipToPostalCode"',                              
ShipToDisctrictOrNeighbourhood nvarchar(max) '$."ShipToDisctrictOrNeighbourhood"',                              
ShipToProvinceOrState nvarchar(max) '$."ShipTo ProvinceOrState"',                              
ShipToCountryCode nvarchar(max) '$."ShipToCountry Code"',                             
ShipToContactNumber nvarchar(max) '$."ShipToContactNumber"',                                    
ShipToAttn nvarchar(max) '$."ShipToAttn"',                          
BuyerOtherID nvarchar(max) '$."BuyerOtherID"',                          
                               
LineIdentifier nvarchar(max) '$."DocumentlineIdentifier"',                      
LineOriginIndicator nvarchar(max) '$."LineOriginIndicator"',                      
PartNumberDescription nvarchar(max) '$."PartNumberDescription"',                      
UnitPrice nvarchar(max) '$."UnitPrice"',                      
ListPrice nvarchar(max) '$."ListPrice"',                      
ItemUOM nvarchar(max) '$."ItemUOM"',                      
ItemQuantity nvarchar(max) '$."ItemQuantity"',                                      
ItemNetPrice nvarchar(max) '$."LineAmountExclusiveVAT"',                                      
CurrencyCode nvarchar(max) '$."CurrencyCode"',                      
                       
LineAmountExclusiveVAT nvarchar(max) '$."LineAmountExclusiveVAT+Charges"',                          

ItemVATCode nvarchar(max) '$."ItemVATCode"',                      
ItemVATRate nvarchar(max) '$."ItemVATRate"',                      
ItemVATAmount nvarchar(max) '$."ItemVATAmount"',                      
LineAmountInclusiveVAT nvarchar(max) '$."LineAmountInclusiveVAT"',                      
VATExemptionReasonCode nvarchar(max) '$."VATExemptionReasonCode"',                      
VATExemptionReason nvarchar(max) '$."VATExemptionReason"',                      
                                     
InvoiceNetAmount nvarchar(max) '$."TotalNetAmount"',                          
val1 nvarchar(max) '$."Freight"',                                       
val2 nvarchar(max) '$."Customs"',                                       
HandlingCharges nvarchar(max) '$."Handling Charges"',                      
OtherCharges nvarchar(max) '$."Other Charges"',  

ItemFreight nvarchar(max) '$."ItemFreight"',                                       
ItemCustoms nvarchar(max) '$."ItemCustoms"',                                       
ItemHandling nvarchar(max) '$."ItemHandling"',                      
ItemOtherCharges nvarchar(max) '$."ItemOtherCharges"', 

InvoiceVAT nvarchar(max) '$."TotalVATAmount"',                      
InvoiceTotal nvarchar(max) '$."TotalAmount"',                      
Footer nvarchar(max) '$."Footer"', --not mapped              
CreatedBy nvarchar(max) '$."CreatedBy"',              
AdditionalDetails1 nvarchar(max) '$."AdditionalDetails1"', --not mapped                                      
AdditionalDetails2 nvarchar(max) '$."AdditionalDetails2"', --not mapped                                      
AdditionalDetails3 nvarchar(max) '$."AdditionalDetails3"', --not mapped                                      
AdditionalDetails4 nvarchar(max) '$."AdditionalDetails4"',  --not mapped                            
                           
PayerCRNNumber nvarchar(max) '$."PayerCRNNumber"',                          
PayerNationalIDNumber nvarchar(max) '$."PayerNationalIDNumber"',                          
PayerMLSNumber nvarchar(max) '$."PayerMLSNumber"',                          
PayerOtherNumber nvarchar(max) '$."PayerOtherNumber"',                          
PayerIndustry nvarchar(max) '$."PayerIndustry"',                          
PayerNaturalPerson nvarchar(max) '$."PayerNaturalPerson"' ,                  
PayerPOBox nvarchar(max) '$."PayerPOBox"',                  
PayerEmailId nvarchar(max) '$."PayerEmail"'                         
                          
                          
)                                         
) as t;                                        
                           
declare @irnno nvarchar(max)
declare @transtype nvarchar(max) 
declare @extracharges decimal(18,2)

set @irnno = (select top 1 IRNNo from SalesInvoice where tenantid=@tenantId and InvoiceNumber =(select top 1 BillingReferenceId from #file))
set @transtype = (select top 1 TransType from #file)

--------------------------------------------header-------------------------------------------                                        
select * into #headerDuplicates from(                                        
select 
@batchid as BatchId,                      
@tenantId as TenantId,  
ISNULL(TransType, '') as TransTypeDescription,                            
NEWID() as 'UniqueIdentifier',                  
-1 as IRNNo,                                               
case when TransType ='388' then(isnull(SAPInvoiceNumber,'')) else (isnull(BillingReferenceId,'')) end  as InvoiceNumber,           --exec FileUploadSalesT1                            
--dbo.[ISNULLOREMPTYFORDATEDDFORMAT](SAPInvoiceDate) as IssueDate,                              
getdate() as IssueDate,                              
isnull(dbo.[ISNULLOREMPTYFORDATEDDFORMAT](SupplyDate),isnull(dbo.[ISNULLOREMPTYFORDATEDDFORMAT](SAPInvoiceDate),getdate())) as DateOfSupply,                                               
ISNULL(InvoiceCurrencyCode, '') as InvoiceCurrencyCode,                                               
null as CurrencyCodeOriginatingCountry , -- CurrencyCodeOriginatingCountry to be checked                                        
ISNULL(PurchaseOrderId, '') as PurchaseOrderId,                                           
case when transtype ='388' then(isnull(SAPInvoiceNumber,'')) else (isnull(@irnno,'')) end as BillingReferenceId,  -- BillingReferenceId to be checked                                        
ISNULL(ContractId, '') as ContractId,                                               
dbo.[ISNULLOREMPTYFORDATEDDFORMAT](SupplyEndDate) as LatestDeliveryDate,                                        
null as 'Location',                                        
null as 'CustomerId',                                        
null as 'Status',                                        
null as 'Additional_Info',                                        
case when len(PaymentMeans)=0 then 'Credit transfer' else ISNULL(PaymentMeans, 'Credit transfer') end as PaymentType,                             
null as PdfUrl,                                        
null as QrCodeUrl,                                        
null as XMLUrl,                                        
null as ArchivalUrl,                                        
null as PreviousInvoiceHash,                                        
null as PerviousXMLHash,                                        
null as XMLHash,                                        
null as PdfHash,                                        
null as XMLbase64,                                        
null as PdfBase64,                                        
0 as IsArchived,                            
0 as TransTypeCode,                                         
null as AdvanceReferenceNumber,                            
null as Invoicetransactioncode,                            
null as BusinessProcessType,                            
GetDate() as CreationTime,                            
null as XmlUuid,                            
(select top 1 ExchangeRate as exchangeRate from #file for JSON AUTO) as AdditionalData1, 

case when transtype ='388' then(
(select top 1 OriginalQuoteNumber as original_quote_number, 
PaymentTerms as payment_terms,                            
[dbo].[Dateconverter](SAPInvoiceDate) as invoice_reference_date,                            
ISNull([dbo].[Dateconverter](SupplyDate),getDate()) as delivery_date,                            
DeliveryDocumentNo as delivery_document_no,                            
CarrierAndService as carrier_and_services,                   
ISNULL(OrderPlacedBy,'') as order_placed_by,                            
TermsOfDelivery as terms_of_delivery,                            
[dbo].[Dateconverter](SAPInvoiceDueDate) as invoice_due_date,                            
WeAreYourVendor as we_are_your_vendor#,                            
case when len(PaymentMeans)=0 then 'Credit transfer' else ISNULL(PaymentMeans, 'Credit transfer') end as payment_means,                            
ContractId as original_order_number,                            
PurchaseOrderId as purchase_order_no,            
CreditOrDebitReasons as CreditOrDebitReasons,
'' as delivery_terms_description,
concat(isnull(BankName,''),' ',isnull(AccountName,''),' ',isnull(SARAccount,''),' ',isnull(IBAN,''),' ',isnull(SWIFT,'')) as bank_information 
from #file for JSON AUTO))
 
when transtype ='381' then(
(select top 1 SAPInvoiceNumber as sap_cn_number,                            
ISNull([dbo].[Dateconverter](SAPInvoiceDate),getDate()) as sap_cn_date,                            
ISNULL(OrderPlacedBy,'') as order_placed_by,                            
ContractId as cn_order_number,                            
PurchaseOrderId as cn_po_number,            
CreditOrDebitReasons as CreditOrDebitReasons
from #file for JSON AUTO) )
 
else (
(select top 1 SAPInvoiceNumber as sap_dn_number,                            
PaymentTerms as payment_terms,                            
ISNull(dbo.[Dateconverter](SAPInvoiceDate),getDate()) as sap_dn_date,                            
DeliveryDocumentNo as delivery_document_no,                            
ISNULL(OrderPlacedBy,'') as order_placed_by,                            
dbo.[Dateconverter](SAPInvoiceDueDate) as dn_due_date,                            
ContractId as dn_order_number,                            
PurchaseOrderId as dn_po_number,            
CreditOrDebitReasons as CreditOrDebitReasons,          
concat(isnull(BankName,''),' ',isnull(AccountName,''),' ',isnull(SARAccount,''),' ',isnull(IBAN,''),' ',isnull(SWIFT,'')) as bank_information
from #file for JSON AUTO))
end
as AdditionalData2,   
CASE
  WHEN transtype = '388' THEN notes
  WHEN transtype = '383' 
  THEN 
     CASE
      WHEN AdditionalDetails3 = 'L2' THEN (select top 1 description from reasoncndn where tenantid is null and code=AdditionalDetails3)
      ELSE CreditOrDebitReasons
    END
  ELSE
    CASE
      WHEN AdditionalDetails3 = 'G2' THEN (select top 1 description from reasoncndn where tenantid is null and code=AdditionalDetails3)
      WHEN AdditionalDetails3 = 'RE' THEN (select top 1 description from reasoncndn where tenantid is null and code=AdditionalDetails3)
      WHEN AdditionalDetails3 = 'S1' THEN (select top 1 description from reasoncndn where tenantid is null and code=AdditionalDetails3)
      ELSE CreditOrDebitReasons
    END
  END
AS InvoiceNotes,
(select top 1 Footer as footer,
AdditionalDetails3 as AdditionalDetails3,
AdditionalDetails4 as AdditionalDetails4,
InvoiceTotal as InvoiceTotal from #file for JSON AUTO) as AdditionalData3,                            
(select top 1 CreatedBy as created_by from #file for JSON AUTO) as AdditionalData4,                            
null as InvoiceTypeCode,          
null as 'Language',        
isnull(BankName,'') as BankName,        
isnull(AccountName,'') as AccountName,        
isnull(SARAccount,'') as SARAccount,        
isnull(IBAN,'') as IBAN,        
isnull(SWIFT,'') as SWIFT               
from                                               
#file) as t  ;     

--select * from #headerDuplicates
                                        
select * into #header from                                        
(SELECT  h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[InvoiceNumber],h1.[IssueDate],h1.[DateOfSupply],h1.[InvoiceCurrencyCode],h1.[CurrencyCodeOriginatingCountry],h1.[PurchaseOrderId],                                      
h1.[BillingReferenceId],h1.[ContractId],h1.[LatestDeliveryDate],h1.[Location],h1.[CustomerId],h1.[Status],h1.[Additional_Info],h1.[PaymentType],h1.[PdfUrl],h1.[QrCodeUrl],h1.[XMLUrl],h1.[ArchivalUrl],                                      
h1.[PreviousInvoiceHash],h1.[PerviousXMLHash],h1.[XMLHash],h1.[PdfHash],h1.[XMLbase64],h1.[PdfBase64],h1.[IsArchived],h1.[TransTypeCode],h1.[TransTypeDescription],h1.[AdvanceReferenceNumber],                                      
h1.[Invoicetransactioncode],h1.[BusinessProcessType],h1.[CreationTime],h1.[InvoiceNotes],h1.[XmlUuid],h1.[AdditionalData1],h1.[AdditionalData2],h1.[AdditionalData3],h1.[AdditionalData4],                                      
h1.[InvoiceTypeCode],h1.[Language],h1.[BankName], h1.[AccountName], h1.[SARAccount], h1.[IBAN], h1.[SWIFT]        
FROM                                        
#headerDuplicates AS h1                                        
inner join (SELECT InvoiceNumber, max(UniqueIdentifier) as mostrecent                                          
FROM #headerDuplicates group by InvoiceNumber) AS h2                                        
ON h2.InvoiceNumber = h1.InvoiceNumber and h2.mostrecent = h1.UniqueIdentifier                                        
) as t;                                        
                                    
                                      
                                        
insert into [dbo].[FileUpload_TransactionHeader](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[InvoiceNumber]                                        
,[IssueDate]                                        
,[DateOfSupply]                                        
,[InvoiceCurrencyCode]                                        
,[CurrencyCodeOriginatingCountry]                                        
,[PurchaseOrderId]                                        
,[BillingReferenceId]                                        
,[ContractId]                                        
,[LatestDeliveryDate]     
,[Location]                                        
,[CustomerId]                                      
,[Status]                                        
,[Additional_Info]                                        
,[PaymentType]                                        
,[PdfUrl]                                        
,[QrCodeUrl]                                        
,[XMLUrl]                                        
,[ArchivalUrl]                                        
,[PreviousInvoiceHash]                                        
,[PerviousXMLHash]                               
,[XMLHash]                                        
,[PdfHash]                                        
,[XMLbase64]                                        
,[PdfBase64]                                        
,[IsArchived]                                        
,[TransTypeCode]                                        
,[TransTypeDescription]                                        
,[AdvanceReferenceNumber]                                        
,[Invoicetransactioncode]                                        
,[BusinessProcessType]                                        
,[CreationTime]                                        
,[InvoiceNotes]                                        
,[XmlUuid]                                        
,[AdditionalData1]                                        
,[AdditionalData2]                                        
,[AdditionalData3]                                        
,[AdditionalData4]                                        
,[InvoiceTypeCode]                                        
,[Language]        
,[BankName]        
,[AccountName]        
,[AccountNumber]        
,[IBAN]        
,[SwiftCode]        
)                                          
SELECT  h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[InvoiceNumber],isnull(h1.[IssueDate],GETDATE()),h1.[DateOfSupply],h1.[InvoiceCurrencyCode],h1.[CurrencyCodeOriginatingCountry],h1.[PurchaseOrderId],                                 
 
    
      
h1.[BillingReferenceId],h1.[ContractId],h1.[LatestDeliveryDate],h1.[Location],h1.[CustomerId],h1.[Status],h1.[Additional_Info],h1.[PaymentType],h1.[PdfUrl],h1.[QrCodeUrl],h1.[XMLUrl],h1.[ArchivalUrl],                                      
h1.[PreviousInvoiceHash],h1.[PerviousXMLHash],h1.[XMLHash],h1.[PdfHash],h1.[XMLbase64],h1.[PdfBase64],h1.[IsArchived],h1.[TransTypeCode],h1.[TransTypeDescription],h1.[AdvanceReferenceNumber],                                      
h1.[Invoicetransactioncode],h1.[BusinessProcessType],h1.[CreationTime],h1.[InvoiceNotes],h1.[XmlUuid],h1.[AdditionalData1],h1.[AdditionalData2],h1.[AdditionalData3],h1.[AdditionalData4],                                      
h1.[InvoiceTypeCode],h1.[Language],h1.[BankName], h1.[AccountName], h1.[SARAccount], h1.[IBAN], h1.[SWIFT]                                        
FROM                                        
#header AS h1                                        
                                        
                                        
---------------------------------------items-----------------------------------------------  
--select * from #file

if((select sum(cast(case when len(ItemOtherCharges)>0 then ItemOtherCharges else '0' end as decimal(18,2))) from #file ) > 0)
begin
set @othercharges = (select sum(cast(case when len(ItemOtherCharges)>0 then ItemOtherCharges else '0' end as decimal(18,2))) from #file)
end

if((select sum(cast(case when len(ItemFreight)>0 then ItemFreight else '0' end as decimal(18,2))) from #file ) > 0)
begin
set @freight = (select sum(cast(case when len(ItemFreight)>0 then ItemFreight else '0' end as decimal(18,2))) from #file)
end

if((select sum(cast(case when len(ItemCustoms)>0 then ItemCustoms else '0' end as decimal(18,2))) from #file ) > 0)
begin
set @customs = (select sum(cast(case when len(ItemCustoms)>0 then ItemCustoms else '0' end as decimal(18,2))) from #file)
end

if((select sum(cast(case when len(ItemHandling)>0 then ItemHandling else '0' end as decimal(18,2))) from #file ) > 0)
begin
set @handlingcharges = (select sum(cast(case when len(ItemHandling)>0 then ItemHandling else '0' end as decimal(18,2))) from #file)
end


select * into #items from(                                        
select                                 
ISNULL(TransType, '') as TransTypeDescription,                            
case when TransType ='388' then(isnull(SAPInvoiceNumber,'')) else (isnull(BillingReferenceId,'')) end  as InvoiceNumber, 
BillingReferenceId as BillingReferenceId,
SAPInvoiceNumber as SAPInvoiceNumber,
@batchid as BatchId,                                               
@tenantId as TenantId,                                               
@uuid as 'UniqueIdentifier',                                               
-1 as IRNNo,                                  
ISNULL(LineIdentifier, '') as Identifier,                            
case when isnull(LineOriginIndicator,'')='' then LineOriginIndicator else concat(LineOriginIndicator,' SA') end as Name,                                               
PartNumberDescription as Description,                                        
null as BuyerIdentifier,           
null as SellerIdentifier,                                        
null as StandardIdentifier,                                        
dbo.ISNULLOREMPTYFORDECIMALFOURPLACE(ItemQuantity) as Quantity,                                               
ISNULL(ItemUOM, '') as UOM,                                               
                            
cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(UnitPrice) as decimal(15,2)) as nvarchar(max)) as UnitPrice,                            
cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(ListPrice) as decimal(15,2)) as nvarchar(max)) as CostPrice,                            
--0 as CostPrice,                            
0 as DiscountPercentage,                            
0 as DiscountAmount,                                          
                            
cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as decimal(15,2)) as nvarchar(max)) as GrossPrice,                             
cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as decimal(15,2)) as nvarchar(max)) as NetPrice,                            
                            
dbo.ISNULLOREMPTYFORDECIMAL(ItemVATRate) as VatRate,                                          
ISNULL(ItemVATCode,'') as VatCode,                                
                            
cast((CAST(dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as decimal(15,2))* dbo.ISNULLOREMPTYFORDECIMAL(ItemVATRate)/100) as nvarchar(max)) as VATAmount,                            
cast((CAST(dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as decimal(15,2))* dbo.ISNULLOREMPTYFORDECIMAL(ItemVATRate)/100 +                    
(cast(dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as decimal(15,2)))) as nvarchar(max))  as LineAmountInclusiveVAT,                       
                    
ISNULL(InvoiceCurrencyCode, '') as CurrencyCode,                            
null as TaxSchemeId,                            
null as Notes,                                        
ISNULL(VatExemptionReasonCode, '') as ExcemptionReasonCode,                                               
ISNULL(VatExemptionReason, '') as ExcemptionReasonText,                                         
GETDATE() as CreationTime,                                        
null as AdditionalData1,                                        
null as AdditionalData2,                                        
null as 'Language',                            
--iif(val1='',0,cast(val1 as decimal(18,2))) as Freight, 
iif((@freight = 0),cast(val1 as decimal(18,2)),cast(@freight as decimal(18,2))) as Freight,
--iif(val2='',0,cast(val2 as decimal(18,2))) as Customs,  
iif((@customs = 0),cast(val2 as decimal(18,2)),cast(@customs as decimal(18,2))) as Customs,
--iif(HandlingCharges='',0,cast(HandlingCharges as decimal(18,2))) as Handling_Charges, 
iif((@handlingcharges = 0),cast(HandlingCharges as decimal(18,2)),cast(@handlingcharges as decimal(18,2))) as Handling_Charges,
iif((@othercharges = 0),cast(OtherCharges as decimal(18,2)),cast(@othercharges as decimal(18,2))) as Other_Charges                           
from                                          
#file) as t  ;  

--select * from #file
--select * from #items
                        
insert into [dbo].[FileUpload_TransactionItem](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[Identifier]     
,[Name]                                 
,[Description]                                        
,[BuyerIdentifier]                                        
,[SellerIdentifier]                 
,[StandardIdentifier]                                        
,[Quantity]                            
,[UOM]                            
,[UnitPrice]                            
,[CostPrice]                            
,[DiscountPercentage]                            
,[DiscountAmount]                            
,[GrossPrice]                            
,[NetPrice]                            
,[VATRate]                            
,[VATCode]                            
,[VATAmount]                            
,[LineAmountInclusiveVAT]                            
,[CurrencyCode]                            
,[TaxSchemeId]                            
,[Notes]                            
,[ExcemptionReasonCode]                            
,[ExcemptionReasonText]                            
,[CreationTime]                            
,[AdditionalData1]                            
,[AdditionalData2]                            
,[Language]                            
,[isOtherCharges]                            
)                                             
select i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],i.[Name],i.[Description],i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],i.[Quantity],i.[UOM],i.[UnitPrice],i.[CostPrice],i.[DiscountPercentage],             
i.[DiscountAmount],i.[GrossPrice],i.[NetPrice],i.[VATRate],i.[VATCode],i.[VATAmount],i.[LineAmountInclusiveVAT],i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                                      
i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],0                                        
from #items i inner join #header h on i.InvoiceNumber = h.InvoiceNumber  where cast(dbo.ISNULLOREMPTYFORDECIMALFOURPLACE(i.[UnitPrice]) as decimal(15,2))>0
order by i.[Identifier]
                            
------Freight------                            
insert into [dbo].[FileUpload_TransactionItem](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[Identifier]                                        
,[Name]                                        
,[Description]                                        
,[BuyerIdentifier]                                        
,[SellerIdentifier]                                        
,[StandardIdentifier]                                        
,[Quantity]                            
,[UOM]                            
,[UnitPrice]                            
,[CostPrice]                            
,[DiscountPercentage]                            
,[DiscountAmount]                    
,[GrossPrice]                            
,[NetPrice]                            
,[VATRate]                            
,[VATCode]                            
,[VATAmount]                            
,[LineAmountInclusiveVAT]                            
,[CurrencyCode]                            
,[TaxSchemeId]                            
,[Notes]      
,[ExcemptionReasonCode]                            
,[ExcemptionReasonText]                            
,[CreationTime]                            
,[AdditionalData1]                            
,[AdditionalData2]                            
,[Language]                            
,[isOtherCharges]                        
)                                             
select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Freight','Freight',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],iif(@freight>0,@freight,i.Freight),iif(@freight>0,@freight,i.Freight),0,                                        
0,iif(@freight>0,@freight,i.Freight),iif(@freight>0,@freight,i.Freight),
i.[VatRate],i.[VatCode],iif(i.[VatCode]='S',iif(@freight>0,@freight,i.Freight)*0.15,0),iif(@freight>0,@freight,i.Freight) + (iif(i.[VatCode]='S',iif(@freight>0,@freight,i.Freight)*0.15,0)),
i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                                
i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],case when (select count (*) from #items where cast(dbo.ISNULLOREMPTYFORDECIMALFOURPLACE(i.[UnitPrice]) as decimal(15,2))>0)>0 then 1 else 0 end                                         
from #items i inner join #header h on i.InvoiceNumber = h.InvoiceNumber where i.Freight <> 0                             
                            
------Customs------                            
insert into [dbo].[FileUpload_TransactionItem](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[Identifier]                                        
,[Name]                                        
,[Description]                                        
,[BuyerIdentifier]                                        
,[SellerIdentifier]                                      
,[StandardIdentifier]                                        
,[Quantity]                            
,[UOM]                            
,[UnitPrice]                            
,[CostPrice]                            
,[DiscountPercentage]                            
,[DiscountAmount]                            
,[GrossPrice]                            
,[NetPrice]                            
,[VATRate]                            
,[VATCode]                            
,[VATAmount]                            
,[LineAmountInclusiveVAT]                            
,[CurrencyCode]                            
,[TaxSchemeId]                            
,[Notes]                            
,[ExcemptionReasonCode]                            
,[ExcemptionReasonText]                            
,[CreationTime]                            
,[AdditionalData1]                            
,[AdditionalData2]                            
,[Language]                            
,[isOtherCharges]                            
)                                             
select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Customs','Customs',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],
iif(@customs>0,@customs,i.Customs),iif(@customs>0,@customs,i.Customs),0,                                        
0,iif(@customs>0,@customs,i.Customs),iif(@customs>0,@customs,i.Customs),
i.[VatRate],i.[VatCode],iif(i.[VatCode]='S',iif(@customs>0,@customs,i.Customs)*0.15,0),iif(@customs>0,@customs,i.Customs) + (iif(i.[VatCode]='S',iif(@customs>0,@customs,i.Customs)*0.15,0)),
  
i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                                        
i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],case when (select count (*) from #items where cast(dbo.ISNULLOREMPTYFORDECIMALFOURPLACE(i.[UnitPrice]) as decimal(15,2))>0)>0 then 1 else 0 end                                         
from #items i inner join #header h on i.InvoiceNumber = h.InvoiceNumber where i.Customs <> 0                          
------Other_Charges------                            
insert into [dbo].[FileUpload_TransactionItem](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                 
,[IRNNo]                                        
,[Identifier]                                        
,[Name]                                        
,[Description]                                        
,[BuyerIdentifier]                                        
,[SellerIdentifier]                                        
,[StandardIdentifier]                                        
,[Quantity]                            
,[UOM]                            
,[UnitPrice]                            
,[CostPrice]                            
,[DiscountPercentage]                            
,[DiscountAmount]                            
,[GrossPrice]                            
,[NetPrice]                            
,[VATRate]                            
,[VATCode]                    
,[VATAmount]                            
,[LineAmountInclusiveVAT]                            
,[CurrencyCode]                            
,[TaxSchemeId]                            
,[Notes]                            
,[ExcemptionReasonCode]                            
,[ExcemptionReasonText]                            
,[CreationTime]                            
,[AdditionalData1]                            
,[AdditionalData2]                            
,[Language]                            
,[isOtherCharges]                            
)                                             
select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Other Charges','Other Charges',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],
iif(@othercharges>0,@othercharges,i.Other_Charges),iif(@othercharges>0,@othercharges,i.Other_Charges),0,                                        
0,iif(@othercharges>0,@othercharges,i.Other_Charges),iif(@othercharges>0,@othercharges,i.Other_Charges),
i.[VatRate],i.[VatCode],iif(i.[VatCode]='S',iif(@othercharges>0,@othercharges,i.Other_Charges)*0.15,0),iif(@othercharges>0,@othercharges,i.Other_Charges)+ (iif(i.[VatCode]='S',iif(@othercharges>0,@othercharges,i.Other_Charges)*0.15,0)),
  
i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                                        
i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],case when (select count (*) from #items where cast(dbo.ISNULLOREMPTYFORDECIMALFOURPLACE(i.[UnitPrice]) as decimal(15,2))>0)>0 then 1 else 0 end                      
from #items i inner join #header h on i.InvoiceNumber = h.InvoiceNumber where i.Other_Charges <> 0      



------Handling_Charges------                            
insert into [dbo].[FileUpload_TransactionItem](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[Identifier]                                        
,[Name]                                        
,[Description]                                        
,[BuyerIdentifier]                                        
,[SellerIdentifier]                                        
,[StandardIdentifier]                                
,[Quantity]                            
,[UOM]                            
,[UnitPrice]                            
,[CostPrice]                            
,[DiscountPercentage]                            
,[DiscountAmount]                            
,[GrossPrice]                            
,[NetPrice]                            
,[VATRate]                            
,[VATCode]                            
,[VATAmount]                            
,[LineAmountInclusiveVAT]                            
,[CurrencyCode]                            
,[TaxSchemeId]                            
,[Notes]                            
,[ExcemptionReasonCode]                            
,[ExcemptionReasonText]                            
,[CreationTime]                            
,[AdditionalData1]                            
,[AdditionalData2]                            
,[Language]                            
,[isOtherCharges]                            
)                                             
select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Handling Charges','Handling Charges',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],
iif(@handlingcharges>0,@handlingcharges,i.Handling_Charges),iif(@handlingcharges>0,@handlingcharges,i.Handling_Charges),0,          
0,iif(@handlingcharges>0,@handlingcharges,i.Handling_Charges),iif(@handlingcharges>0,@handlingcharges,i.Handling_Charges),
i.[VatRate],i.[VatCode],iif(i.[VatCode]='S',iif(@handlingcharges>0,@handlingcharges,i.Handling_Charges)*0.15,0),iif(@handlingcharges>0,@handlingcharges,i.Handling_Charges) + (iif(i.[VatCode]='S',iif(@handlingcharges>0,@handlingcharges,i.Handling_Charges)*0.15,0)),
  
i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                                        
i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],case when (select count (*) from #items where cast(dbo.ISNULLOREMPTYFORDECIMALFOURPLACE(i.[UnitPrice]) as decimal(15,2))>0)>0 then 1 else 0 end                                    
from #items i inner join #header h on i.InvoiceNumber = h.InvoiceNumber where i.Handling_Charges <> 0                            
                                    
----------------------------------------party----------------------------------------------                                
       
		   
SELECT * INTO #buyerDuplicate FROM                           
(SELECT
ISNULL(TransType, '') as TransTypeDescription,                            
case when TransType ='388' then(isnull(SAPInvoiceNumber,'')) else (isnull(BillingReferenceId,'')) end  as InvoiceNumber,                          
@batchid AS BatchId,                          
@tenantId AS TenantId,                          
CAST(NEWID() AS NVARCHAR(36)) AS 'UniqueIdentifier', -- Convert the uniqueidentifier to NVARCHAR                           
-1 AS IRNNo,                          
PayerName AS RegistrationName,                           
PayerVATNumber AS VATID,                          
NULL AS GroupVATID,                          
ShipToMasterCode AS CRNumber,                          
ShipToStreet AS ShipToStreet,                    
ShipToAdditionalStreet AS ShipToAdditionalStreet,                          
ShipToBuildingNumber AS ShipToBuildingNumber,                          
ShipToAdditionalNumber AS ShipToAdditionalNumber,                          
ShipToCity AS ShipToCity,                           
ShipToPostalCode AS ShipToPostalCode,                           
ShipToDisctrictOrNeighbourhood AS ShipToDisctrictOrNeighbourhood,                          
ShipToProvinceOrState AS ShipToProvinceOrState,                          
ShipToCountryCode AS ShipToCountryCode,                          
ShipToContactNumber AS ShipToContactNumber,                          
PayerOtherID AS DeliveryOtherID,                          
PayerMasterCode AS CustomerID,                          
BuyerOtherID AS OtherID,                          
'Buyer' AS 'Type',                          
GETDATE() AS CreationTime,   

JSON_QUERY((SELECT TOP 1 ShipToMasterCode AS crNumber, ShipToName AS registrationName, PayerVATNumber AS vatid,                          
JSON_QUERY((SELECT TOP 1 ShipToBuildingNumber AS buildingNo,                          
ShipToStreet AS street,                          
concat(ShipToAdditionalStreet , ' ' , ShipToAdditionalNumber )as additionalStreet,                                        
ShipToCity AS city,                          
ShipToDisctrictOrNeighbourhood AS neighbourhood,                          
ShipToProvinceOrState AS [state],                          
ShipToPostalCode AS postalCode,                          
ShipToCountryCode AS countryCode FROM #file FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS [address],                           
                          
JSON_QUERY((SELECT TOP 1 ShipToAttn AS [name],                          
ShipToContactNumber AS contactNumber,            
ShipToName as ShipToAttn            
FROM #file FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)) AS contactPerson FROM #file FOR JSON AUTO)) AS AdditionalData1,                          
                          
NULL AS 'Language',                          
PayerCRNNumber AS PayerCRNumber,                          
                          
JSON_QUERY((SELECT TOP 1 PayerNationalIDNumber AS PayerNationalIDNumber,        
PayerMLSNumber AS PayerMLSNumber,                          
PayerOtherNumber as PayerOtherNumber,                          
case when len(isnull(PayerIndustry,'')) = 0 then 'Private' else PayerIndustry end as PayerIndustry,                          
PayerNaturalPerson as PayerNaturalPerson                          
FROM #file FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS AdditionalData2,
PayerNaturalPerson as PayerNaturalPerson,

case when len(isnull(PayerNaturalPerson,''))>0 then
	case when len(isnull(PayerIndustry,'')) > 0 then
		case when lower(PayerIndustry) like '%government%' then ''
		else 'B2C' end
	else 'B2C' end
else 
case when len(isnull(PayerIndustry,'')) > 0 then
PayerIndustry else 'Private' end end AS OtherDocumentTypeId FROM #file ) AS t;                          
                                        
select * into #buyer from                                        
(SELECT h1.InvoiceNumber,h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[RegistrationName],h1.[VATID],h1.[GroupVATID],h1.[CRNumber],h1.[OtherID],h1.[CustomerId],h1.[Type],                                      
h1.[CreationTime],h1.[AdditionalData1],h1.[Language],h1.[OtherDocumentTypeId],h1.[DeliveryOtherID] ,h1.[AdditionalData2],h1.[PayerCRNumber] ,h1.[PayerNaturalPerson]                         
FROM                                        
#buyerDuplicate AS h1                                        
inner join (SELECT InvoiceNumber, max(UniqueIdentifier) as mostrecent                                          
FROM #buyerDuplicate group by InvoiceNumber) AS h2                                        
ON h2.InvoiceNumber = h1.InvoiceNumber and h2.mostrecent = h1.UniqueIdentifier                                        
) as t                                        
                                    
                                    
---------------delivery-----------------                               
-- select * into #buyerDuplicatedelivery from (                                        
-- select                                               
-- SAPInvoiceNumber as InvoiceNumber,                                  
-- @batchid as BatchId,                                               
-- @tenantId as TenantId,                                               
-- NEWID() as 'UniqueIdentifier',                                               
-- -1 as IRNNo,                                               
-- ShipToName as RegistrationName,                                     
-- PayerVATNumber as VATID,                                          
-- null as GroupVATID,                                        
-- null as CRNumber,                                        
-- PayerOtherID as OtherID,                                        
-- PayerMasterCode as CustomerID,                                        
-- 'Delivery' as 'Type',                                        
-- GETDATE() as CreationTime,                                        
-- null as AdditionalData1,                                   
-- null as 'Language',                                        
-- null as OtherDocumentTypeId                                        
--from                                               
--  #file) as t  ;                                    
                    
--select * into #buyerdelivery from                                        
--    (SELECT h1.InvoiceNumber,h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[RegistrationName],h1.[VATID],h1.[GroupVATID],h1.[CRNumber],h1.[OtherID],h1.[CustomerId],h1.[Type],                                      
-- h1.[CreationTime],h1.[AdditionalData1],h1.[Language],h1.[OtherDocumentTypeId]                                           
--  FROM                                        
--#buyerDuplicate AS h1                                        
--inner join (SELECT InvoiceNumber, max(UniqueIdentifier) as mostrecent                                          
--      FROM #buyerDuplicate group by InvoiceNumber) AS h2                                        
--ON h2.InvoiceNumber = h1.InvoiceNumber and h2.mostrecent = h1.UniqueIdentifier                                        
--) as t                                    
                                    
------------------------ buyer -----------------------------------------                                       
         
insert into [dbo].[FileUpload_TransactionParty](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[RegistrationName]                                        
,[VATID]                                        
,[GroupVATID]                                        
,[CRNumber]                                        
,[OtherID]                                        
,[CustomerId]                                        
,[Type]                                        
,[CreationTime]     
,[AdditionalData1]                                        
,[Language]                                        
,[OtherDocumentTypeId]                                           
)                                             
select s.[BatchId],s.[TenantId],h.[UniqueIdentifier],s.[IRNNo],s.[RegistrationName],s.[VATID],s.[GroupVATID],s.[CRNumber],s.[OtherID],s.[CustomerId],s.[Type],s.[CreationTime],                                      
s.[AdditionalData1],s.[Language],s.[OtherDocumentTypeId]                                           
from #buyer s inner join #header h on s.InvoiceNumber = h.InvoiceNumber                                
                                        
-------------------------------- seller -------------------------------------                                        
insert into [dbo].[FileUpload_TransactionParty](                             
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[RegistrationName]                                     
,[VATID]                                        
,[GroupVATID]                                        
,[CRNumber]                                        
,[OtherID]                                    
,[CustomerId]                                    
,[Type]                                    
,[CreationTime]                                    
,[AdditionalData1]                                    
,[Language]                                    
,[OtherDocumentTypeId]                                    
)                                         
select  @batchId as BatchId,@tenantId as TenantId,                                        
h.UniqueIdentifier as 'UniqueIdentifier',-1 as IRNNo,                                        
a.Name as RegistrationName,tb.VATID as VATID,null as GroupVAT,null as CRNumber,                                        
null as OtherId,null as CustomerId,'Supplier' as 'Type',GETDATE() as Creationtime,null as AdditionalData1,                                        
'EN' as 'Language',null as 'OtherDocumentTypeId'                                        
from #buyer b inner join                                         
#header h                                        
on h.InvoiceNumber = b.InvoiceNumber                                        
inner join AbpTenants a                                        
on b.TenantId = a.Id                                        
inner join TenantBasicDetails tb                                         
on a.Id = tb.TenantId where tb.IsDeleted=0                                     
                                      
--------------------------------- delivery -----------------------------------------------------                                        
insert into [dbo].[FileUpload_TransactionParty](                                              
[BatchId]                              
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[RegistrationName]                                        
,[VATID]                                        
,[GroupVATID]                                 
,[CRNumber]                                        
,[OtherID]                                
,[CustomerId]                                
,[Type]                                
,[CreationTime]                                
,[AdditionalData1]                                
,[Language]                                
,[OtherDocumentTypeId]                                
)                                         
select  @batchId as BatchId,@tenantId as TenantId,                                
h.UniqueIdentifier as 'UniqueIdentifier',-1 as IRNNo,                                
a.Name as RegistrationName,tb.VATID as VATID,null as GroupVAT,b.PayerCRNumber as CRNumber,                                
b.DeliveryOtherID as OtherId,null as CustomerId,'Delivery' as 'Type',GETDATE() as Creationtime,b.AdditionalData2 as AdditionalData1,                                
null as 'Language',null as 'OtherDocumentTypeId'                                
from #buyer b inner join                                
#header h                          
on h.InvoiceNumber = b.InvoiceNumber                                
inner join AbpTenants a                                
on b.TenantId = a.Id                                
inner join TenantBasicDetails tb                                
on a.Id = tb.TenantId where tb.IsDeleted=0                                
                                        
         
----------------------------------------address----------------------------------------------                                        
                                      
select * into #buyerAddressDuplicate from (                                        
select 
ISNULL(TransType, '') as TransTypeDescription,                            
case when TransType ='388' then(isnull(SAPInvoiceNumber,'')) else (isnull(BillingReferenceId,'')) end  as InvoiceNumber,  
@batchid as BatchId,                                               
@tenantId as TenantId,                                               
NEWID() as 'UniqueIdentifier',                                           
-1 as IRNNo,                                          
PayerStreet as Street,                                        
concat(PayerAdditionalStreet , ' ' , PayerPOBox )as AdditionalStreet,                                        
PayerBuildingNumber as BuildingNo,                                 
PayerAdditionalNumber as AdditionalNo,                                        
PayerCity as City,                                        
PayerPostalCode as PostalCode,                                        
PayerProvinceOrState as State,                                        
PayerDistrictOrNeighbourhood as Neighbourhood,                                        
PayerCountryCode as CountryCode,                                        
'Buyer' as 'Type',                                        
GETDATE() as CreationTime,                                        
--JSON_QUERY((SELECT TOP 1 PayerPOBox AS PayerPOBox                       
--FROM #file FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) as AdditionalData1,                    
null as AdditionalData1,                  
null as 'Language'                                        
from                                               
#file) as t  ;                                        
                                        
select * into #buyerAddress from                                        
(SELECT h1.InvoiceNumber,h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[Street],h1.[AdditionalStreet],h1.[BuildingNo],h1.[AdditionalNo],h1.[City],h1.[PostalCode],h1.[State],                  
h1.[Neighbourhood],h1.[CountryCode],h1.[Type],                                      
h1.[CreationTime],h1.[AdditionalData1],h1.[Language]                                         
FROM                                        
#buyerAddressDuplicate AS h1                                        
inner join (SELECT InvoiceNumber, max(UniqueIdentifier) as mostrecent                                          
FROM #buyerAddressDuplicate group by InvoiceNumber) AS h2                                        
ON h2.InvoiceNumber = h1.InvoiceNumber and h2.mostrecent = h1.UniqueIdentifier                                        
) as t                                       
                                    
-------------------------------------------delivery----------------------------------------------------------                                    
                                    
select * into #buyerAddressDuplicateDelivery from (                          
select           
ISNULL(TransType, '') as TransTypeDescription,                            
case when TransType ='388' then(isnull(SAPInvoiceNumber,'')) else (isnull(BillingReferenceId,'')) end  as InvoiceNumber,                         
@batchid as BatchId,                                               
@tenantId as TenantId,                                               
NEWID() as 'UniqueIdentifier',                                           
-1 as IRNNo,                                          
ShipToStreet as Street,                                        
ShipToAdditionalStreet as AdditionalStreet,                                        
ShipToBuildingNumber as BuildingNo,                                        
ShipToBuildingNumber as AdditionalNo,                                        
ShipToCity as City,                                        
ShipToPostalCode as PostalCode,                                        
ShipToProvinceOrState as State,                   
ShipToDisctrictOrNeighbourhood as Neighbourhood,                                        
ShipToCountryCode as CountryCode,                                        
'Delivery' as 'Type',       
GETDATE() as CreationTime,                                        
null as AdditionalData1,                                        
null as 'Language'                                        
from                                               
#file) as t  ;     

                              
select * into #buyerAddressDelivery from                                        
(SELECT h1.InvoiceNumber,h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[Street],h1.[AdditionalStreet],h1.[BuildingNo],h1.[AdditionalNo],h1.[City],h1.[PostalCode],h1.[State],                                      
h1.[Neighbourhood],h1.[CountryCode],h1.[Type],                                      
h1.[CreationTime],h1.[AdditionalData1],h1.[Language]                                         
FROM                                        
#buyerAddressDuplicateDelivery AS h1                                        
inner join (SELECT InvoiceNumber, max(UniqueIdentifier) as mostrecent                                          
FROM #buyerAddressDuplicateDelivery group by InvoiceNumber) AS h2                                        
ON h2.InvoiceNumber = h1.InvoiceNumber and h2.mostrecent = h1.UniqueIdentifier                                        
) as t   

-------------------------------------------buyer ------------------------------------------------------------                                       
                                        
insert into [dbo].[FileUpload_TransactionAddress](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[Street]                                        
,[AdditionalStreet]                                        
,[BuildingNo]                                        
,[AdditionalNo]                                        
,[City]                                        
,[PostalCode]                                        
,[State]                                        
,[Neighbourhood]                                        
,[CountryCode]                                        
,[Type]                                        
,[CreationTime]                                        
,[AdditionalData1]                                        
,[Language]                                        
)                 
select s.[BatchId],s.[TenantId],h.[UniqueIdentifier],s.[IRNNo],s.[Street],s.[AdditionalStreet],s.[BuildingNo],s.[AdditionalNo],s.[City],s.[PostalCode],s.[State],s.[Neighbourhood],s.[CountryCode],                                      
s.[Type],s.[CreationTime],s.[AdditionalData1],s.[Language]                                           
from #buyerAddress s inner join #header h on s.InvoiceNumber = h.InvoiceNumber                                         
                                        
------------------------------------------------------------ seller -------------------------------------------------------------                                       
                                        
insert into [dbo].[FileUpload_TransactionAddress](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[Street]                                        
,[AdditionalStreet]                                        
,[BuildingNo]                                        
,[AdditionalNo]                                        
,[City]                                        
,[PostalCode]                                        
,[State]                                        
,[Neighbourhood]               
,[CountryCode]                                        
,[Type]                                        
,[CreationTime]                                        
,[AdditionalData1]                                        
,[Language]                                        
)                                             
select b.[BatchId],b.[TenantId],h.[UniqueIdentifier],b.[IRNNo],                                        
tb.Street, tb.AdditionalStreet,tb.BuildingNo,tb.AdditionalBuildingNumber,tb.City,                                        
tb.PostalCode,tb.State,tb.Neighbourhood,tb.CountryCode,'Supplier',                                        
getDate(),null,null                                        
from #buyer b inner join                                         
#header h                                        
on h.InvoiceNumber = b.InvoiceNumber                                        
inner join AbpTenants a                                        
on b.TenantId = a.Id                                        
inner join TenantAddress tb                                         
on a.Id = tb.TenantId                                    
                                      
------------------------------------------delivery--------------------------------------------                                    
insert into [dbo].[FileUpload_TransactionAddress](                                              
[BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                    
,[Street]                                        
,[AdditionalStreet]                            
,[BuildingNo]                                        
,[AdditionalNo]                                        
,[City]                                        
,[PostalCode]                                        
,[State]                                        
,[Neighbourhood]                                        
,[CountryCode]                                        
,[Type]                                        
,[CreationTime]                       
,[AdditionalData1]                                        
,[Language]                                        
)                                           
select b.[BatchId],b.[TenantId],h.[UniqueIdentifier],b.[IRNNo],                                        
b.Street, b.AdditionalStreet,b.BuildingNo,tb.AdditionalBuildingNumber,b.City,                                        
b.PostalCode,b.State,b.Neighbourhood,b.CountryCode,'Delivery',                                        
getDate(),null,null                                        
from #buyerAddressDelivery b inner join                                         
#header h                                        
on h.InvoiceNumber = b.InvoiceNumber                                        
inner join AbpTenants a                                        
on b.TenantId = a.Id                                        
inner join TenantAddress tb                                         
on a.Id = tb.TenantId                                    
----------------------------------------summary----------------------------------------------      

--select * from #items

declare @invoicevatcode nvarchar(10); --FileUploadSalesT1Brady
set @invoicevatcode =  (select top 1 VatCode from #items)
set @extracharges = (select top 1 cast(isnull(Freight,0)  as decimal(15,2))+cast(isnull(Customs,0)  as decimal(15,2))+cast(isnull(Handling_Charges,0)  as decimal(15,2))+cast(isnull(Other_Charges,0)  as decimal(15,2)) from #items)

print '@extracharge'
print @extracharges
 

select * into #summary from                                         
(select                         
case when @transtype ='388' then(isnull(SAPInvoiceNumber,'')) else (isnull(BillingReferenceId,'')) end  as InvoiceNumber,                              
@batchid as BatchId,                                        
@tenantId as TenantId,                                        
@uuid as 'UniqueIdentifier',                                        
'-1' as IRNNo,                                        
sum(cast(Quantity as decimal(15,2))*cast(UnitPrice as decimal(15,2))) as NetInvoiceAmount,                                        
'SAR' as [NetInvoiceAmountCurrency],                                        
sum(cast(Quantity as decimal(15,2))*cast(UnitPrice as decimal(15,2))) - sum(cast(DiscountAmount as decimal(15,2))) as SumOfInvoiceLineNetAmount,                                         
'SAR' as [SumOfInvoiceLineNetAmountCurrency],                                        
sum(cast(LineAmountInclusiveVAT  as decimal(15,2)))-sum(cast(VATAmount as decimal(15,2))) as TotalAmountWithoutVAT,                                         
'SAR' as [TotalAmountWithoutVATCurrency],

--sum(cast(LineAmountInclusiveVAT  as decimal(15,2)))  as TotalAmountWithVAT,

case when @extracharges > 0 then sum(cast(LineAmountInclusiveVAT  as decimal(15,2))) + @extracharges + iif(@invoicevatcode = 'S', (@extracharges*0.15),0)
else sum(cast(LineAmountInclusiveVAT  as decimal(15,2))) end  as TotalAmountWithVAT,
    

sum(cast(VATAmount as decimal(15,2))) as TotalVATAmount,                                         
'SAR' as CurrencyCode,                                        
0 as PaidAmount,                                        
'SAR' as PaidAmountCurrency,                                        
0 as PayableAmount,                                        
'SAR' as PayableAmountCurrency,                  
0 as [AdvanceAmountwithoutVat],                                        
0 as [AdvanceVat],                                        
GETDATE() as  [CreationTime],                                        
(select val1,val2,HandlingCharges,OtherCharges from #file for json auto) as [AdditionalData1]                                        
from #items 
group by InvoiceNumber,SAPInvoiceNumber,BillingReferenceId,CreationTime)       
as t;  
---------------------------------------------------------------------------
---------------------------------------------------------------------------
             
--select * from #summary                                    
                                      
INSERT INTO [dbo].[FileUpload_TransactionSummary]                                        
([BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                        
,[NetInvoiceAmount]                                        
,[NetInvoiceAmountCurrency]                                        
,[SumOfInvoiceLineNetAmount]                                        
,[SumOfInvoiceLineNetAmountCurrency]                                        
,[TotalAmountWithoutVAT]                                        
,[TotalAmountWithoutVATCurrency]                                        
,[TotalVATAmount]                                        
,[CurrencyCode]                                        
,[TotalAmountWithVAT]                                        
,[PaidAmount]                                        
,[PaidAmountCurrency]                             
,[PayableAmount]                                        
,[PayableAmountCurrency]                                        
,[AdvanceAmountwithoutVat]                                        
,[AdvanceVat]                                        
,[CreationTime]                                        
,[AdditionalData1])                                        
                                        
select s.[BatchId],s.[TenantId],h.[UniqueIdentifier],s.[IRNNo],s.[NetInvoiceAmount],s.[NetInvoiceAmountCurrency],s.[SumOfInvoiceLineNetAmount],s.[SumOfInvoiceLineNetAmountCurrency],s.[TotalAmountWithoutVAT],s.[TotalAmountWithoutVATCurrency],           

s.[TotalVATAmount],s.[CurrencyCode],s.[TotalAmountWithVAT],s.[PaidAmount],s.[PaidAmountCurrency],s.[PayableAmount],s.[PayableAmountCurrency],s.[AdvanceAmountwithoutVat],s.[AdvanceVat],s.[CreationTime],s.[AdditionalData1]                                 
  
from #summary s                                        
inner join #header h                                        
on s.InvoiceNumber=h.InvoiceNumber     

--select * from FileUpload_TransactionSummary order by 1 desc
                        
----------------------------------------Contact----------------------------------------------                                     
select * into #contact from                                         
(select  TOP 1                                      
@batchid as BatchId,                                        
@tenantId as TenantId,                                        
@uuid as 'UniqueIdentifier',                                        
'-1' as IRNNo,                                    
GETDATE() as CreationTime,                                    
PayerContactNumber as ContactNumber,                   
PayerEmailId as Email,                  
'Buyer' as Type,              
Attn as [Name]              
from #file)                                         
as t;                                    
                                    
                                    
INSERT INTO [dbo].[FileUpload_TransactionContactPerson]                                        
([BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                 
,[CreationTime]                                    
,[ContactNumber],                   
[Email],                  
[Type],              
[Name])                                      
select s.[BatchId],s.[TenantId],h.[UniqueIdentifier],s.[IRNNo],s.CreationTime,s.[ContactNumber],s.Email,s.[Type],s.[Name]                                        
from #contact s                                    
inner join #header h                                        
on s.IRNNo=h.IRNNo  where [Type] ='Buyer'              
                                
select * into #contactDeliver from                                         
(select  TOP 1                                      
@batchid as BatchId,                                        
@tenantId as TenantId,                                        
@uuid as 'UniqueIdentifier',                          
'-1' as IRNNo,                         
GETDATE() as CreationTime,                                    
ShipToContactNumber as ContactNumber,            
'Delivery' as Type              
from #file)              
as t;                                    
                                    
INSERT INTO [dbo].[FileUpload_TransactionContactPerson]                            
([BatchId]                                        
,[TenantId]                                        
,[UniqueIdentifier]                                        
,[IRNNo]                                    
,[CreationTime]                                    
,[ContactNumber],                                
[Type])                                      
select s.[BatchId],s.[TenantId],h.[UniqueIdentifier],s.[IRNNo],s.CreationTime,s.[ContactNumber],s.[Type]                                        
from #contactDeliver s                                    
inner join #header h                                        
on s.IRNNo=h.IRNNo  where [Type] ='Delivery'                                 
                                    
exec [dbo].[GetJsonForValidation] @batchid,@tenantId                                
                                        
end
GO
