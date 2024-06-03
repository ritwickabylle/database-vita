SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    PROCEDURE [dbo].[GetJsonForValidation]  --exec [GetJsonForValidation] 6752,140            
(                      
@batchid INT=7594 ,                      
@tenantId int=140                      
)      
as                  
begin             
                
                
declare @uuid UniqueIdentifier,                
@sqlStatement nvarchar(500) = 'exec [dbo].[ExecuteRulesFileUpload] @RuleGroupId,@tenantId,@json,@error OUTPUT',                
@err nvarchar(max)=null,                
@error nvarchar(max)=null;

declare @isEmailenable nvarchar(max);

select @isEmailenable=isEmailenable        
FROM [dbo].[TenantConfiguration]        
cross apply openjson(emailjson)        
with        
(isEmailenable nvarchar(max) '$.isenableemail')        
where TenantId = @tenantId and upper([transactiontype])='GENERAL'

                  
declare @record CURSOR;                  
set @record=                   
CURSOR FOR                  
select  [UniqueIdentifier] from [dbo].[FileUpload_TransactionHeader]                  
where batchId = @batchid                  
order by id desc 
     
OPEN @record                  
FETCH NEXT                   
FROM @record INTO @uuid;                  
WHILE @@FETCH_STATUS = 0                  
BEGIN                  
                  
declare @Supplier_Id nvarchar(max)                  
declare @Supplier_TenantId nvarchar(max)                  
declare @Supplier_UniqueIdentifier nvarchar(max)                  
declare @Supplier_IRNNo nvarchar(max)                  
declare @Supplier_RegistrationName nvarchar(max)                  
declare @Supplier_VATID nvarchar(max)                  
declare @Supplier_GroupVATID nvarchar(max)                  
declare @Supplier_CRNumber nvarchar(max)                  
declare @Supplier_OtherID nvarchar(max)                  
declare @Supplier_CustomerId nvarchar(max)                  
declare @Supplier_Type nvarchar(max)                  
                  
declare @Supplier_Street nvarchar(max)                  
declare @Supplier_AdditionalStreet nvarchar(max)                  
declare @Supplier_BuildingNo nvarchar(max)                  
declare @Supplier_AdditionalNo nvarchar(max)                  
declare @Supplier_City nvarchar(max)                  
declare @Supplier_PostalCode nvarchar(max)                  
declare @Supplier_State nvarchar(max)                  
declare @Supplier_Neighbourhood nvarchar(max)                  
declare @Supplier_CountryCode nvarchar(max)                  
declare @Supplier_ContactNumber nvarchar(max)                  
declare @Supplier_Email nvarchar(max)                  
                  
declare @buyer_Id nvarchar(max)                  
declare @buyer_TenantId nvarchar(max)                  
declare @buyer_UniqueIdentifier nvarchar(max)                  
declare @buyer_IRNNo nvarchar(max)                  
declare @buyer_RegistrationName nvarchar(max)                  
declare @buyer_VATID nvarchar(max)                  
declare @buyer_GroupVATID nvarchar(max)                  
declare @buyer_CRNumber nvarchar(max)                  
declare @buyer_OtherID nvarchar(max)
declare @buyer_OtherDocumentTypeId nvarchar(max)                  
declare @buyer_CustomerId nvarchar(max)                  
declare @buyer_Type nvarchar(max)                  
                  
declare @buyer_Street nvarchar(max)                  
declare @buyer_AdditionalStreet nvarchar(max)                  
declare @buyer_BuildingNo nvarchar(max)                  
declare @buyer_AdditionalNo nvarchar(max)                  
declare @buyer_PostalCode nvarchar(max)                  
declare @buyer_City nvarchar(max)                  
declare @buyer_State nvarchar(max)                  
declare @buyer_Neighbourhood nvarchar(max)                  
declare @buyer_CountryCode nvarchar(max)                  
declare @buyer_ContactNumber nvarchar(max)                  
declare @buyer_Email nvarchar(max)      
declare @buyer_ShiptoCountryCode nvarchar(max)
declare @buyer_isEmailenable nvarchar(max)
    
                  
declare @itemRows nvarchar(max)                  
                  
declare @items_Id nvarchar(max)                  
declare @items_TenantId nvarchar(max)                  
declare @items_UniqueIdentifier nvarchar(max)                  
declare @items_IRNNo nvarchar(max)                  
declare @items_Identifier nvarchar(max)                  
declare @items_Name nvarchar(max)                  
declare @items_Description nvarchar(max)                  
declare @items_BuyerIdentifier nvarchar(max)                  
declare @items_SellerIdentifier nvarchar(max)                  
declare @items_StandardIdentifier nvarchar(max)                  
declare @items_Quantity nvarchar(max)                  
declare @items_UOM nvarchar(max)                  
declare @items_UnitPrice nvarchar(max)                  
declare @items_CostPrice nvarchar(max)                  
declare @items_DiscountPercentage nvarchar(max)                  
declare @items_DiscountAmount nvarchar(max)                  
declare @items_GrossPrice nvarchar(max)                  
declare @items_NetPrice nvarchar(max)                  
declare @items_VATRate nvarchar(max)                  
declare @items_VATCode nvarchar(max)                  
declare @items_VATAmount nvarchar(max)                  
declare @items_LineAmountInclusiveVAT nvarchar(max)                  
declare @items_CurrencyCode nvarchar(max)                  
declare @items_TaxSchemeId nvarchar(max)                  
declare @items_Notes nvarchar(max)                  
declare @items_ExcemptionReasonCode nvarchar(max)                  
declare @items_ExcemptionReasonText nvarchar(max)                  
              
