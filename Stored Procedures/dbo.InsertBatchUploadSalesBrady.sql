SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE    PROCEDURE [dbo].[InsertBatchUploadSalesBrady] (          
  @json nvarchar(max),          
  @fileName nvarchar(max),           
  @tenantId int = null,           
  @fromDate datetime = null,           
  @toDate datetime = null,     
  @batchid  int = null      
) AS BEGIN Declare @MaxBatchId int           
          
          
          
--Select           
--  @MaxBatchId = isnull(max(batchId),0)           
--  from           
--  BatchData;          
--Declare @batchId int = @MaxBatchId + 1;          
--      set @outBatchId = @batchId    
-- Insert into dbo.logs           
--values           
--  (          
--    'sales '+@json,           
--    @toDate,           
--    @batchId          
--  )          
            
--INSERT INTO [dbo].[BatchData] (          
--  [TenantId], [BatchId], [FileName],           
--  [TotalRecords], [Status], [Type],           
--  [CreationTime], [IsDeleted], fromDate, toDate          
--)           
--VALUES           
--  (          
--    @tenantId,           
--    @batchId,           
--    @fileName,           
--    0,           
--    'Unprocessed',           
--    'Sales',           
--    GETDATE(),           
--    0,          
-- @fromDate,          
-- @toDate          
--  )           
            
           
  Insert into dbo.logs           
values           
  (          
    @json,           
    getdate(),           
    @batchId          
  ) Declare @totalRecords int =(          
    select           
      count(*)           
    from           
      OPENJSON(@json)          
  );          
IF (          
  ISJSON(@json) = 1           
  and @totalRecords > 0          
) BEGIN PRINT 'Imported JSON is Valid';          
insert into ImportBatchData (          
  uniqueidentifier,           
  Processed,           
  WHTApplicable,           
  VATDeffered,           
  RCMApplicable,           
  Isapportionment,           
  TransType,           
  --IRNNo,           
  InvoiceNumber,           
  IssueDate,  
  SupplyDate,           
  OrignalSupplyDate,         
  SupplyEndDate,  
  --IssueTime,      
  PurchaseOrderId,           
  ContractId,           
  --BuyerMasterCode,           
  BuyerName,  
  PaymentMeans,           
  PaymentTerms,  
  InvoiceCurrencyCode,  
  --BuyerVatCode,           
  --BuyerContact,           
  --BuyerCountryCode,           
  InvoiceLineIdentifier,           
  --ItemMasterCode,           
  --ItemName,           
  UOM,           
  --GrossPrice,           
  --Discount,         
  Quantity,  
  LineAmountInclusiveVAT,  
  --LineNetAmount,           
  VatCategoryCode,           
  VatRate,  
  NetPrice,  
  VATLineAmount,  
  VatExemptionReasonCode,           
  VatExemptionReason,   
  --AdvanceRcptAmtAdjusted,           
  --VatOnAdvanceRcptAmtAdjusted,           
  --AdvanceRcptRefNo,  
  --OrgType,           
  InvoiceType,           
  BatchId,           
  CreationTime,           
  CreatorUserId,           
  IsDeleted,           
  TenantId,           
  [Filename] -- added this field by NJ on 18-jan-2023  - Ref Issue No.119              
  )           
