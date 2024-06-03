SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
                       
CREATE     procedure [dbo].[FileUploadSalesT1]                  
 (@batchid int =2499,                          
 @tenantId int = 127,                          
 @json nvarchar(max)        
 )                          
 as                          
 begin              
                           
declare @uuid uniqueidentifier = NEWID();              
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
    AccountNumber nvarchar(max) '$."AccountNumber"',
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
    ItemNetPrice nvarchar(max) '$."ItemNetPrice"',                        
    CurrencyCode nvarchar(max) '$."CurrencyCode"',        
    LineAmountExclusiveVAT nvarchar(max) '$."LineAmountExclusiveVAT"',            
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
    InvoiceVAT nvarchar(max) '$."TotalVATAmount"',        
    InvoiceTotal nvarchar(max) '$."TotalAmount"',        
    Footer nvarchar(max) '$."Footer"', --not mapped                        
    AdditionalDetails1 nvarchar(max) '$."AdditionalDetails1"', --not mapped                        
    AdditionalDetails2 nvarchar(max) '$."AdditionalDetails2"', --not mapped                        
    AdditionalDetails3 nvarchar(max) '$."AdditionalDetails3"', --not mapped                        
    AdditionalDetails4 nvarchar(max) '$."AdditionalDetails4"',  --not mapped              
 PayerCRNNumber nvarchar(max) '$."PayerCRNNumber"',            
 PayerNationalIDNumber nvarchar(max) '$."PayerNationalIDNumber"',            
 PayerMLSNumber nvarchar(max) '$."PayerMLSNumber"',            
 PayerOtherNumber nvarchar(max) '$."PayerOtherNumber"',          
 PayerIndustry nvarchar(max) '$."PayerIndustry"',    
 PayerNaturalPerson nvarchar(max) '$."PayerNaturalPerson"',    
 PayerPOBox nvarchar(max) '$."PayerPOBox"',    
 PayerEmailId nvarchar(max) '$."PayerEmail"'

 --AccountName nvarchar(max) '$."AccountName"',
 -- AccountNumber nvarchar(max) '$."AccountNumber"',
 -- IBAN nvarchar(max) '$."IBAN"',
 -- BankName nvarchar(max) '$."BankName"',
 -- SwiftCode nvarchar(max) '$."SwiftCode"'
 )                           
) as t;                          
                      
