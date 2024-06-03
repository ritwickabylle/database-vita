SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
    
CREATE    PROCEDURE [dbo].[InsertBatchUploadCreditPurchase]       
(    @batchId int, @json nvarchar(max)   ,      
@fileName nvarchar(max),        
@tenantId int = null,    
 @fromdate DateTime=null,  @todate datetime=null)       
AS BEGIN          
--Declare @MaxBatchId int        
--Select @MaxBatchId=max(batchId) from BatchData;        
          
--Declare @batchId int = @MaxBatchId + 1;          
--INSERT INTO [dbo].[BatchData] ([TenantId], [BatchId], [FileName],[TotalRecords], [Status],[Type],    
--[fromDate],    
--[toDate], [CreationTime], [IsDeleted])  VALUES    ( @tenantId, @batchId, @fileName, 0,'Unprocessed','Credit-purchase',@fromdate,  @todate, GETDATE(), 0)         
Insert into dbo.logs        
values(@json,getdate(),@batchId) Declare @totalRecords int =(select count(*) from OPENJSON(@json) );      
IF (   ISJSON(@json) = 1 and @totalRecords>0 )       
BEGIN PRINT 'Imported JSON is Valid';      
insert into ImportBatchData(uniqueidentifier,Processed,Isapportionment,        
    InvoiceType,        
 PurchaseCategory,      
    IRNNo,        
    InvoiceNumber,        
    IssueDate,        
    IssueTime,        
    InvoiceCurrencyCode,        
    BillingReferenceId,        
    OrignalSupplyDate,    
 SupplyDate,    
    ReasonForCN,        
    PurchaseOrderId,        
    ContractId,        
    BuyerMasterCode,        
    BuyerName,        
    BuyerVatCode,        
    BuyerContact,        
    BuyerCountryCode,        
    OrgType,        
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
 LedgerHeader,      
 BillOfEntry,      
 BillOfEntryDate,      
 CustomsPaid,      
 ExciseTaxPaid,      
 OtherChargesPaid,      
 TotalTaxableAmount,      
 VATDeffered,      
 PlaceofSupply,      
 RCMApplicable,      
 WHTApplicable,      
 PaymentMeans,      
    BatchId,        
    CreationTime,        
    CreatorUserId,        
    IsDeleted,        
    TenantId,        
    TransType ,    
 Filename    
    )      
 select         
 NEWID(),0,0,     
 case when InvoiceType is null then 'CN Purchase-STANDARD' when InvoiceType = '' then 'CN Purchase-STANDARD' else 'CN Purchase-' + InvoiceType end,    
    --'CN Purchase - '+ ISNULL(InvoiceType,'') as InvoiceType,        
 ISNULL(PurchaseCategory,'') as PurchaseCategory,      
  IRNNo,        
  ISNULL(InvoiceNumber,'') as InvoiceNumber,        
  dbo.ISNULLOREMPTYFORDATE(IssueDate) as IssueDate,        
  ISNULL(IssueTime,'') as IssueTime,        
  ISNULL(InvoiceCurrencyCode,'') as InvoiceCurrencyCode,        
  ISNULL(BillingReferenceId,'') as BillingReferenceId,        
  dbo.ISNULLOREMPTYFORDATE(OrignalSupplyDate) as OrignalSupplyDate,     
  dbo.ISNULLOREMPTYFORDATE(SupplyDate) as SupplyDate,    
