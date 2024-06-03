SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE      PROCEDURE [dbo].[InsertBatchUploadPurchase] (    
    @batchId int,
  @json nvarchar(max)=null,  
  @fileName nvarchar(max)=null,       
  @tenantId int = null,    
   @fromdate DateTime=null,      
 @todate datetime=null    
)     
AS     
BEGIN     
Declare @MaxBatchId int       
    
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
--    'Purchase',    
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
  ) Declare @totalRecords int = (      
    select       
      count(*)       
    from       
      OPENJSON(@json)      
  );      
IF (      
  ISJSON(@json) = 1       
  and @totalRecords > 0      
)     
BEGIN     
PRINT 'Imported JSON is Valid';      
insert into ImportBatchData(      
  uniqueidentifier, Processed, PurchaseNumber,       
  PurchaseCategory, LedgerHeader,       
  NatureofServices,     
  Isapportionment,    
  AffiliationStatus, ReasonforCN,    
  InvoiceNumber, IssueDate, IssueTime,       
  InvoiceCurrencyCode, SupplyDate,       
  BuyerMasterCode, BuyerName, BuyerVatCode,       
  BuyerContact, BuyerCountryCode,       
  InvoiceLineIdentifier, ItemMasterCode,       
  ItemName, UOM, GrossPrice, Discount,       
  NetPrice, Quantity, LineNetAmount,       
  VatCategoryCode, VatRate, VatExemptionReasonCode,       
  VatExemptionReason, VATLineAmount,       
  LineAmountInclusiveVAT, BillOfEntry,       
  BillOfEntryDate, CustomsPaid, ExciseTaxPaid,       
  OtherChargesPaid, VATDeffered, PlaceofSupply,       
  RCMApplicable, WHTApplicable, BatchId,       
  CreationTime, CreatorUserId, IsDeleted,       
  TenantId, InvoiceType, orgtype, PaymentMeans,TotalTaxableAmount,TransType,[Filename]    
)       
select       
  NEWID(),       
  0,       
  ISNULL(PurchaseNumber, '') as PurchaseNumber,       
  ISNULL(PurchaseCategory, '') as PurchaseCategory,       
  ISNULL(LedgerHead, '') as LedgerHead,       
  ISNULL(NatureofService, '') as NatureofService,       
  --dbo.ISNULLOREMPTYFORBIT(Overheadapportionment) as Overheadapportionment,     
  case when upper(purchasecategory) like 'OVER%' and isnull(substring(upper(Overheadapportionment),1,1),'Y') = 'Y' then 1 else 0 end as Overheadapportionment,    
  --1 as Overheadapportionment,    
  isnull(InputVATClaim,'Y') as InputVATClaim,    
  isnull(ReasonInput,'') as ReasonInput,    
  ISNULL(SupplierInvoiceNumber, '') as SupplierInvoiceNumber,       
  dbo.ISNULLOREMPTYFORDATE(PurchaseDate) as PurchaseDate,       
  ISNULL(PurchaseTime, '') as PurchaseTime,       
  ISNULL(Purchasecurrencycode, '') as Purchasecurrencycode,       
  dbo.ISNULLOREMPTYFORDATE(SupplierInvoiceDate) as SupplierInvoiceDate,       
  ISNULL(SupplierMasterCode, '') as SupplierMasterCode,       
  ISNULL(SupplierName, '') as SupplierName,       
  ISNULL(SupplierVATnumber, '') as SupplierVATnumber,       
  ISNULL(SupplierContact, '') as SupplierContact,       
  ISNULL(SupplierCountryCode, '') as SupplierCountryCode,       
  ISNULL(Purchaseentrylineidentifier, '') as Purchaseentrylineidentifier,       
  ISNULL(ItemMasterCode, '') as ItemMasterCode,       
  ISNULL(Itemname, '') as Itemname,       
  ISNULL(      
    Purchasedquantityunitofmeasure,       
    ''      
  ) as Purchasedquantityunitofmeasure,       
  dbo.ISNULLOREMPTYFORDECIMAL(Itemgrossprice) as Itemgrossprice,       
  dbo.ISNULLOREMPTYFORDECIMAL(Itempricediscount) as Itempricediscount,       
  dbo.ISNULLOREMPTYFORDECIMAL(Itemnetprice) as Itemnetprice,       
  dbo.ISNULLOREMPTYFORDECIMAL(Purchasequantity) as Purchasequantity,       
  dbo.ISNULLOREMPTYFORDECIMAL(Purchaselinenetamount) as Purchaselinenetamount,       
  ISNULL(PurchaseitemVATcategorycode, '') as PurchaseitemVATcategorycode,       
  dbo.ISNULLOREMPTYFORDECIMAL(PurchaseitemVATrate) as PurchaseitemVATrate,       
  ISNULL(VATexemptionreasoncode, '') as VATexemptionreasoncode,       
  ISNULL(VATexemptionreason, '') as VATexemptionreason,       
  dbo.ISNULLOREMPTYFORDECIMAL(VATlineamount) as VATlineamount,       
  dbo.ISNULLOREMPTYFORDECIMAL(LineamountinclusiveVAT) as LineamountinclusiveVAT,       
  ISNULL(BillofEntry, '') as BillofEntry,       
  dbo.ISNULLOREMPTYFORDATE(BillofEntryAWBdate) as BillofEntryAWBdate,       
  dbo.ISNULLOREMPTYFORDECIMAL(CustomsPaid) as CustomsPaid,       
  dbo.ISNULLOREMPTYFORDECIMAL(ExciseTaxPaid) as ExciseTaxPaid,       
  dbo.ISNULLOREMPTYFORDECIMAL(OtherChargesPaid) as OtherChargesPaid,       
  case when upper(purchasetype) like '%IMPORT%' and upper(purchasecategory) like 'SERVICE%' then 0    
       when upper(purchasetype) like '%IMPORT%' and upper(purchasecategory) like 'GOOD%' and isnull(VATdeffered,'Y') like 'Y%' then 1    
       else 0 end as VATDeffered,       