--------------------------------------------header-------------------------------------------                          
                        
  select * into #headerDuplicates from(                          
 select                                 
  @batchid as BatchId,                          
  @tenantId as TenantId,                                 
  NEWID() as 'UniqueIdentifier',                                 
  -1 as IRNNo,                                 
  isnull(SAPInvoiceNumber,'') as InvoiceNumber,           --exec FileUploadSalesT1              
  --dbo.ISNULLOREMPTYFORDATE(SAPInvoiceDate) as IssueDate,                
  getdate() as IssueDate,                
  dbo.ISNULLOREMPTYFORDATE(SupplyDate) as DateOfSupply,                                 
  ISNULL(InvoiceCurrencyCode, '') as InvoiceCurrencyCode,                                 
  null as CurrencyCodeOriginatingCountry , -- CurrencyCodeOriginatingCountry to be checked                          
  ISNULL(PurchaseOrderId, '') as PurchaseOrderId,                             
  isnull(SAPInvoiceNumber,'') as BillingReferenceId,  -- BillingReferenceId to be checked                
  ISNULL(ContractId, '') as ContractId,                                 
  dbo.ISNULLOREMPTYFORDATE(SupplyEndDate) as LatestDeliveryDate,                          
  null as 'Location',                          
  null as 'CustomerId',                          
  null as 'Status',                          
  null as 'Additional_Info',                          
  ISNULL(PaymentMeans, '') as PaymentType,               
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
  ISNULL(TransType, '') as TransTypeDescription,              
  null as AdvanceReferenceNumber,              
  null as Invoicetransactioncode,              
  null as BusinessProcessType,              
  GetDate() as CreationTime,              
  Notes as InvoiceNotes,              
  null as XmlUuid,              
  (select top 1 ExchangeRate as exchangeRate from #file for JSON AUTO) as AdditionalData1,                
  (select top 1 OriginalQuoteNumber as original_quote_number,              
  PaymentTerms as payment_terms,              
  SAPInvoiceDate as invoice_reference_date,              
  SupplyDate as delivery_date,              
  DeliveryDocumentNo as delivery_document_no,              
  CarrierAndService as carrier_and_services,              
  OrderPlacedBy as order_placed_by,              
  TermsOfDelivery as terms_of_delivery,              
  SupplyEndDate as invoice_due_date,              
  WeAreYourVendor as we_are_your_vendor#,              
  PaymentMeans as payment_means,              
  ContractId as original_order_number,              
  PurchaseOrderId as purchase_order_no,  
  CreditOrDebitReasons as CreditOrDebitReasons,  
  concat(isnull(BankName,''),' ',isnull(AccountName,''),' ',isnull(AccountNumber,''),' ',isnull(IBAN,''),' ',isnull(SWIFT,'')) as bank_information                     
  from #file for JSON AUTO) as AdditionalData2,                          
  null as AdditionalData3,              
  null as AdditionalData4,              
  null as InvoiceTypeCode,              
  null as 'Language',
  isnull(BankName,'') as BankName,
  isnull(AccountName,'') as AccountName,
  isnull(AccountNumber,'') as AccountNumber,
  isnull(IBAN,'') as IBAN,
  isnull(SWIFT,'') as SWIFT
from                                 
  #file) as t  ;              
                          
  select * into #header from                          
    (SELECT  h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[InvoiceNumber],h1.[IssueDate],h1.[DateOfSupply],h1.[InvoiceCurrencyCode],h1.[CurrencyCodeOriginatingCountry],h1.[PurchaseOrderId],                        
 h1.[BillingReferenceId],h1.[ContractId],h1.[LatestDeliveryDate],h1.[Location],h1.[CustomerId],h1.[Status],h1.[Additional_Info],h1.[PaymentType],h1.[PdfUrl],h1.[QrCodeUrl],h1.[XMLUrl],h1.[ArchivalUrl],                        
 h1.[PreviousInvoiceHash],h1.[PerviousXMLHash],h1.[XMLHash],h1.[PdfHash],h1.[XMLbase64],h1.[PdfBase64],h1.[IsArchived],h1.[TransTypeCode],h1.[TransTypeDescription],h1.[AdvanceReferenceNumber],                        
 h1.[Invoicetransactioncode],h1.[BusinessProcessType],h1.[CreationTime],h1.[InvoiceNotes],h1.[XmlUuid],h1.[AdditionalData1],h1.[AdditionalData2],h1.[AdditionalData3],h1.[AdditionalData4],                        
 h1.[InvoiceTypeCode],h1.[Language],h1.[BankName], h1.[AccountName], h1.[AccountNumber], h1.[IBAN], h1.[SWIFT]                    
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
		   ,AccountName
		   ,AccountNumber
		   ,IBAN
		   ,SwiftCode
  )                            
  SELECT  h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[InvoiceNumber],isnull(h1.[IssueDate],GETDATE()),h1.[DateOfSupply],h1.[InvoiceCurrencyCode],h1.[CurrencyCodeOriginatingCountry],h1.[PurchaseOrderId],                        
  h1.[BillingReferenceId],h1.[ContractId],h1.[LatestDeliveryDate],h1.[Location],h1.[CustomerId],h1.[Status],h1.[Additional_Info],h1.[PaymentType],h1.[PdfUrl],h1.[QrCodeUrl],h1.[XMLUrl],h1.[ArchivalUrl],                        
  h1.[PreviousInvoiceHash],h1.[PerviousXMLHash],h1.[XMLHash],h1.[PdfHash],h1.[XMLbase64],h1.[PdfBase64],h1.[IsArchived],h1.[TransTypeCode],h1.[TransTypeDescription],h1.[AdvanceReferenceNumber],                        
  h1.[Invoicetransactioncode],h1.[BusinessProcessType],h1.[CreationTime],h1.[InvoiceNotes],h1.[XmlUuid],h1.[AdditionalData1],h1.[AdditionalData2],h1.[AdditionalData3],h1.[AdditionalData4],                        
  h1.[InvoiceTypeCode],h1.[Language] ,h1.[BankName], h1.[AccountName], h1.[AccountNumber], h1.[IBAN], h1.[SWIFT]                         
  FROM                          
#header AS h1                          
                          
                          
  ---------------------------------------items-----------------------------------------------                          
    select * into #items from(                          
select                                 
SAPInvoiceNumber as InvoiceNumber,                        
 @batchid as BatchId,                                 
 @tenantId as TenantId,                                 
 @uuid as 'UniqueIdentifier',                                 
 -1 as IRNNo,                                 
 ISNULL(LineIdentifier, '') as Identifier,            --exec FileUploadSalesT1              
 LineOriginIndicator as Name,                                 
 PartNumberDescription as Description,                          
 null as BuyerIdentifier,            
 null as SellerIdentifier,                          
 null as StandardIdentifier,                          
    dbo.ISNULLOREMPTYFORDECIMAL(ItemQuantity) as Quantity,                                 
    ISNULL(ItemUOM, '') as UOM,                                 
              
 cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(UnitPrice) as decimal(15,2))*cast(dbo.ISNULLOREMPTYFORDECIMAL(ExchangeRate) as float) as nvarchar(max)) as UnitPrice,              
 cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(ListPrice) as decimal(15,2))*cast(dbo.ISNULLOREMPTYFORDECIMAL(ExchangeRate) as float) as nvarchar(max)) as CostPrice,              
 --0 as CostPrice,              
 0 as DiscountPercentage,              
 0 as DiscountAmount,                            
              
cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as decimal(15,2))*cast(dbo.ISNULLOREMPTYFORDECIMAL(ExchangeRate) as float) as nvarchar(max)) as GrossPrice,               
cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as decimal(15,2))*cast(dbo.ISNULLOREMPTYFORDECIMAL(ExchangeRate) as float) as nvarchar(max)) as NetPrice,              
              
 dbo.ISNULLOREMPTYFORDECIMAL(ItemVATRate) as VatRate,                            
 ISNULL(ItemVATCode,'') as VatCode,                  
              
 cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(ItemVATAmount) as decimal(15,2))*cast(dbo.ISNULLOREMPTYFORDECIMAL(ExchangeRate) as float) as nvarchar(max)) as VATAmount,              
 cast(cast(dbo.ISNULLOREMPTYFORDECIMAL(LineAmountInclusiveVAT) as decimal(15,2))*cast(dbo.ISNULLOREMPTYFORDECIMAL(ExchangeRate) as float) as nvarchar(max)) as LineAmountInclusiveVAT,              
              
 ISNULL(InvoiceCurrencyCode, '') as CurrencyCode,              
 null as TaxSchemeId,              
 null as Notes,                          
 ISNULL(VatExemptionReasonCode, '') as ExcemptionReasonCode,                                 
 ISNULL(VatExemptionReason, '') as ExcemptionReasonText,                           
 GETDATE() as CreationTime,                          
 null as AdditionalData1,                          
 null as AdditionalData2,                          
 null as 'Language',              