ISNULL(ReasonForCN,'') as ReasonForCN,        
ISNULL(PurchaseOrderId,'') as PurchaseOrderId,        
  ISNULL(ContractId,'') as ContractId,        
  ISNULL(BuyerMasterCode,'') as BuyerMasterCode,        
  ISNULL(BuyerName,'') as BuyerName,        
  ISNULL(BuyerVatCode,'') as BuyerVatCode,        
  ISNULL(BuyerContact,'') as BuyerContact,        
  ISNULL(BuyerCountryCode,'') as BuyerCountryCode,        
  isnull(BuyerType,'PRIVATE') as BuyerType,        
  ISNULL(InvoiceLineIdentifier,'') as InvoiceLineIdentifier,        
  ISNULL(ItemMasterCode,'') as ItemMasterCode,        
  ISNULL(ItemName,'') as ItemName,        
  ISNULL(UOM,'') as UOM,        
  dbo.ISNULLOREMPTYFORDECIMAL(GrossPrice) as GrossPrice,        
  dbo.ISNULLOREMPTYFORDECIMAL(Discount) as Discount,        
  dbo.ISNULLOREMPTYFORDECIMAL(NetPrice) as NetPrice,        
  dbo.ISNULLOREMPTYFORDECIMAL(Quantity) as Quantity,        
  dbo.ISNULLOREMPTYFORDECIMAL(LineNetAmount) as LineNetAmount,        
  ISNULL(VatCategoryCode,'') as VatCategoryCode,        
  dbo.ISNULLOREMPTYFORDECIMAL(VatRate) as VatRate,        
  ISNULL(VatExemptionReasonCode,'') as VatExemptionReasonCode,        
  ISNULL(VatExemptionReason,'') as VatExemptionReason,        
  dbo.ISNULLOREMPTYFORDECIMAL(VATLineAmount) as VATLineAmount,        
  dbo.ISNULLOREMPTYFORDECIMAL(LineAmountInclusiveVAT) as LineAmountInclusiveVAT,        
  ISNULL(LedgerHead,'') as LedgerHead,      
  ISNULL(BillofEntry,'') as BillofEntry,      
  dbo.ISNULLOREMPTYFORDATE(BillofEntryAWBdate) as BillofEntryAWBdate,      
  dbo.ISNULLOREMPTYFORDECIMAL(CustomsPaid) as CustomsPaid,      
  dbo.ISNULLOREMPTYFORDECIMAL(ExciseTaxPaid) as ExciseTaxPaid,      
  dbo.ISNULLOREMPTYFORDECIMAL(OtherChargesPaid) as OtherChargesPaid,      
  dbo.ISNULLOREMPTYFORDECIMAL(TotalTaxableAmt) as TotalTaxableAmt,      
  case when upper(InvoiceType) like '%IMPORT%' and upper(purchasecategory) like 'SERVICE%' and VATdeffered not like 'N%' then 0    
       when upper(InvoiceType) like '%IMPORT%' and upper(purchasecategory) like 'GOOD%' and VATdeffered like 'Y%' then 1    
       else 0 end as VATDeffered,      
  ISNULL(PlaceofSupply,'') as PlaceofSupply,      
  --dbo.ISNULLOREMPTYFORBITRETURN0(RCMApplicable) as RCMApplicable,     
  case when upper(InvoiceType) like '%IMPORT%' and upper(purchasecategory) not like 'GOOD%' and rcmapplicable not like 'N%' then 0    
       when upper(InvoiceType) like '%IMPORT%' and (upper(purchasecategory) like 'SERVICE%' or upper(purchasecategory) like 'OVERHEAD%') and rcmapplicable like 'Y%' then 1    
       else 0 end as RCMApplicable,    
  dbo.ISNULLOREMPTYFORBIT(WHTApplicable) as WHTApplicable,      
  isnull(supplytype,'ECONOMIC'),      
      
  @batchId,        
  GETDATE(),        
  1,        
  0,        
  @tenantId,         
  'CREDIT-PURCHASE' as Transtype,    
  @filename from          
  OPENJSON(@json) with (          
InvoiceType nvarchar(max) '$."InvoiceType"',         
PurchaseCategory nvarchar(max) '$."PurchaseNumber"',       
IRNNo nvarchar(max) '$."PurchaseCategory"',         
InvoiceNumber nvarchar(max) '$."InvoiceNumber"',    
IssueDate nvarchar(max) '$."IssueDate"',         
IssueTime nvarchar(max) '$."IssueTime"',         
InvoiceCurrencyCode nvarchar(max) '$."InvoiceCurrencyCode"',         
BillingReferenceId nvarchar(max) '$."BillingReferenceId"',         
OrignalSupplyDate nvarchar(max) '$."OrignalSupplyDate"',     
SupplyDate nvarchar(max) '$."Original invoice  Date*"',    
ReasonForCN nvarchar(max) '$."ReasonForCN"',         
PurchaseOrderId nvarchar(max) '$."PurchaseOrderId"',         
ContractId nvarchar(max) '$."ContractId"',         
BuyerMasterCode nvarchar(max) '$."BuyerMasterCode"',         
BuyerName nvarchar(max) '$."BuyerName"',       
BuyerVatCode nvarchar(max) '$."BuyerVatCode"',         
BuyerContact nvarchar(max) '$."BuyerContact"',         
BuyerCountryCode nvarchar(max) '$."BuyerCountryCode"',         
BuyerType nvarchar(max) '$."OrgType"',         
InvoiceLineIdentifier nvarchar(max) '$."InvoiceLineIdentifier"',         
ItemMasterCode nvarchar(max) '$."ItemMasterCode"',     
    
    
ItemName nvarchar(max) '$."ItemName"',         
UOM nvarchar(max) '$."UOM"',         
GrossPrice nvarchar(max)'$."GrossPrice"',         
Discount nvarchar(max) '$."Discount"',         
NetPrice [decimal](18,2) '$."NetPrice"',         
Quantity nvarchar(max) '$."Quantity"',         
LineNetAmount  nvarchar(max) '$."LineNetAmount"',         
VatCategoryCode nvarchar(max) '$."VatCategoryCode"',     
    
    
VatRate nvarchar(max) '$."VatRate"',         
VatExemptionReasonCode nvarchar(max) '$."VatExemptionReasonCode"',         
VatExemptionReason nvarchar(max) '$."VatExemptionReason"',         
VATLineAmount  nvarchar(max) '$."VATLineAmount"',         
LineAmountInclusiveVAT  nvarchar(max) '$."LineAmountInclusiveVAT"',       
LedgerHead nvarchar(max) '$."LedgerHeader"',       
BillofEntry nvarchar(max) '$."BillOfEntry"',       
    
    
BillofEntryAWBdate nvarchar(max) '$."BillOfEntryDate"',       
CustomsPaid nvarchar(max) '$."CustomsPaid"',       
ExciseTaxPaid nvarchar(max) '$."ExciseTaxPaid"',       
OtherChargesPaid nvarchar(max) '$."OtherChargesPaid"',       
TotalTaxableAmt nvarchar(max) '$."TotalTaxableAmount"',    
    
    
VATDeffered nvarchar(max) '$."VATDeffered"',       
PlaceofSupply nvarchar(max) '$."PlaceofSupply"',       
RCMApplicable nvarchar(max) '$."RCMApplicable"',       
WHTApplicable nvarchar(max) '$."WHTApplicable"' ,       
supplytype nvarchar(max) '$."PaymentMeans"'      
      
);        
    
 exec InsertBatchUploadDefaultValues @batchId    

 update             
  BatchData             
set                         
  status = 'Processed',
  [Type] = 'Credit-purchase'
where   
  BatchId = @batchid and
  FileName = @fileName             
  and Status = 'Unprocessed';    

END  
ELSE       
BEGIN PRINT 'Invalid JSON Imported'      
END       
END       
--begin        
        
--exec CreditNotePurchaseTransValidation @batchid,1,@tenantId         
        
--end     
    
    
--select SupplyDate,OrignalSupplyDate from ImportBatchData where BatchId=184    
--select * from logs where batchid=184 order by date desc
GO