declare @InvoiceSummary_Id as nvarchar(max)                  
declare @InvoiceSummary_TenantId as nvarchar(max)                  
declare @InvoiceSummary_UniqueIdentifier as nvarchar(max)                  
declare @InvoiceSummary_IRNNo as nvarchar(max)                  
declare @InvoiceSummary_NetInvoiceAmount as nvarchar(max)                
declare @InvoiceSummary_NetInvoiceAmountCurrency as nvarchar(max)                  
declare @InvoiceSummary_SumOfInvoiceLineNetAmount as nvarchar(max)                  
declare @InvoiceSummary_SumOfInvoiceLineNetAmountCurrency as nvarchar(max)                  
declare @InvoiceSummary_TotalAmountWithoutVAT as nvarchar(max)                  
declare @InvoiceSummary_TotalAmountWithoutVATCurrency as nvarchar(max)                  
declare @InvoiceSummary_TotalVATAmount as nvarchar(max)                  
declare @InvoiceSummary_CurrencyCode as nvarchar(max)                  
declare @InvoiceSummary_TotalAmountWithVAT as nvarchar(max)                  
declare @InvoiceSummary_PaidAmount as nvarchar(max)                  
declare @InvoiceSummary_PaidAmountCurrency as nvarchar(max)                  
declare @InvoiceSummary_PayableAmount as nvarchar(max)                  
declare @InvoiceSummary_PayableAmountCurrency as nvarchar(max)                  
declare @InvoiceSummary_AdvanceAmountwithoutVat as nvarchar(max)                  
declare @InvoiceSummary_AdvanceVat as nvarchar(max)                  
                  
declare @invoiceHeader_Id nvarchar(max)                  
declare @invoiceHeader_TenantId nvarchar(max)                  
declare @invoiceHeader_UniqueIdentifier nvarchar(max)                  
declare @invoiceHeader_IRNNo nvarchar(max)                  
declare @invoiceHeader_InvoiceNumber nvarchar(max)                  
declare @invoiceHeader_IssueDate nvarchar(max)                  
declare @invoiceHeader_DateOfSupply nvarchar(max)                  
declare @invoiceHeader_InvoiceCurrencyCode nvarchar(max)                  
declare @invoiceHeader_CurrencyCodeOriginatingCountry nvarchar(max)                  
declare @invoiceHeader_PurchaseOrderId nvarchar(max)                  
declare @invoiceHeader_BillingReferenceId nvarchar(max)                  
declare @invoiceHeader_ContractId nvarchar(max)                  
declare @invoiceHeader_LatestDeliveryDate nvarchar(max)                  
declare @invoiceHeader_Location nvarchar(max)                  
declare @invoiceHeader_CustomerId nvarchar(max)                  
declare @invoiceHeader_Status nvarchar(max)                  
declare @invoiceHeader_Additional_Info nvarchar(max)                  
declare @invoiceHeader_PaymentType nvarchar(max)         
declare @invoiceHeader_PdfUrl nvarchar(max)                  
declare @invoiceHeader_QrCodeUrl nvarchar(max)                  
declare @invoiceHeader_XMLUrl nvarchar(max)                  
declare @invoiceHeader_ArchivalUrl nvarchar(max)                  
declare @invoiceHeader_PreviousInvoiceHash nvarchar(max)                  
declare @invoiceHeader_PerviousXMLHash nvarchar(max)                  
declare @invoiceHeader_XMLHash nvarchar(max)                  
declare @invoiceHeader_PdfHash nvarchar(max)                  
declare @invoiceHeader_XMLbase64 nvarchar(max)                  
declare @invoiceHeader_PdfBase64 nvarchar(max)                  
declare @invoiceHeader_IsArchived nvarchar(max)                  
declare @invoiceHeader_TransTypeCode nvarchar(max)                  
declare @invoiceHeader_TransTypeDescription nvarchar(max)                  
declare @invoiceHeader_AdvanceReferenceNumber nvarchar(max)                  
declare @invoiceHeader_Invoicetransactioncode nvarchar(max)                  
declare @invoiceHeader_BusinessProcessType nvarchar(max)                  
declare @invoiceHeader_CreationTime nvarchar(max)                  
declare @invoiceHeader_CreatorUserId nvarchar(max)                  
declare @invoiceHeader_LastModificationTime nvarchar(max)                  
declare @invoiceHeader_LastModifierUserId nvarchar(max)                  
declare @invoiceHeader_IsDeleted nvarchar(max)                  
declare @invoiceHeader_DeleterUserId nvarchar(max)                  
declare @invoiceHeader_DeletionTime nvarchar(max)                  
declare @invoiceHeader_InvoiceNotes nvarchar(max)            
        
declare @invoiceParty_NaturalPerson nvarchar(max)  

