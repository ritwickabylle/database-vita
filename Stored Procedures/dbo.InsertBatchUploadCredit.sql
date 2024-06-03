SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
CREATE     PROCEDURE [dbo].[InsertBatchUploadCredit] (  
@batchid int,
  @json nvarchar(max),           
  @fileName nvarchar(max),           
  @tenantId int = null,        
   @fromdate DateTime=null,          
 @todate datetime=null        
) AS BEGIN Declare @MaxBatchId int           
--Select           
--  @MaxBatchId = max(batchId)           
--from           
--  BatchData;          
--Declare @batchId int = @MaxBatchId + 1;          
--INSERT INTO [dbo].[BatchData] (          
--  [TenantId], [BatchId], [FileName],           
--  [TotalRecords], [Status], [Type],         
--[fromDate],        
--[toDate],          
--  [CreationTime], [IsDeleted]          
--)           
--VALUES           
--  (          
--    @tenantId,           
--    @batchId,           
--    @fileName,           
--    0,           
--    'Unprocessed',           
--    'Credit',         
-- @fromdate,          
-- @todate,        
--    GETDATE(),           
--    0          
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
insert into ImportBatchData(          
    UniqueIdentifier,           
 Processed, WHTApplicable,           
  VATDeffered, RCMApplicable, Isapportionment,           
  InvoiceType, IRNNo, InvoiceNumber,           
  IssueDate, IssueTime, InvoiceCurrencyCode,           
  BillingReferenceId, OrignalSupplyDate,           
  ReasonForCN, PurchaseOrderId, ContractId,           
  BuyerMasterCode, BuyerName, BuyerVatCode,           
  BuyerContact, BuyerCountryCode,           
  OrgType, InvoiceLineIdentifier,           
  ItemMasterCode, ItemName, UOM, GrossPrice,           
  Discount, NetPrice, Quantity, LineNetAmount,           
  VatCategoryCode, VatRate, VatExemptionReasonCode,           
  VatExemptionReason, VATLineAmount,           
  LineAmountInclusiveVAT, BatchId,           
  CreationTime, CreatorUserId, IsDeleted,           
  TenantId, TransType ,Filename         
)           
select           
  isNull(xml_uuid,NEWID()),           
  0,           
  0,           
  0,           
  0,           
  0,           
  'Credit Note - ' + ISNULL(InvoiceType, '') as InvoiceType,           
  IRNNo,           
  ISNULL(InvoiceNumber, '') as InvoiceNumber,           
  dbo.ISNULLOREMPTYFORDATE(IssueDate) as IssueDate,           
  ISNULL(IssueTime, '') as IssueTime,           
  ISNULL(InvoiceCurrencyCode, '') as InvoiceCurrencyCode,           
  ISNULL(BillingReferenceId, '') as BillingReferenceId,           
  dbo.ISNULLOREMPTYFORDATE(OrignalSupplyDate) as OrignalSupplyDate,           
  ISNULL(ReasonForCN, '') as ReasonForCN,           
  ISNULL(PurchaseOrderId, '') as PurchaseOrderId,           
  ISNULL(ContractId, '') as ContractId,           
  ISNULL(BuyerMasterCode, '') as BuyerMasterCode,           
  ISNULL(BuyerName, '') as BuyerName,           
  ISNULL(BuyerVatCode, '') as BuyerVatCode,           
  ISNULL(BuyerContact, '') as BuyerContact,           
  ISNULL(BuyerCountryCode, '') as BuyerCountryCode,           
  isnull(BuyerType, 'PRIVATE') as BuyerType,           
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
  dbo.ISNULLOREMPTYFORDECIMAL(LineAmountInclusiveVAT) as LineAmountInclusiveVAT,           
  @batchId,           
  GETDATE(),           
  1,           
  0,           
  @tenantId,           
  'Credit' as Transtype  ,        
  @fileName        
from           
  OPENJSON(@json) with (          
    xml_uuid uniqueidentifier '$."xml_uuid"',        
    InvoiceType nvarchar(max) '$."InvoiceType"',   
IRNNo nvarchar(max) '$."IRNNo"',   
InvoiceNumber nvarchar(max) '$."InvoiceNumber"',   
IssueDate nvarchar(max) '$."IssueDate"',   
IssueTime nvarchar(max) '$."IssueTime"',   
InvoiceCurrencyCode nvarchar(max) '$."InvoiceCurrencyCode"',   
BillingReferenceId nvarchar(max) '$."BillingReferenceId"',   
OrignalSupplyDate nvarchar(max) '$."OrignalSupplyDate"',   
ReasonForCN nvarchar(max) '$."ReasonForCN"',   
PurchaseOrderId nvarchar(max) '$."PurchaseOrderId"',   
ContractId nvarchar(max) '$."ContractId"',   
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
BuyerType nvarchar(max) '$."OrgType"'        
  );        
    
   exec InsertBatchUploadDefaultValues @batchId  
   
update             
  BatchData             
set                         
  status = 'Processed',
  [Type] = 'Sales'
where   
  BatchId = @batchid and
  FileName = @fileName             
  and Status = 'Unprocessed';   
  
  
  
END ELSE BEGIN PRINT 'Invalid JSON Imported' END END
--begin exec CreditNoteTransValidation @batchid,1 end
GO
