SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE           PROCEDURE [dbo].[InsertBatchUploadSales] ( 
  @batchid int,
  @json nvarchar(max) ,            
  @fileName nvarchar(max)='',             
  @tenantId int = null,             
  @fromDate datetime = null,             
  @toDate datetime = null            
) AS BEGIN Declare @MaxBatchId int             
            
            
--Select             
--  @MaxBatchId = isnull(max(batchId),0)             
--  from             
--  BatchData;            
--Declare @batchId int = @MaxBatchId + 1;            
            
 Insert into dbo.logs             
values             
  (            
    'sales '+@json,             
    @toDate,             
    @batchId            
  )                       
              
             
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
  IRNNo,             
  InvoiceNumber,             
  IssueDate,             
  IssueTime,             
  InvoiceCurrencyCode,            
  PurchaseOrderId,             
  ContractId,             
  SupplyDate,             
  OrignalSupplyDate,           
  SupplyEndDate,             
  BuyerMasterCode,             
  BuyerName,             
  BuyerVatCode,             
  BuyerContact,             
  BuyerCountryCode,             
  InvoiceLineIdentifier,             
  ItemMasterCode,             
  ItemName,             
  UOM,             
  GrossPrice,             
  Discount,             
  NetPrice,             
  Quantity,             
  LineNetAmount,             
  VatCategoryCode,             
  VatRate,             
  VatExemptionReasonCode,             
  VatExemptionReason,             
  VATLineAmount,             
  LineAmountInclusiveVAT,             
  AdvanceRcptAmtAdjusted,             
  VatOnAdvanceRcptAmtAdjusted,             
  AdvanceRcptRefNo,             
  PaymentMeans,             
  PaymentTerms,             
  OrgType,             
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
  ISNULL(TransType, 'sales') as TransType,             
  IRNNo,             
  ISNULL(InvoiceNumber, '') as InvoiceNumber,             
  dbo.ISNULLOREMPTYFORDATE(IssueDate) as IssueDate,             
  ISNULL(IssueTime, '') as IssueTime,             
  ISNULL(InvoiceCurrencyCode, '') as InvoiceCurrencyCode,             
  ISNULL(PurchaseOrderId, '') as PurchaseOrderId,             
  ISNULL(ContractId, '') as ContractId,             
  dbo.ISNULLOREMPTYFORDATE(SupplyDate) as SupplyDate,             
  dbo.ISNULLOREMPTYFORDATE(SupplyDate) as OrignalSupplyDate,             
  dbo.ISNULLOREMPTYFORDATE(SupplyEndDate) as SupplyEndDate,             
  ISNULL(BuyerMasterCode, '') as BuyerMasterCode,             
  ISNULL(BuyerName, '') as BuyerName,             
  ISNULL(BuyerVatCode, '') as BuyerVatCode,             
  ISNULL(BuyerContact, '') as BuyerContact,             
  ISNULL(BuyerCountryCode, '') as BuyerCountryCode,       
  ISNULL(InvoiceLineIdentifier, '') as InvoiceLineIdentifier,             
  ISNULL(ItemMasterCode, '') as ItemMasterCode,             
  ISNULL(ItemName, '') as ItemName,             
  ISNULL(UOM, '') as UOM,             
  dbo.ISNULLOREMPTYFORDECIMAL(GrossPrice) as GrossPrice,         
  dbo.ISNULLOREMPTYFORDECIMAL(Discount) as Discount,             
  dbo.ISNULLOREMPTYFORDECIMAL(NetPrice) as NetPrice,             
  dbo.ISNULLOREMPTYFORDECIMAL(Quantity) as Quantity,             
  dbo.ISNULLOREMPTYFORDECIMAL(LineNetAmount) as LineNetAmount,             
  ISNULL(VatCategoryCode, '') as VatCategoryCode,             
  dbo.ISNULLOREMPTYFORDECIMAL(VatRate) as VatRate,             
  ISNULL(VatExemptionReasonCode, '') as VatExemptionReasonCode,             
  ISNULL(VatExemptionReason, '') as VatExemptionReason,             
  dbo.ISNULLOREMPTYFORDECIMAL(VATLineAmount) as VATLineAmount,             
  dbo.ISNULLOREMPTYFORDECIMAL(LineAmountInclusiveVAT) as VatExemptionReason,             
  dbo.ISNULLOREMPTYFORDECIMAL(AdvanceRcptAmtAdjusted) as AdvanceRcptAmtAdjusted,             
  dbo.ISNULLOREMPTYFORDECIMAL(VatOnAdvanceRcptAmtAdjusted) as VatOnAdvanceRcptAmtAdjusted,             
  ISNULL(AdvanceRcptRefNo, '') as AdvanceRcptRefNo,             
  ISNULL(PaymentMeans, '') as PaymentMeans,             
  ISNULL(PaymentTerms, '') as PaymentTerms,             
  ISNULL(OrgType, '') as OrgType,             
  'Sales Invoice - ' + ISNULL(InvoiceType, 'Standard') as InvoiceType,             
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
          