declare @InvoiceSAP_TotalAmountWithVAT as nvarchar(max) 

select @InvoiceSAP_TotalAmountWithVAT=InvoiceSAP_TotalAmountWithVAT        
FROM [dbo].[FileUpload_TransactionHeader]        
cross apply openjson(additionaldata3)        
with        
(InvoiceSAP_TotalAmountWithVAT nvarchar(max) '$.InvoiceTotal')        
where TenantId = @tenantId and BatchId=@batchid
              
declare @invoice nvarchar(max) ='{                
  "invoiceNumber": "",                
  "issueDate": "2023-05-17T05:00:21.000+00:00",                
  "dateOfSupply": "2023-05-17T05:00:21.327Z",                
  "invoiceCurrencyCode": "SARR",                
  "customerId": "567",                
  "status": "Paid",                
  "paymentType": "Cash",                
  "billingReferenceId":"",                
  "location":"asd",                
  "additional_Info":"asd",                
  "invoiceNotes":"asd",                
  "uuid":"asd",    
  "invoiceVatCode":"",    
  "supplier.registrationName": "qwdsqw",                
  "supplier.vatid": "3344333333333333333",                
  "supplier.crNumber": "234234",                
  "supplier.address.street": "qwdqwd",                
  "supplier.address.additionalStreet":"qwdqwd",                
  "supplier.address.buildingNo": "qascasc",                
  "supplier.address.additionalNo": "qwdqwd",                
  "supplier.address.city": "qqfwdqwewqwe",                
  "supplier.address.postalCode": "12311",                
  "supplier.address.state": "asd",                
  "supplier.address.neighbourhood": "asc",                
  "supplier.address.countryCode": "SAR",                
  "supplier.address.type": "qwdq",                
  "supplier.contactPerson.name": "asd",                
  "supplier.contactPerson.contactNumber": "2131",                
  "supplier.contactPerson.email": "asd@sdf.cv",            
  "buyer.registrationName": "qwer",                
  "buyer.vatid": "3333333333333333",                
  "buyer.groupVatid":"",                
  "buyer.crNumber": "123",         
  "buyer.naturalperson": "123",        
  "buyer.address.street": "qweas",                
  "buyer.address.additionalStreet": "asd",                
  "buyer.address.buildingNo": "12",                
  "buyer.address.additionalNo": "asas",                
  "buyer.address.city": "asfqw",                
  "buyer.address.postalCode": "12344",                
  "buyer.address.state": "asd",                
  "buyer.address.neighbourhood": "xcvx",                
  "buyer.address.countryCode": "xcva",     
  "buyer.address.shiptoCountryCode": "xcva",    
  "buyer.address.type": "asd",                
  "buyer.contactPerson.name": "sweras",                
  "buyer.contactPerson.contactNumber": "1231231",                
  "buyer.contactPerson.email": "ascasd@asd.sdf", 
  "buyer.contactPerson.isEmailenable": "ascasd@asd.sdf",
  "invoiceSummary.netInvoiceAmount": "",                
  "invoiceSummary.netInvoiceAmountCurrency": "SAR",                
  "invoiceSummary.sumOfInvoiceLineNetAmount": "",                
  "invoiceSummary.totalAmountWithoutVAT": "",                
  "invoiceSummary.totalAmountWithoutVATCurrency": "SAR",                
  "invoiceSummary.totalVATAmount":"",                
  "invoiceSummary.currencyCode": "",                
  "invoiceSummary.totalAmountWithVAT": "",                
  "invoiceSummary.paidAmountCurrency": "SAR",                
  "invoiceSummary.payableAmountCurrency": "SAR",                
  "invoiceSummary.sumOfInvoiceLineNetAmountCurrency":"SAR"            
  }'                    
                  
declare @items nvarchar(max) ='{                  
      "Identifier": "@itemsIdentifier",                  
      "name": "@itemsname",                  
   "description": "@itemsdescription",                  
      "quantity": "@itemsquantity",                  
      "unitPrice": "@itemsunitPrice",                  
      "costPrice": "@itemscostPrice",                  
      "discountPercentage": "@itemsdiscountPercentage",                  
      "discountAmount": "@itemsdiscountAmount",                  
      "grossPrice": "@itemsgrossPrice",                  
      "netPrice": "@itemsnetPrice",                  
      "vatRate": "@itemsvatRate",           
      "vatCode": "@itemsvatCode",                  
      "vatAmount": "@itemsvatAmount",                  
      "lineAmountInclusiveVAT": "@itemslineAmountInclusiveVAT",                  
      "currencyCode":"@itemscurrencyCode"  ,                
   "uuid":"",                
      "additionalData1":"",                
      "additionalData2":"",                
      "sellerIdentifier":"",                
 "buyerIdentifier":"",                
 "standardIdentifier":"",                
 "taxSchemeId":"",                
 "excemptionReasonCode":"",                
 "excemptionReasonText":"",                
 "language":"",                
 "notes":"",                
 "uom":""                
  }'                  
                  