select           
  isNull(xml_uuid,NEWID()),  
  0,  
  0,  
  0,  
  0,  
  0,  
  ISNULL(TransType, '') as TransType,           
  isnull(SAPInvoiceNumber,'') as InvoiceNumber,  
  dbo.ISNULLOREMPTYFORDATE(SAPInvoiceDate) as IssueDate,          
  dbo.ISNULLOREMPTYFORDATE(SAPInvoiceDueDate) as SupplyDate,  
  dbo.ISNULLOREMPTYFORDATE(SupplyDate) as OrignalSupplyDate,           
  dbo.ISNULLOREMPTYFORDATE(SupplyEndDate) as SupplyEndDate,   
  ISNULL(PurchaseOrderId, '') as PurchaseOrderId,           
  ISNULL(ContractId, '') as ContractId,  
  ISNULL(OrderPlacedBy, '') as BuyerName,  
  ISNULL(PaymentMeans, '') as PaymentMeans,           
  ISNULL(PaymentTerms, '') as PaymentTerms,  
  ISNULL(InvoiceCurrencyCode, '') as InvoiceCurrencyCode,  
  ISNULL(LineIdentifier, '') as InvoiceLineIdentifier,  
  ISNULL(ItemUOM, '') as UOM,  
  dbo.ISNULLOREMPTYFORDECIMAL(ItemQuantity) as Quantity,  
  dbo.ISNULLOREMPTYFORDECIMAL(LineAmountInclusiveVAT) as LineAmountInclusiveVAT,          
  ISNULL(ItemVATCode, '') as VatCategoryCode,           
  dbo.ISNULLOREMPTYFORDECIMAL(ItemVATRate) as VatRate,  
  dbo.ISNULLOREMPTYFORDECIMAL(ItemNetPrice) as NetPrice,  
  dbo.ISNULLOREMPTYFORDECIMAL(ItemVATAmount) as VATLineAmount,  
  ISNULL(VatExemptionReasonCode, '') as VatExemptionReasonCode,           
  ISNULL(VatExemptionReason, '') as VatExemptionReason,  
       
  --ISNULL(BuyerMasterCode, '') as BuyerMasterCode,  
  --ISNULL(BuyerVatCode, '') as BuyerVatCode,           
  --ISNULL(BuyerContact, '') as BuyerContact,           
  --ISNULL(BuyerCountryCode, '') as BuyerCountryCode,              
  --ISNULL(ItemMasterCode, '') as ItemMasterCode,           
  --ISNULL(ItemName, '') as ItemName,           
  --dbo.ISNULLOREMPTYFORDECIMAL(Discount) as Discount,           
  --dbo.ISNULLOREMPTYFORDECIMAL(LineNetAmount) as LineNetAmount,  
  --dbo.ISNULLOREMPTYFORDECIMAL(VATLineAmount) as VATLineAmount,           
  --dbo.ISNULLOREMPTYFORDECIMAL(AdvanceRcptAmtAdjusted) as AdvanceRcptAmtAdjusted,           
  --dbo.ISNULLOREMPTYFORDECIMAL(VatOnAdvanceRcptAmtAdjusted) as VatOnAdvanceRcptAmtAdjusted,           
  --ISNULL(AdvanceRcptRefNo, '') as AdvanceRcptRefNo,  
  --ISNULL(OrgType, '') as OrgType,           
  'Sales Invoice - Standard' as InvoiceType,           
  -- Passing 'Standard' if InvoiceType is blank - altered by NJV on 20-jan-2023              
  @batchId,           
  GETDATE(),           
  1,           
  0,           
  @tenantId ,          
  @fileName -- added this field by NJ on 18-jan-2023   Ref Issue No.119              
