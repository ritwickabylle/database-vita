SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
      
CREATE     PROCEDURE [dbo].[InsertBatchUploadPayment] (      
	@batchId int,
 @json nvarchar(max),           
 @fileName nvarchar(max),           
 @tenantId int = null,        
 @fromdate DateTime=null,          
 @todate datetime=null        
)       
AS       
BEGIN       
 --Declare @MaxBatchId int           
 --Select           
 --  @MaxBatchId = max(batchId)           
 --from           
 --  BatchData;       
         
 --Declare @batchId int = @MaxBatchId + 1;          
 --INSERT INTO [dbo].[BatchData] (          
 --  [TenantId], [BatchId], [FileName],           
 --  [TotalRecords], [Status], [Type],[fromDate],[toDate],           
 --  [CreationTime], [IsDeleted]          
 --)           
 --VALUES           
 --  (          
 --  @tenantId,           
 --  @batchId,           
 --  @fileName,           
 --  0,           
 -- 'Unprocessed',           
 -- 'Payment',           
 --  @fromdate,        
 --  @todate,        
 --  GETDATE(),           
 --  0          
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
   uniqueidentifier,      
   Processed,      
   WHTApplicable,           
   VATDeffered,      
   RCMApplicable,      
   Isapportionment,           
   InvoiceType,          
   BuyerName,           
   OrgType,           
   BuyerCountryCode,      
   InvoiceNumber,      
   IssueDate,           
   TotalTaxableAmount,           
   InvoiceCurrencyCode,          
   PaymentMeans,           
   ExchangeRate,           
   LineAmountInclusiveVAT,           
   LedgerHeader,          
   NatureofServices,           
   ItemName,          
   PlaceofSupply,          
   AffiliationStatus,           
   PurchaseNumber,          
   SupplyEndDate,          
   ReferenceInvoiceAmount,           
   PaymentTerms,           
   PerCapitaHoldingForiegnCo,           
   CapitalInvestedbyForeignCompany,           
   CapitalInvestmentCurrency,          
   CapitalInvestmentDate,           
   VendorConstitution,          
   BatchId,           
   CreationTime,           
   CreatorUserId,           
   IsDeleted,      
   TenantId,      
   Filename    ,      
   TransType,      
   VatExemptionReasonCode,      
   VATRate,      
   LineNetAmount       
 )           
 select           
   NEWID(),           
   0,           
   0,           
   case when upper(vatdeffered) like 'Y%'  then 1      
     else 0 end as VATDeffered,           
   0,           
   0,           
   'WHT - ' + ISNULL(InvoiceType, '') as InvoiceType,           
   ISNULL(BuyerName, '') as BuyerName,           
   case when OrgType= ' ' or OrgType = Null then 'Private'       
   else ISNULL(OrgType, '') end as OrgType,           
   ISNULL(BuyerCountryCode, '') as BuyerCountryCode,      
   ISNULL(InvoiceNumber, NEWID()) as InvoiceNumber,      
   dbo.ISNULLOREMPTYFORDATE(IssueDate) as IssueDate,           
   dbo.ISNULLOREMPTYFORDECIMAL(TotalTaxableAmount) as TotalTaxableAmount,           
   ISNULL(InvoiceCurrencyCode, '') as InvoiceCurrencyCode,           
   ISNULL(PaymentMeans, '') as PaymentMeans,           
   dbo.ISNULLOREMPTYFORDECIMAL(ExchangeRate) as ExchangeRate,           
   dbo.ISNULLOREMPTYFORDECIMAL(LineAmountInclusiveVAT) as LineAmountInclusiveVAT,           
   ISNULL(LedgerHeader, '') as LedgerHeader,           
   ISNULL(NatureofServices, '') as NatureofServices,           
   ISNULL(ItemName, '') as ItemName,           
   case when upper(PlaceofSupply) = 'INSIDE' then 'Inside Country'       
   when upper(PlaceofSupply) = 'INSIDE KSA' then 'Inside Country'       
   when upper(PlaceofSupply) = 'OUTSIDE' then 'Outside Country'      
   when upper(PlaceofSupply) = 'OUTSIDE KSA' then 'Outside Country'      
   when upper(PlaceofSupply) = 'N/A' or upper(PlaceofSupply) = 'N.A.' or upper(PlaceofSupply) = 'NA' or upper(PlaceofSupply) = 'N.A' then 'Inside Country'      
   else ISNULL(PlaceofSupply, '') end as PlaceofSupply,           
   case when upper(AffiliationStatus) = 'YES' then 'Affiliate'      
   when upper(AffiliationStatus) = 'NO' then 'Non-affiliate'      
   else ISNULL(AffiliationStatus, '') end as AffiliationStatus,           
   ISNULL(PurchaseNumber, '') as PurchaseNumber,           
   dbo.ISNULLOREMPTYFORDATE(SupplyEndDate) as SupplyEndDate,           
   dbo.ISNULLOREMPTYFORDECIMAL(ReferenceInvoiceAmount) as ReferenceInvoiceAmount,           
   ISNULL(PaymentTerms, '') as PaymentTerms,           
   ISNULL(PerCapitaHoldingForiegnCo, '') as PerCapitaHoldingForiegnCo,           
   ISNULL(          
  CapitalInvestedbyForeignCompany,           
  ''          
   ) as CapitalInvestedbyForeignCompany,           
   ISNULL(CapitalInvestmentCurrency, '') as CapitalInvestmentCurrency,           
   dbo.ISNULLOREMPTYFORDATE(CapitalInvestmentDate) as CapitalInvestmentDate,           
   ISNULL(VendorConstitution, '') as VendorConstitution,           
   @batchId,           
   GETDATE(),           
   1,           
   0,           
   @tenantId ,      
   @fileName,      
   'PAYMENT' as TransType,      
    ISNULL(BuyerCountryCode, '') as VatExemptionReasonCode,      
    isnull(WHTRateApplicable,0) as vatrate,      
    isnull(WHTDeducted,0) as WHTDeducted      
      
 from           
   OPENJSON(@json) with (      
  VATDeffered nvarchar(max) '$."VATDeffered"',      
  InvoiceType nvarchar(max) '$."InvoiceType"',           
  [BuyerName] nvarchar(max) '$."BuyerName"',           
  OrgType nvarchar(max) '$."OrgType"',           
  [BuyerCountryCode] nvarchar(max) '$."BuyerCountryCode"',      
   [InvoiceNumber] nvarchar(max) '$."InvoiceNumber"' ,      
  [IssueDate] nvarchar(max) '$."IssueDate"',           
  TotalTaxableAmount nvarchar(max) '$."TotalTaxableAmount"',           
  [InvoiceCurrencyCode] nvarchar(max) '$."InvoiceCurrencyCode"',           
  PaymentMeans nvarchar(max) '$."PaymentMeans"',           
  ExchangeRate nvarchar(max) '$."ExchangeRate"',           
  LineAmountInclusiveVAT nvarchar(max) '$."LineAmountInclusiveVAT"',           
  LedgerHeader nvarchar(max) '$."ItemName"',           
  NatureofServices nvarchar(max) '$.""',           
  [ItemName] nvarchar(max) '$."ItemName"',           
  PlaceofSupply nvarchar(max) '$."PlaceofSupply"',           
  AffiliationStatus nvarchar(max) '$."AffiliationStatus"',           
  PurchaseNumber nvarchar(max) '$."PurchaseNumber"',           
  SupplyEndDate nvarchar(max) '$."SupplyEndDate"',           
  ReferenceInvoiceAmount nvarchar(max) '$."ReferenceInvoiceAmount"',           
  PaymentTerms nvarchar(max) '$."PaymentTerms"',           
  PerCapitaHoldingForiegnCo nvarchar(max) '$."PerCapitaHoldingForiegnCo"',           
  CapitalInvestedbyForeignCompany nvarchar(max) '$."CapitalInvestedbyForeignCompany"',           
  CapitalInvestmentCurrency nvarchar(max) '$."CapitalInvestmentCurrency"',           
  CapitalInvestmentDate nvarchar(max) '$."CapitalInvestmentDate"',           
  VendorConstitution nvarchar(max) '$."VendorConstitution"' ,      
  VatExemptionReason nvarchar(max) '$."VatExemptionReason"',      
  WHTDeducted nvarchar(max) '$."WHTDeducted"',      
  WHTRateApplicable nvarchar(max) '$."WHTRateApplicable"'      
   );       
      
   Insert into Logs( [json]      
    ,[date]      
    ,[batchid])      
    Values('InsertBatchUploadPayment inserted to importbatchdata ', GetDate(),@BatchId)      
      
update             
  BatchData             
set                         
  status = 'Processed',
  [Type] = 'Payment'
where   
  BatchId = @batchid and
  FileName = @fileName             
  and Status = 'Unprocessed';            
      
   Insert into Logs( [json]      
      ,[date]      
      ,[batchid])      
   Values('InsertBatchUploadPayment updated to batchdata ', GetDate(),@BatchId)      
      
 EXEC insertbatchuploaddefaultvalues @batchid      
      
 Insert into Logs( [json]      
      ,[date]      
      ,[batchid])      
   Values('InsertBatchUploadPayment executed  insertbatchuploaddefaultvalues ', GetDate(),@BatchId)      
      
      
 --exec PaymentTransValidation @batchId,1      
      
  Insert into Logs( [json]      
      ,[date]      
      ,[batchid])      
   Values('InsertBatchUploadPayment executed paymenttransvalidation ', GetDate(),@BatchId)      
      
      
      
END       
      
ELSE BEGIN PRINT 'Invalid JSON Imported' END END
GO