SELECT @Supplier_Id=[Id]                  
      ,@Supplier_TenantId=[TenantId]                  
      ,@Supplier_UniqueIdentifier=[UniqueIdentifier]                  
      ,@Supplier_IRNNo=[IRNNo]                  
      ,@Supplier_RegistrationName=[RegistrationName]                  
      ,@Supplier_VATID=[VATID]                  
      ,@Supplier_GroupVATID=[GroupVATID]                  
      ,@Supplier_CRNumber=[CRNumber]                  
      ,@Supplier_OtherID=[OtherID]                  
      ,@Supplier_CustomerId=[CustomerId]                  
      ,@Supplier_Type=[Type]                  
FROM [dbo].[FileUpload_TransactionParty] where [UniqueIdentifier] = @uuid and [Type]='Supplier'          
        
select @invoiceParty_NaturalPerson=naturalperson        
FROM [dbo].[FileUpload_TransactionParty]        
cross apply openjson(additionaldata1)        
with        
(naturalperson nvarchar(max) '$.PayerNaturalPerson')        
where [UniqueIdentifier] = @uuid and [Type]='Delivery'        
                     
SELECT                   
    @Supplier_Street=[Street],                  
      @Supplier_AdditionalStreet=[AdditionalStreet],                  
       @Supplier_BuildingNo=[BuildingNo],                  
       @Supplier_AdditionalNo=[AdditionalNo],                  
       @Supplier_City=[City],                  
       @Supplier_PostalCode=[PostalCode],                  
       @Supplier_State=[State],                  
       @Supplier_Neighbourhood=[Neighbourhood],                  
       @Supplier_CountryCode=[CountryCode],                  
@Supplier_Type=[Type]                  
  FROM [dbo].[FileUpload_TransactionAddress] where [Type]='Supplier' and  [UniqueIdentifier] = @uuid                  
                  
  SELECT                   
    @Supplier_ContactNumber=[ContactNumber],                  
      @Supplier_Email=[Email]                  
  FROM [dbo].[FileUpload_TransactionContactPerson] where [Type]='Supplier'and  [UniqueIdentifier] = @uuid                  
                    
SELECT  @buyer_Id=[Id]                  
      ,@buyer_TenantId=[TenantId]                  
      ,@buyer_UniqueIdentifier=[UniqueIdentifier]                  
      ,@buyer_IRNNo=[IRNNo]                  
      ,@buyer_RegistrationName=[RegistrationName]                  
   ,@buyer_VATID=[VATID]                  
      ,@buyer_GroupVATID=[GroupVATID]                  
      ,@buyer_CRNumber=[CRNumber]                  
      ,@buyer_OtherID=[OtherID]
	  ,@buyer_OtherDocumentTypeId=[OtherDocumentTypeId]
      ,@buyer_CustomerId=[CustomerId]                  
      ,@buyer_Type=[Type]                  
   FROM [dbo].[FileUpload_TransactionParty] where [type]='Buyer' and [UniqueIdentifier] = @uuid                  
                  
SELECT                   
    @buyer_Street=[Street],                  
      @buyer_AdditionalStreet=[AdditionalStreet],                  
       @buyer_BuildingNo=[BuildingNo],                  
       @buyer_AdditionalNo=[AdditionalNo],                  
       @buyer_City=[City],                  
       @buyer_PostalCode=[PostalCode],         
       @buyer_State=[State],                  
       @buyer_Neighbourhood=[Neighbourhood],                  
       @buyer_CountryCode=[CountryCode],                  
       @buyer_Type=[Type]                  
  FROM [dbo].[FileUpload_TransactionAddress] where [Type]='Buyer' and [UniqueIdentifier] = @uuid                  
                  
  SELECT                   
    @buyer_ContactNumber=[ContactNumber],                  
      @buyer_Email=[Email]                  
  FROM [dbo].[FileUpload_TransactionContactPerson] where [Type]='Buyer' and [UniqueIdentifier] = @uuid     
      
    SELECT                   
    @buyer_ShiptoCountryCode=shiptocountrycode               
  FROM [dbo].[FileUpload_TransactionParty]     
  cross apply openjson(additionaldata1)    
  with    
  (shiptocountrycode nvarchar(max) '$.address.countryCode')      
  where [Type]='Buyer' and [UniqueIdentifier] = @uuid    
                      
 declare @itemId int,                 
@Id int,                  
@Identifier nvarchar(max),                
@Name nvarchar(max),                  
@Description nvarchar(max),                  
@Quantity nvarchar(max),                  
@UnitPrice  nvarchar(max),                  
@CostPrice  nvarchar(max),                  
@DiscountPercentage nvarchar(max),                  
@discountAmount nvarchar(max),                  
@grossPrice nvarchar(max),                  
@netPrice nvarchar(max),                  
@vatRate nvarchar(max),                  
@vatCode nvarchar(max),                  
@vatAmount nvarchar(max),                  
@lineAmountInclusiveVAT nvarchar(max),                  
@currencyCode nvarchar(max),              
@additionaldata1 nvarchar(max),              
@additionaldata2 nvarchar(max),              
@language nvarchar(max),              
@buyeridentifier nvarchar(max),              
@exemptionreasoncode nvarchar(max),              
@exemptionreasontext nvarchar(max),              
@notes nvarchar(max),              
@selleridentifier nvarchar(max),              
@standardidentifier nvarchar(max),              
@taxschemeid nvarchar(max),              
@uom nvarchar(max), 
@IsOtherCharges nvarchar(max),
@itemsTable CURSOR;                  
set @itemsTable=                   
CURSOR FOR                  
 SELECT  [Id] as [Id]  FROM [dbo].[FileUpload_TransactionItem] where [UniqueIdentifier] = @uuid and [isOtherCharges] =0 ;                
                  
 SELECT  [Id] as [Id]                  
      , [TenantId] as [TenantId]                  
      , [UniqueIdentifier] as [UniqueIdentifier]            
      , [IRNNo] as [IRNNo]                  
      , [Identifier] as [Identifier]                  
      , [Name] as [Name]                  
      , [Description] as [Description]                  
      , [BuyerIdentifier] as [BuyerIdentifier]                  
      , [SellerIdentifier] as [SellerIdentifier]                  
      , [StandardIdentifier] as [StandardIdentifier]                  
      , [Quantity] as [Quantity]                  
      , [UOM] as [UOM]                  
      , [UnitPrice] as [UnitPrice]                  
      , [CostPrice] as [CostPrice]                  
