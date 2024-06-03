SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                PROCEDURE [dbo].[InsertBatchUploadUnifiedPurchase] (     
@batchId int,
  @json nvarchar(max) ='[{"BuyerName":"shu","InvoiceCurrencyCode":"SAR","ID":1,"SN":"1","Posting Date":"3\/1\/2023 12:00:00 AM","Invoice Date":"3\/1\/2023 12:00:00 AM","Invoice No.":"SR-012","Doc. No.":"SR-012","Remarks":"","Accounting\/Doc type":"","Cust
  
    
      
        
 omers AddressCountry":"","Customers VAT ID":"301000000000003","Country of VAT registration":"Saudi Arabia","Tax code":"","Tax code description":"","Amount of sales - SAR (NET of VAT)":"50000","VAT amount (in SAR)":"7500","VAT rate":"0.14999589052354728",
  
    
      
        
" Invoice text description":"","Ship to country":"","Bill to country":"","Ship from country":"","GL account code":"","GL account description":""}]',                      
  @fileName nvarchar(max)='',                       
  @tenantId int = 150,                 
  @mappingId int =1,            
  @fromDate datetime = null,                       
  @toDate datetime = null                      
) AS BEGIN Declare @MaxBatchId int                       
                      
          print @json            
--Select                       
--  @MaxBatchId = isnull(max(batchId),0)                       
--  from                       
--  BatchData;                      
--Declare @batchId int = @MaxBatchId + 1;                      
                      
 Insert into dbo.logs                       
values                       
  (                      
    'purchase '+@json,                       
    @toDate,                       
    @batchId                      
  )                      
                        
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
--    'Purchase Unified',                       
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
  ItemName,                         UOM,                       
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
  billingreferenceid,    
  [Filename] -- added this field by NJ on 18-jan-2023  - Ref Issue No.119                          
  )                       
select                       
  isNull(xml_uuid,NEWID()),                       
  0,                       
  0,                       
  0,                       
  0,                
  0,                       
  ISNULL(TransType, 'Unclassified') as TransType,                         
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
  ISNULL(InvoiceType, 'Unclassified') as InvoiceType,                        
  -- Passing 'Standard' if InvoiceType is blank - altered by NJV on 20-jan-2023                          
  @batchId,                       
  GETDATE(),                       
  1,                       
  0,                       
  @tenantId ,             
  ISNULL(BillingReferenceId, '') as BillingReferenceId,    
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
OrgType nvarchar(max) '$."OrgType"',    
BillingReferenceId nvarchar(max) '$."BillingReferenceId"'     
  );                   
              
            
declare @sql nvarchar(max);                  
declare @desc nvarchar(max);                  
declare @field nvarchar(max);                  
declare @error_code  nvarchar(max);                  
declare @stop_condition  int;                  
declare @next_rule_on_success int;                  
declare @next_rule_on_failure int;                  
declare @output int;                  
declare @count int=0;                  
declare @skip int=0;                  
declare @query nvarchar(max)='update ImportBatchData set TransType=@transType,  InvoiceType = @transType + '' Invoice - Standard'' where batchId=@batchId and '            
declare @transType nvarchar(200)            
            
declare @v_sql CURSOR;                  
set @v_sql=                   
CURSOR FOR                  
select r.SqlStatement,r.OnSuccessNext,r.OnFailureNext,r.errorCode,r.StopCondition,r.[key],r.TransactionType from [unifiedRules] r                  
where r.[key]='Map'+cast(@mappingId as nvarchar(50)) and r.isActive=1             
and  ((r.TenantId=@tenantId and (select count(*) from [unifiedRules] where tenantId=@tenantId)>0)              
or (r.TenantId is null and (select count(*) from [unifiedRules] where tenantId=@tenantId)=0))            
order by r.[Order]                
          
            
--select * from [unifiedRules]            
            
OPEN @v_sql                              
FETCH NEXT  FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition,@field,@transType;                              
WHILE @@FETCH_STATUS = 0                              
BEGIN                              
   set @count=@count+1;                  
                     
  --print concat(concat(@sql, @field),@count)                          
   set @sql = @query + @sql  ;                              
    print @sql                  
   EXECUTE sp_executesql @SQL,@Params = N'@batchId INT,@transType nvarchar(200)', @batchId = @batchId,            
   @transType = @transType                      
                         
 FETCH NEXT                               
FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition,@field,@transType;                              
                              
END                              
                              
CLOSE @v_sql                              
                              
                              
DEALLOCATE @v_sql              
            
update             
  BatchData             
set                         
  status = 'Processed',
  [Type] = 'Purchase Unified'
where   
  BatchId = @batchid and
  FileName = @fileName             
  and Status = 'Unprocessed';              
  exec InsertBatchUploadDefaultValues @batchId            
            
END ELSE BEGIN PRINT 'Invalid JSON Imported' END END             
--begin             
---- if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'SALES')          
----BEGIN        
----exec SalesTransValidation @batchid,1          
----END        
---- if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'CREDIT')          
----BEGIN        
----exec CreditNoteTransValidation @batchid,1          
        
----END        
---- if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'DEBIT')          
----BEGIN        
----exec DebitNoteTransValidation @batchid,1         
        
----END        
-- if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'PURCHASE')          
--BEGIN        
--exec PurchaseTransValidation @batchid,1           
        
--END        
        
-- if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'CREDIT-PURCHASE')          
--BEGIN        
--exec CreditNotePurchaseTransValidation @batchid,1,@tenantId           
        
--END        
        
-- if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'DEBIT-PURCHASE')          
--BEGIN        
--exec DebitNotePurchaseTransValidation @batchid,1           
        
--END        
        
-- if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'UNCLASSIFIED')          
--BEGIN        
--exec UnclassifiedTransValidation @batchid,1,@tenantId           
        
--END        
--end
GO