InvoiceType nvarchar(max) '$."InvoiceType"',       
TransType nvarchar(max) '$."TransType"',       
IRNNo nvarchar(max) '$."IRNNo"',       
InvoiceNumber nvarchar(max) '$."InvoiceNumber"',       
IssueDate nvarchar(max) '$."IssueDate"',       
IssueTime nvarchar(max) '$."IssueTime"',       
InvoiceCurrencyCode nvarchar(max) '$."InvoiceCurrencyCode"',       
PurchaseOrderId nvarchar(max) '$."PurchaseOrderId"',       
ContractId nvarchar(max) '$."ContractId"',       
SupplyDate nvarchar(max) '$."SupplyDate"',       
SupplyEndDate nvarchar(max) '$."SupplyEndDate"',       
BuyerMasterCode nvarchar(max) '$."BuyerMasterCode"',       
BuyerName nvarchar(max) '$."BuyerName"',       
BuyerVatCode nvarchar(max) '$."BuyerVatCode"',       
BuyerContact nvarchar(max) '$."BuyerContact"',       
BuyerCountryCode nvarchar(max) '$."BuyerCountryCode"',       
InvoiceLineIdentifier nvarchar(max) '$."InvoiceLineIdentifier"',       
ItemMasterCode nvarchar(max) '$."ItemMasterCode"',       
ItemName nvarchar(max) '$."ItemName"',       
UOM nvarchar(max) '$."UOM"',       
GrossPrice nvarchar(max) '$."GrossPrice"',       
Discount nvarchar(max) '$."Discount"',       
NetPrice nvarchar(max) '$."NetPrice"',       
Quantity nvarchar(max) '$."Quantity"',       
LineNetAmount nvarchar(max) '$."LineNetAmount"',       
VatCategoryCode nvarchar(max) '$."VatCategoryCode"',       
VatRate nvarchar(max) '$."VatRate"',       
VatExemptionReasonCode nvarchar(max) '$."VatExemptionReasonCode"',       
VatExemptionReason nvarchar(max) '$."VatExemptionReason"',       
VATLineAmount nvarchar(max) '$."VATLineAmount"',       
LineAmountInclusiveVAT nvarchar(max) '$."LineAmountInclusiveVAT"',       
AdvanceRcptAmtAdjusted nvarchar(max) '$."AdvanceRcptAmtAdjusted"',       
VatOnAdvanceRcptAmtAdjusted nvarchar(max) '$."VatOnAdvanceRcptAmtAdjusted"',       
AdvanceRcptRefNo nvarchar(max) '$."AdvanceRcptRefNo"',       
PaymentMeans nvarchar(max) '$."PaymentMeans"',       
PaymentTerms nvarchar(max) '$."PaymentTerms"',       
OrgType nvarchar(max) '$."OrgType"'      
  );         
    
  
update             
  BatchData             
set                         
  status = 'Processed',
  [Type] = 'Sales'
where   
  BatchId = @batchid and
  FileName = @fileName             
  and Status = 'Unprocessed';    
  exec InsertBatchUploadDefaultValues @batchId  
  
END ELSE BEGIN PRINT 'Invalid JSON Imported' END END 
--begin exec SalesTransValidation @batchid,1 end
GO