, [DiscountPercentage] as [DiscountPercentage]                  
      , [DiscountAmount] as [DiscountAmount]                  
      , [GrossPrice] as [GrossPrice]                  
      , [NetPrice] as [NetPrice]                  
      , [VATRate] as [VATRate]     
      , [VATCode] as [VATCode]                  
      , [VATAmount] as [VATAmount]                  
      , [LineAmountInclusiveVAT] as [LineAmountInclusiveVAT]                  
      , [CurrencyCode] as [CurrencyCode]                  
      , [TaxSchemeId] as [TaxSchemeId]                  
      , [Notes] as [Notes]                  
      , [ExcemptionReasonCode] as [ExcemptionReasonCode]                  
      , [ExcemptionReasonText] as [ExcemptionReasonText]              
   , [AdditionalData1] as [AdditionalData1]              
   , [AdditionalData2] as [AdditionalData2]              
   , [Language] as [Language]              
   , [isOtherCharges] as [isOtherCharges]   
  into #T01 FROM [dbo].[FileUpload_TransactionItem] where [UniqueIdentifier] = @uuid  and [isOtherCharges] =0     
  
  select * from #T01
            
              
  declare @counter int=1                
                  
OPEN @itemsTable                  
FETCH NEXT                   
FROM @itemsTable INTO @itemId;                  
set @itemRows= ''                  
WHILE @@FETCH_STATUS = 0                 
                
begin                  
 select                   
 @Id=Id,                  
 @Identifier=Identifier,                  
 @Name=[Name],                  
 @Description=[Description],                  
 @Quantity=Quantity,                  
 @UnitPrice =UnitPrice,                  
 @CostPrice =CostPrice,                  
 @DiscountPercentage=DiscountPercentage,                  
 @discountAmount=discountAmount,                  
 @grossPrice=grossPrice,                  
 @netPrice=netPrice,                  
 @vatRate=vatRate,                  
 @vatCode=vatCode,                  
 @vatAmount=vatAmount,                  
 @lineAmountInclusiveVAT=lineAmountInclusiveVAT,                  
 @currencyCode=currencyCode,              
 @additionaldata1=additionaldata1,              
 @additionaldata2=additionaldata2,              
 @language=[Language],              
 @uom=UOM,              
 @buyeridentifier=BuyerIdentifier,              
 @exemptionreasoncode=ExcemptionReasonCode,              
 @exemptionreasontext=ExcemptionReasonText,              
 @notes=Notes,              
 @selleridentifier=SellerIdentifier,              
 @standardidentifier=StandardIdentifier,              
 @taxschemeid=TaxSchemeId,
 @IsOtherCharges=isOtherCharges
 from #T01                  
 where Id = @itemId;                  
                  
 set @itemRows = @items               
               
              
 SET @itemRows='{"Identifier":"'+isnull(@Identifier,'')+'",              
    "name":"'+isnull(@Name,'')+'",              
    "description":"'+isnull(@Description,'')+'",              
    "quantity":"'+isnull(@Quantity,'')+'",              
    "unitPrice":"'+isnull(@UnitPrice,'')+'",              
    "costPrice":"'+isnull(@CostPrice,'')+'",              
    "discountPercentage":"'+isnull(@DiscountPercentage,'')+'",              
    "discountAmount":"'+isnull(@DiscountAmount,'')+'",              
    "grossPrice":"'+isnull(@GrossPrice,'')+'",              
    "netPrice":"'+isnull(@NetPrice,'')+'",              
    "vatRate":"'+isnull(@VATRate,'')+'",              
    "vatCode":"'+isnull(@VATCode,'')+'",              
    "vatAmount":"'+isnull(@VATAmount,'')+'",              
    "lineAmountInclusiveVAT":"'+isnull(@LineAmountInclusiveVAT,'')+'",              
    "currencyCode":"'+isnull(@CurrencyCode,'')+'",              
    "additionaldata1":"'+isnull(@additionaldata1,'')+'",              
    "additionaldata2":"'+isnull(@additionaldata2,'')+'",              
    "language":"'+isnull(@language,'')+'",              
    "uom":"'+isnull(@uom,'')+'",              
    "buyeridentifier":"'+isnull(@buyeridentifier,'')+'",              
    "ExcemptionReasonCode":"'+isnull(@exemptionreasoncode,'')+'",              
    "ExcemptionReasonText":"'+isnull(@exemptionreasontext,'')+'",              
    "Notes":"'+isnull(@notes,'')+'",              
    "SellerIdentifier":"'+isnull(@selleridentifier,'')+'",              
    "StandardIdentifier":"'+isnull(@standardidentifier,'')+'",              
    "TaxSchemeId":"'+isnull(@taxschemeid,'')+'",  
	"IsOtherCharges":"'+isnull(@IsOtherCharges,'')+'",
    "uuid":"'+isnull(cast(@uuid as nvarchar(500)),'')+'"}'   
	            
 exec sp_executesql @sqlStatement ,@Params = N' @RuleGroupId int,@tenantId int,@json nvarchar(max),@error nvarchar(max) OUTPUT ', @error = @err OUTPUT, @RuleGroupId=14,@tenantId=@tenantId,@json = @itemRows;                
                
 set @error = ISNULL(@error,'')+ISNULL(@err,'')                
 set @err = ''                
                
 set @counter=@counter+1                
                
 FETCH NEXT                   