--  dbo.ISNULLOREMPTYFORBIT(VATDeffered) as VATDeffered,       
  ISNULL(PlaceofSupply, '') as PlaceofSupply,       
  case when upper(purchasetype) like '%IMPORT%' and upper(purchasecategory) like 'GOOD%' then 0    
       when upper(purchasetype) like '%IMPORT%' and (upper(purchasecategory) like 'SERVICE%' or upper(purchasecategory) like 'OVERHEAD%') and isnull(rcmapplicable,'Y') like 'Y%' then 1    
       else 0 end as RCMApplicable,       
  dbo.ISNULLOREMPTYFORBIT(WHTApplicable) as WHTApplicable,       
  @batchId,       
  GETDATE(),       
  1,       
  0,       
  @tenantId,       
  case when purchasetype is null then 'Purchase Entry-STANDARD' when purchasetype = '' then 'Purchase Entry-STANDARD' else 'Purchase Entry-' + purchasetype end,       
  isnull(supptype, 'PRIVATE'),       
  isnull(supplytype, 'ECONOMIC') ,    
  isnull(TotalTaxableAmount,0),  
  'PURCHASE' as TransType,  
  @fileName    
from       
  OPENJSON(@json) with (      
PurchaseNumber nvarchar(max) '$."PurchaseNumber"',        
PurchaseCategory nvarchar(max) '$."PurchaseCategory"',        
LedgerHead nvarchar(max) '$."LedgerHead"',        
NatureofService nvarchar(max) '$."NatureofService"',        
Overheadapportionment nvarchar(max) '$."Isapportionment"',      
InputVATClaim nvarchar(max) '$."AffiliationStatus"',    
ReasonInput nvarchar(max) '$."ReasonForCN"',      
SupplierInvoiceNumber nvarchar(max) '$."InvoiceNumber"',  
PurchaseDate nvarchar(max) '$."IssueDate"',        
PurchaseTime nvarchar(max) '$."IssueTime"',        
Purchasecurrencycode nvarchar(max) '$."InvoiceCurrencyCode"',  
SupplierInvoiceDate nvarchar(max) '$."SupplyDate"',        
SupplierMasterCode nvarchar(max) '$."BuyerMasterCode"',        
SupplierName nvarchar(max) '$."BuyerName"',        
SupplierVATnumber nvarchar(max) '$."BuyerVatCode"',        
SupplierContact nvarchar(max) '$."BuyerContact"',        
SupplierCountryCode nvarchar(max) '$."BuyerCountryCode"',        
Purchaseentrylineidentifier nvarchar(max) '$."InvoiceLineIdentifier"',        
ItemMasterCode nvarchar(max) '$."ItemMasterCode"',      
Itemname nvarchar(max) '$."ItemName"',        
Purchasedquantityunitofmeasure nvarchar(max) '$."UOM"',        
Itemgrossprice nvarchar(max) '$."GrossPrice"',    
Itempricediscount nvarchar(max) '$."Discount"',        
Itemnetprice nvarchar(max) '$."NetPrice"',        
Purchasequantity nvarchar(max) '$."Quantity"',  
Purchaselinenetamount nvarchar(max) '$."LineNetAmount"',        
PurchaseitemVATcategorycode nvarchar(max) '$."VatCategoryCode"',        
PurchaseitemVATrate nvarchar(max) '$."VatRate"',        
VATexemptionreasoncode nvarchar(max) '$."VatExemptionReasonCode"',        
VATexemptionreason nvarchar(max) '$."VatExemptionReason"',        
VATlineamount nvarchar(max) '$."VATLineAmount"',        
LineamountinclusiveVAT nvarchar(max) '$."LineAmountInclusiveVAT"',        
BillofEntry nvarchar(max) '$."BillOfEntry"',        
BillofEntryAWBdate nvarchar(max) '$."BillOfEntryDate"',        
CustomsPaid nvarchar(max) '$."CustomsPaid"',      
ExciseTaxPaid nvarchar(max) '$."ExciseTaxPaid"',        
OtherChargesPaid nvarchar(max) '$."OtherChargesPaid"',        
VATDeffered nvarchar(max) '$."VATDeffered"',        
PlaceofSupply nvarchar(max) '$."PlaceofSupply"',        
RCMApplicable nvarchar(max) '$."RCMApplicable"',        
WHTApplicable nvarchar(max) '$."WHTApplicable"',        
purchasetype nvarchar(max) '$."InvoiceType"',        
supptype nvarchar(max) '$."OrgType"',        
supplytype nvarchar(max) '$."SupplyType"',      
TotalTaxableAmount nvarchar(max) '$."TotalTaxableAmount"'   
  );      
  
  
  
  
  
      exec InsertBatchUploadDefaultValues @batchId     
    
update             
  BatchData             
set                         
  status = 'Processed',
  [Type] = 'Purchase'
where   
  BatchId = @batchid and
  FileName = @fileName             
  and Status = 'Unprocessed';    
  exec InsertBatchUploadDefaultValues @batchId  
  
END ELSE BEGIN PRINT 'Invalid JSON Imported' END END   

--begin     
--exec PurchaseTransValidation @batchid,1     
--end
GO