iif(val1='',0,cast(val1 as decimal(18,2))) as Freight,                         
iif(val2='',0,cast(val2 as decimal(18,2))) as Customs,                         
iif(HandlingCharges='',0,cast(HandlingCharges as decimal(18,2))) as Handling_Charges,                         
iif(OtherCharges='',0,cast(OtherCharges as decimal(18,2))) as Other_Charges             
from                            
  #file) as t  ;              
              
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
  from #items i inner join #header h on i.InvoiceNumber = h.InvoiceNumber               
              
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
  select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Frieght','Frieght',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],i.Freight,0,0,                        
  0,0,0,0,0,0,0,i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                        
  i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],1                          
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
  select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Customs','Customs',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],i.Customs,0,0,                        
  0,0,0,0,0,0,0,i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                        
  i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],1                          
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
  select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Other Charges','Other Charges',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],i.Other_Charges,0,0,                        
  0,0,0,0,0,0,0,i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                        
  i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],1                          
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
  select top 1 i.[BatchId],i.[TenantId],h.[UniqueIdentifier],i.[IRNNo],i.[Identifier],'Handling Charges','Handling Charges',i.[BuyerIdentifier],i.[SellerIdentifier],i.[StandardIdentifier],1,i.[UOM],i.Handling_Charges,0,0,                        
  0,0,0,0,0,0,0,i.[CurrencyCode],i.[TaxSchemeId],i.[Notes],i.[ExcemptionReasonCode],i.[ExcemptionReasonText],                        
  i.[CreationTime],i.[AdditionalData1],i.[AdditionalData2],i.[Language],1                          
  from #items i inner join #header h on i.InvoiceNumber = h.InvoiceNumber where i.Handling_Charges <> 0              
                      
  ----------------------------------------party----------------------------------------------                  
              
 SELECT * INTO #buyerDuplicate FROM             
 (SELECT SAPInvoiceNumber AS InvoiceNumber,            
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
 ShipToAdditionalStreet AS additionalStreet,            
 ShipToCity AS city,            
 ShipToDisctrictOrNeighbourhood AS neighbourhood,            
 ShipToProvinceOrState AS [state],            
 ShipToPostalCode AS postalCode,            
 ShipToCountryCode AS countryCode FROM #file FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS [address],             
            
 JSON_QUERY((SELECT TOP 1 ShipToName AS [name],            
 ShipToContactNumber AS contactNumber             
 FROM #file FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)) AS contactPerson FROM #file FOR JSON AUTO)) AS AdditionalData1,            
            
 NULL AS 'Language',            
  PayerCRNNumber AS PayerCRNumber,            
            
 JSON_QUERY((SELECT TOP 1 PayerNationalIDNumber AS PayerNationalIDNumber,            
 PayerMLSNumber AS PayerMLSNumber,            
 PayerOtherNumber as PayerOtherNumber,            
 PayerIndustry as PayerIndustry,            
 PayerNaturalPerson as PayerNaturalPerson            
 FROM #file FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS AdditionalData2,            
 NULL AS OtherDocumentTypeId FROM #file ) AS t;            
                          
 select * into #buyer from                          
 (SELECT h1.InvoiceNumber,h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[RegistrationName],h1.[VATID],h1.[GroupVATID],h1.[CRNumber],h1.[OtherID],h1.[CustomerId],h1.[Type],                        
 h1.[CreationTime],h1.[AdditionalData1],h1.[Language],h1.[OtherDocumentTypeId],h1.[DeliveryOtherID] ,h1.[AdditionalData2],h1.[PayerCRNumber]            
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
  null as 'Language',null as 'OtherDocumentTypeId'                          
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
 SAPInvoiceNumber as InvoiceNumber,                          
 @batchid as BatchId,                                 
 @tenantId as TenantId,                                 
 NEWID() as 'UniqueIdentifier',                             
 -1 as IRNNo,                            
 PayerStreet as Street,                          
 PayerAdditionalStreet as AdditionalStreet,                          
 PayerBuildingNumber as BuildingNo,                          
 PayerAdditionalNumber as AdditionalNo,                          
 PayerCity as City,                          
 PayerPostalCode as PostalCode,                          
 PayerProvinceOrState as State,                          
 PayerDistrictOrNeighbourhood as Neighbourhood,                          
 PayerCountryCode as CountryCode,                          
 'Buyer' as 'Type',                          
 GETDATE() as CreationTime,                          
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
 SAPInvoiceNumber as InvoiceNumber,                          
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
     
JSON_QUERY((SELECT TOP 1 PayerPOBox AS PayerPOBox         
 FROM #file FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) as AdditionalData1,     
     
 null as 'Language'                          
from                                 
  #file) as t  ;              
   select * into #buyerAddressDelivery from                          
    (SELECT h1.InvoiceNumber,h1.[BatchId],h1.[TenantId],h1.[UniqueIdentifier],h1.[IRNNo],h1.[Street],h1.[AdditionalStreet],h1.[BuildingNo],h1.[AdditionalNo],h1.[City],h1.[PostalCode],h1.[State],                        
 h1.[Neighbourhood],h1.[CountryCode],h1.[Type],                        
 h1.[CreationTime],h1.[AdditionalData1],h1.[Language]                           
  FROM                          
#buyerAddressDuplicate AS h1                          
inner join (SELECT InvoiceNumber, max(UniqueIdentifier) as mostrecent                            
      FROM #buyerAddressDuplicate group by InvoiceNumber) AS h2                          
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
   tb.Street, tb.AdditionalStreet,tb.BuildingNo,tb.AdditionalBuildingNumber,tb.City,                          
   tb.PostalCode,tb.State,tb.Neighbourhood,tb.CountryCode,'Delivery',                          
   getDate(),null,null                          
  from #buyerAddressDelivery b inner join                           
   #header h                          
  on h.InvoiceNumber = b.InvoiceNumber                          
  inner join AbpTenants a                          
  on b.TenantId = a.Id                      
  inner join TenantAddress tb                           
  on a.Id = tb.TenantId                      
----------------------------------------summary----------------------------------------------                         
                        
 select * into #summary from                           
 (select                           
 InvoiceNumber as InvoiceNumber,                           
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
 sum(cast(LineAmountInclusiveVAT  as decimal(15,2))) as TotalAmountWithVAT,                           
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
 from #items group by InvoiceNumber)                           
 as t;                          
                          
                           
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
                        
  ----------------------------------------Contact----------------------------------------------                       
   select * into #contact from                           
 (select  TOP 1                        
 @batchid as BatchId,                          
 @tenantId as TenantId,                          
 @uuid as 'UniqueIdentifier',                          
 '-1' as IRNNo,                      
 GETDATE() as CreationTime,                      
 PayerContactNumber as ContactNumber,                  
 'Buyer' as Type,    
 PayerEmailId as Email    
 from #file)                           
 as t;                      
                      
                      
 INSERT INTO [dbo].[FileUpload_TransactionContactPerson]                          
           ([BatchId]                          
           ,[TenantId]                          
           ,[UniqueIdentifier]                          
           ,[IRNNo]                      
     ,[CreationTime]                      
     ,[ContactNumber],                  
  [Type],    
  [Email])                        
 select s.[BatchId],s.[TenantId],h.[UniqueIdentifier],s.[IRNNo],s.CreationTime,s.[ContactNumber],s.[Type],s.[Email]                          
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