FROM @itemsTable INTO @itemId;                  
end                  
                     
SELECT  @invoiceSummary_Id= [Id]                  
      ,@invoiceSummary_TenantId= [TenantId]                  
      ,@invoiceSummary_UniqueIdentifier= [UniqueIdentifier]                  
      ,@invoiceSummary_IRNNo= [IRNNo]                  
      ,@invoiceSummary_NetInvoiceAmount= [NetInvoiceAmount]                  
      ,@invoiceSummary_NetInvoiceAmountCurrency= [NetInvoiceAmountCurrency]                  
      ,@invoiceSummary_SumOfInvoiceLineNetAmount= [SumOfInvoiceLineNetAmount]                  
      ,@invoiceSummary_SumOfInvoiceLineNetAmountCurrency= [SumOfInvoiceLineNetAmountCurrency]                  
      ,@invoiceSummary_TotalAmountWithoutVAT= [TotalAmountWithoutVAT]                  
      ,@invoiceSummary_TotalAmountWithoutVATCurrency= [TotalAmountWithoutVATCurrency]                  
      ,@invoiceSummary_TotalVATAmount= [TotalVATAmount]                  
      ,@invoiceSummary_CurrencyCode= [CurrencyCode]                  
      ,@invoiceSummary_TotalAmountWithVAT= [TotalAmountWithVAT]                  
      ,@invoiceSummary_PaidAmount= [PaidAmount]                  
      ,@invoiceSummary_PaidAmountCurrency= [PaidAmountCurrency]                  
      ,@invoiceSummary_PayableAmount= [PayableAmount]                  
      ,@invoiceSummary_PayableAmountCurrency= [PayableAmountCurrency]                  
      ,@invoiceSummary_AdvanceAmountwithoutVat= [AdvanceAmountwithoutVat]                  
      ,@invoiceSummary_AdvanceVat= [AdvanceVat]                  
  FROM [dbo].[FileUpload_TransactionSummary] where [UniqueIdentifier] = @uuid                  
              
select @invoiceHeader_Id=[Id],                  
@invoiceHeader_TenantId=[TenantId],                  
@invoiceHeader_UniqueIdentifier=[UniqueIdentifier],                  
@invoiceHeader_IRNNo=[IRNNo],                  
@invoiceHeader_InvoiceNumber=[InvoiceNumber],                  
@invoiceHeader_IssueDate=[IssueDate],                  
@invoiceHeader_DateOfSupply=[DateOfSupply],                  
@invoiceHeader_InvoiceCurrencyCode=[InvoiceCurrencyCode],                  
@invoiceHeader_CurrencyCodeOriginatingCountry=[CurrencyCodeOriginatingCountry],                  
@invoiceHeader_PurchaseOrderId=[PurchaseOrderId],                  
@invoiceHeader_BillingReferenceId=[BillingReferenceId],                  
@invoiceHeader_ContractId=[ContractId],                  
@invoiceHeader_LatestDeliveryDate=[LatestDeliveryDate],                  
@invoiceHeader_Location=[Location],                  
@invoiceHeader_CustomerId=[CustomerId],                  
@invoiceHeader_Status=[Status],                  
@invoiceHeader_Additional_Info=[Additional_Info],                  
@invoiceHeader_PaymentType=[PaymentType],                  
@invoiceHeader_PdfUrl=[PdfUrl],                  
@invoiceHeader_QrCodeUrl=[QrCodeUrl],                  
@invoiceHeader_XMLUrl=[XMLUrl],                  
@invoiceHeader_ArchivalUrl=[ArchivalUrl],                  
@invoiceHeader_PreviousInvoiceHash=[PreviousInvoiceHash],                  
@invoiceHeader_PerviousXMLHash=[PerviousXMLHash],                  
@invoiceHeader_XMLHash=[XMLHash],                  
@invoiceHeader_PdfHash=[PdfHash],                  
@invoiceHeader_XMLbase64=[XMLbase64],                  
@invoiceHeader_PdfBase64=[PdfBase64],                  
@invoiceHeader_IsArchived=[IsArchived],                  
@invoiceHeader_TransTypeCode=[TransTypeCode],                  
@invoiceHeader_TransTypeDescription=[TransTypeDescription],                  
@invoiceHeader_AdvanceReferenceNumber=[AdvanceReferenceNumber],                  
@invoiceHeader_Invoicetransactioncode=[Invoicetransactioncode],                  
@invoiceHeader_BusinessProcessType=[BusinessProcessType],                  
@invoiceHeader_CreationTime=[CreationTime],                  
@invoiceHeader_InvoiceNotes=[InvoiceNotes]                   
                  