from           
  OPENJSON(@json) with (          
    xml_uuid uniqueidentifier '$."xml_uuid"',  
    --InvoiceType nvarchar(max) '$."Invoice Type"',           
    TransType nvarchar(max) '$."TransactionType"',  
 SAPInvoiceNumber nvarchar(max) '$."SAPInvoice Number"',  
 SAPInvoiceDate nvarchar(max) '$."SAPInvoiceDate"',  
 SAPInvoiceDueDate nvarchar(max) '$."SAPInvoiceDueDate"',  
 SupplyDate nvarchar(max) '$."Supply Date"',  
 SupplyEndDate nvarchar(max) '$."Supply End Date"',  
 PurchaseOrderId nvarchar(max) '$."Purchase Order ID"',           
    ContractId nvarchar(max) '$."Contract ID"',  
 OrderPlacedBy nvarchar(max) '$."OrderPlacedBy"',  
 PaymentMeans nvarchar(max) '$."Payment Means"',  
 PaymentTerms nvarchar(max) '$."Payment Terms"',  
    OriginalQuoteNumber nvarchar(max) '$."OriginalQuoteNumber"', --not mapped  
 DeliveryDocumentNo nvarchar(max) '$."DeliveryDocumentNo"', --not mapped  
    CarrierAndService nvarchar(max) '$."CarrierAndService"', --not mapped  
    TermsOfDelivery nvarchar(max) '$."TermsOfDelivery"', --not mapped  
    InvoiceCurrencyCode nvarchar(max) '$."InvoiceCurrencyCode"',  
    ExchangeRate nvarchar(max) '$."ExchangeRate"', --not mapped  
    WeAreYourVendor nvarchar(max) '$."WeAreYourVendor"', --not mapped  
    BillingReferenceID nvarchar(max) '$."BillingReferenceID"', --not mapped  
    CreditOrDebitReasons nvarchar(max) '$."CreditOrDebitReasons"', --not mapped  
    Notes nvarchar(max) '$."Notes"', --not mapped  
 BankName nvarchar(max) '$."BankName"', --not mapped  
    AccountName nvarchar(max) '$."AccountName"', --not mapped  
    SARAccount nvarchar(max) '$."SARAccount"', --not mapped  
    IBAN nvarchar(max) '$."IBAN"', --not mapped  
    SWIFT nvarchar(max) '$."SWIFT"', --not mapped  
    PayerMasterCode nvarchar(max) '$."PayerMasterCode"', --not mapped  
    PayerName nvarchar(max) '$."PayerName"', --not mapped  
    PayerVATNumber nvarchar(max) '$."PayerVATNumber"', --not mapped  
    PayerStreet nvarchar(max) '$."PayerStreet"', --not mapped  
    PayerAdditionalStreet nvarchar(max) '$."PayerAdditionalStreet"', --not mapped  
    PayerBuildingNumber nvarchar(max) '$."PayerBuildingNumber"', --not mapped  
    PayerAdditionalNumber nvarchar(max) '$."PayerAdditionalNumber"', --not mapped  
    PayerCity nvarchar(max) '$."PayerCity"', --not mapped  
    PayerPostalCode nvarchar(max) '$."PayerPostalCode"', --not mapped  
    PayerDistrictOrNeighbourhood nvarchar(max) '$."PayerDistrictOrNeighbourhood"', --not mapped  
    PayerProvinceOrState nvarchar(max) '$."PayerProvinceOrState"', --not mapped  
    PayerCountryCode nvarchar(max) '$."PayerCountryCode"', --not mapped  
 Attn nvarchar(max) '$."Attn"', --not mapped  
    PayerOtherID nvarchar(max) '$."PayerOtherID"', --not mapped  
    PayerContactNumber nvarchar(max) '$."PayerContactNumber"', --not mapped  
    ShipToMasterCode nvarchar(max) '$."ShipToMasterCode"', --not mapped  
    ShipToName nvarchar(max) '$."ShipToName"', --not mapped  
    ShipToStreet nvarchar(max) '$."ShipToStreet"', --not mapped  
    ShipToAdditionalStreet nvarchar(max) '$."ShipToAdditionalStreet"', --not mapped  
    ShipToBuildingNumber nvarchar(max) '$."ShipToBuildingNumber"', --not mapped  
    ShipToAdditionalNumber nvarchar(max) '$."ShipToAdditionalNumber"', --not mapped  
    ShipToCity nvarchar(max) '$."ShipToCity"', --not mapped  
    ShipToPostalCode nvarchar(max) '$."ShipToPostalCode"', --not mapped  
    ShipToDisctrictOrNeighbourhood nvarchar(max) '$."ShipToDisctrictOrNeighbourhood"', --not mapped  
    ShipToProvinceOrState nvarchar(max) '$."ShipToProvinceOrState"', --not mapped  
    ShipToCountryCode nvarchar(max) '$."ShipToCountryCode"', --not mapped  
    ShipToContactNumber nvarchar(max) '$."ShipToContactNumber"', --not mapped  
    ShipToAttn nvarchar(max) '$."ShipToAttn"', --not mapped  
    LineIdentifier nvarchar(max) '$."LineIdentifier"',  
    LineOriginIndicator nvarchar(max) '$."LineOriginIndicator"',  --not mapped  
    PartNumberDescription nvarchar(max) '$."PartNumberDescription"', --not mapped  
    UnitPrice nvarchar(max) '$."UnitPrice"', --not mapped  
    ListPrice nvarchar(max) '$."ListPrice"', --not mapped  
    ItemUOM nvarchar(max) '$."ItemUOM"',  
    ItemQuantity nvarchar(max) '$."ItemQuantity"',  
    ItemNetPrice nvarchar(max) '$."ItemNetPrice"',  
    CurrencyCode nvarchar(max) '$."CurrencyCode"', --not mapped  
    LineAmountExclusiveVAT nvarchar(max) '$."LineAmountExclusiveVAT"',  
    ItemVATCode nvarchar(max) '$."ItemVATCode"',  
    ItemVATRate nvarchar(max) '$."ItemVATRate"',  
    ItemVATAmount nvarchar(max) '$."ItemVATAmount"',  
    LineAmountInclusiveVAT nvarchar(max) '$."LineAmountInclusiveVAT"',  
    VATExemptionReasonCode nvarchar(max) '$."VATExemptionReasonCode"',  
    VATExemptionReason nvarchar(max) '$."VATExemptionReason"',  
    InvoiceNetAmount nvarchar(max) '$."InvoiceNetAmount"', --not mapped  
    Freight nvarchar(max) '$."Freight"', --not mapped  
    Customs nvarchar(max) '$."Customs"', --not mapped  
    HandlingCharges nvarchar(max) '$."Handling Charges"', --not mapped  
    OtherCharges nvarchar(max) '$."Other Charges"', --not mapped  
    InvoiceVAT nvarchar(max) '$."InvoiceVAT"',  
    InvoiceTotal nvarchar(max) '$."InvoiceTotal"',  
    Footer nvarchar(max) '$."Footer"', --not mapped  
    AdditionalDetails1 nvarchar(max) '$."AdditionalDetails1"', --not mapped  
    AdditionalDetails2 nvarchar(max) '$."AdditionalDetails2"', --not mapped  
    AdditionalDetails3 nvarchar(max) '$."AdditionalDetails3"', --not mapped  
    AdditionalDetails4 nvarchar(max) '$."AdditionalDetails4"'  --not mapped     
  );          
update           
  BatchData           
set           
  TotalRecords = @totalRecords,           
  SuccessRecords = @totalRecords,           
  FailedRecords = 0,           
  status = 'Processed',           
  batchId = @batchId           
where           
  FileName = @fileName           
  and Status = 'Unprocessed';          
END ELSE BEGIN PRINT 'Invalid JSON Imported' END     
END     
--begin exec SalesTransValidation @batchid end    
    
    
--if(@tenantId is not null)    
--begin    
--exec FileUploadSalesT1 @batchId,@tenantId,@json    
--end
GO