from [dbo].[FileUpload_TransactionHeader] where [UniqueIdentifier] = @uuid             
            
              
set @invoice = '{"invoiceNumber":"'+isnull(@invoiceHeader_InvoiceNumber,'')+'",              
    "issueDate":"'+isnull(@invoiceHeader_IssueDate,'')+'",              
    "dateOfSupply":"'+isnull(@invoiceHeader_DateOfSupply,'')+'",              
    "invoiceCurrencyCode":"'+isnull(@invoiceHeader_InvoiceCurrencyCode,'')+'",     
	"invoiceVatCode":"'+(select top 1 isnull(VATCode,'' ) from #T01)+'",    
    "customerId":"'+isnull(@invoiceHeader_CustomerId,'')+'",              
    "status":"'+isnull(@invoiceHeader_Status,'')+'",              
    "paymentType":"'+isnull(@invoiceHeader_PaymentType,'')+'",              
    "billingReferenceId":"'+isnull(@invoiceHeader_BillingReferenceId,'')+'",              
    "location":"'+isnull(@invoiceHeader_Location,'')+'",              
    "additional_Info":"'+isnull(@invoiceHeader_Additional_Info,'')+'",              
    "invoiceNotes":"'+isnull(@invoiceHeader_InvoiceNotes,'')+'",              
    "uuid":"'+isnull(@invoiceHeader_UniqueIdentifier,'')+'",              
    "supplier.registrationName": "'+isnull(@Supplier_RegistrationName,'')+'",                
    "supplier.vatid": "'+isnull(@Supplier_VATID,'')+'",                
    "supplier.crNumber": "'+isnull(@Supplier_CRNumber,'')+'",                
    "supplier.address.street": "'+isnull(@Supplier_Street,'')+'",                
    "supplier.address.additionalStreet":"'+isnull(@Supplier_AdditionalStreet,'')+'",                
    "supplier.address.buildingNo": "'+isnull(@Supplier_BuildingNo,'')+'",                
    "supplier.address.additionalNo": "'+isnull(@Supplier_AdditionalNo,'')+'",                
    "supplier.address.city": "'+isnull(@Supplier_City,'')+'",                
    "supplier.address.postalCode": "'+isnull(@Supplier_PostalCode,'')+'",                
    "supplier.address.state": "'+isnull(@Supplier_State,'')+'",                
    "supplier.address.neighbourhood": "'+isnull(@Supplier_Neighbourhood,'')+'",                
    "supplier.address.countryCode": "'+isnull(@Supplier_CountryCode,'')+'",                
    "supplier.address.type": "'+isnull(@Supplier_Type,'')+'",                
    "supplier.contactPerson.name": "'+isnull(@Supplier_RegistrationName,'')+'",                
    "supplier.contactPerson.contactNumber": "'+isnull(@Supplier_ContactNumber,'')+'",                
    "supplier.contactPerson.email": "'+isnull(@Supplier_Email,'')+'",              
    "buyer.registrationName": "'+isnull(@buyer_RegistrationName,'')+'",                
    "buyer.vatid": "'+isnull(@buyer_VATID,'')+'",                
    "buyer.groupVatid":"'+isnull(@buyer_GroupVATID,'')+'",                
    "buyer.crNumber": "'+isnull(@buyer_CRNumber,'')+'",        
 "buyer.naturalperson": "'+isnull(@invoiceParty_NaturalPerson,'')+'", 
 "buyer.otherDocumenttypeid": "'+isnull(@buyer_OtherDocumentTypeId,'')+'",
    "buyer.address.street": "'+isnull(@buyer_Street,'')+'",                
    "buyer.address.additionalStreet": "'+isnull(@buyer_AdditionalStreet,'')+'",                
    "buyer.address.buildingNo": "'+isnull(@buyer_BuildingNo,'')+'",                
    "buyer.address.additionalNo": "'+isnull(@buyer_AdditionalNo,'')+'",                
    "buyer.address.city": "'+isnull(@buyer_City,'')+'",                
    "buyer.address.postalCode": "'+isnull(@buyer_PostalCode,'')+'",                
    "buyer.address.state": "'+isnull(@buyer_State,'')+'",                
    "buyer.address.neighbourhood": "'+isnull(@buyer_Neighbourhood,'')+'",                
    "buyer.address.countryCode": "'+isnull(@buyer_CountryCode,'')+'",       
 "buyer.address.shiptocountryCode": "'+isnull( @buyer_ShiptoCountryCode,'')+'",    
    "buyer.address.type": "'+isnull(@buyer_Type,'')+'",                
    "buyer.contactPerson.name": "'+isnull(@buyer_ContactNumber,'')+'",               
    "buyer.contactPerson.contactNumber": "'+isnull(@buyer_ContactNumber,'')+'",                
    "buyer.contactPerson.email": "'+isnull(@buyer_Email,'')+'", 
	"buyer.contactPerson.isEmailenable": "'+isnull(@isEmailenable,'')+'",
    "invoiceSummary.netInvoiceAmount":"'+isnull(@InvoiceSummary_NetInvoiceAmount,'')+'",                
    "invoiceSummary.netInvoiceAmountCurrency": "'+isnull(@InvoiceSummary_NetInvoiceAmountCurrency,'')+'",                
    "invoiceSummary.sumOfInvoiceLineNetAmount":"'+isnull(@InvoiceSummary_SumOfInvoiceLineNetAmount,'')+'",                
    "invoiceSummary.totalAmountWithoutVAT":"'+isnull(@InvoiceSummary_TotalAmountWithoutVAT,'')+'" ,                
    "invoiceSummary.totalAmountWithoutVATCurrency": "'+isnull(@InvoiceSummary_TotalAmountWithoutVATCurrency,'')+'",                
    "invoiceSummary.totalVATAmount":"'+isnull(@InvoiceSummary_TotalVATAmount,'')+'" ,                
    "invoiceSummary.currencyCode": "'+isnull(@InvoiceSummary_CurrencyCode,'')+'",                
    "invoiceSummary.totalAmountWithVAT":"'+isnull(@InvoiceSummary_TotalAmountWithVAT,'')+'",                
    "invoiceSummary.paidAmountCurrency": "'+isnull(@InvoiceSummary_PaidAmountCurrency,'')+'",                
    "invoiceSummary.payableAmountCurrency": "'+isnull(@InvoiceSummary_PayableAmountCurrency,'')+'",                
    "invoiceSummary.sumOfInvoiceLineNetAmountCurrency":"'+isnull(@InvoiceSummary_SumOfInvoiceLineNetAmountCurrency,'')+'",  
	"InvoiceSAP_TotalAmountWithVAT":"'+isnull(@InvoiceSAP_TotalAmountWithVAT,'')+'"
    }'       
       
 print @invoice      
                
 exec sp_executesql @sqlStatement ,@Params = N'@RuleGroupId int,@tenantId int,@json nvarchar(max),@error nvarchar(max) OUTPUT', @error = @err OUTPUT, @RuleGroupId=11,@tenantId=@tenantId,@json = @invoice;                
 set @error = ISNULL(@error,'')+ISNULL(@err,'')         
 set @err = ''                
                
 exec sp_executesql @sqlStatement ,@Params = N'@RuleGroupId int,@tenantId int,@json nvarchar(max),@error nvarchar(max) OUTPUT', @error = @err OUTPUT, @RuleGroupId=12,@tenantId=@tenantId,@json = @invoice;                
 set @error = ISNULL(@error,'')+ISNULL(@err,'')                
 set @err = ''                
                
 exec sp_executesql @sqlStatement ,@Params = N'@RuleGroupId int,@tenantId int,@json nvarchar(max),@error nvarchar(max) OUTPUT', @error = @err OUTPUT, @RuleGroupId=13,@tenantId=@tenantId,@json = @invoice;                
 set @error = ISNULL(@error,'')+ISNULL(@err,'')                
 set @err = ''   
 
  exec sp_executesql @sqlStatement ,@Params = N'@RuleGroupId int,@tenantId int,@json nvarchar(max),@error nvarchar(max) OUTPUT', @error = @err OUTPUT, @RuleGroupId=15,@tenantId=@tenantId,@json = @invoice;                
 set @error = ISNULL(@error,'')+ISNULL(@err,'')                
 set @err = '' 



set @error = [dbo].ReplaceHtmlString(@error,'@sapamount',format(cast(@InvoiceSAP_TotalAmountWithVAT as decimal(18,2)),'#,0.00'))
set @error = [dbo].ReplaceHtmlString(@error,'@invoiceamount',format(cast(@InvoiceSummary_TotalAmountWithVAT as decimal(18,2)),'#,0.00'))

 --print @error

 --if(TRIM(@error)='')                
 --begin              
 if(@invoiceHeader_TransTypeDescription='388')            
 begin            
 --exec FileUpload_InsertToSalesTables @uuid,@tenantId           
 exec FileUpload_InsertToDraftTables @uuid,@tenantId           
 end            
 else if(@invoiceHeader_TransTypeDescription='381')            
 begin            
 --exec FileUpload_InsertToCreditTables @uuid,@tenantId          
 exec FileUpload_InsertToDraftCreditTables @uuid,@tenantId          
 end            
  else if(@invoiceHeader_TransTypeDescription='383')            
 begin            
 --exec FileUpload_InsertToDebitTables @uuid,@tenantId         
 exec FileUpload_InsertToDraftDebitTables @uuid,@tenantId          
 end            
 --end                
 --else                
 --begin                
 update Draft set Error = @error where [UniqueIdentifier]=@uuid                
 --end                
                
drop table #T01                  
                  
FETCH NEXT                   
 FROM @record INTO @uuid;                  
                  
end                  
                  
deallocate @record               
                   
end
GO
