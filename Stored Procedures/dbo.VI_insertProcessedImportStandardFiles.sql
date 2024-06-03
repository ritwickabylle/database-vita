SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
          
CREATE         procedure [dbo].[VI_insertProcessedImportStandardFiles]           
(          
@batchno numeric=7913,        
@tenantid int=148       
)          
as          
begin          
    
      
        
delete from importstandardfiles_errorlists where status = '1' and batchid = @batchno  and TenantId=@tenantid      
and uniqueIdentifier in (select uniqueIdentifier from ##salesImportBatchDataTemp where Batchid=@batchno and upper(trim(InvoiceType)) like 'SALES%')    
    
delete from importStandardfiles_ErrorLists where batchid = @batchno and tenantid = @tenantid   
and uniqueIdentifier in (select uniqueIdentifier from ##salesImportBatchDataTemp where Batchid=@batchno and upper(trim(InvoiceType)) like 'SALES%')    
and uniqueIdentifier in (select distinct uniqueIdentifier from Transactionoverride where batchid = @batchno and tenantid=@tenantid)    
  
  
        
--select * from importStandardfiles_ErrorLists where batchid = 261 and tenantid = 2 and uniqueIdentifier in (select distinct uniqueIdentifier from Transactionoverride where batchid = 261 and tenantid=2)        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select i.tenantid,      
@batchno,        
i.uniqueidentifier,'1',' ',0,0,getdate() from ##salesImportBatchDataTemp i          
where upper(trim(I.invoicetype)) like 'SALES%'  and i.batchid =       
@batchno         
and i.UniqueIdentifier not in           
(select UniqueIdentifier from ImportStandardFiles_Errorlists e where e.batchid =        
@batchno and TenantId=@tenantid)           
           
delete from VI_importstandardfiles_processed where  batchid = @batchno and TenantId=@tenantid   and   upper(trim(invoicetype)) like 'SALES%'    
        
  insert into logs(batchid,date,json) values(@batchno,getdate(),'VI_insertProcessedImportStandardFiles(Prev. Data Validation Done')        
          
INSERT INTO [VI_importstandardfiles_Processed]          
           ([TenantId]          
           ,[UniqueIdentifier]          
           ,[BatchId]          
           ,[Filename]          
           ,[InvoiceType]          
           ,[IRNNo]          
           ,[InvoiceNumber]          
           ,[IssueDate]          
           ,[IssueTime]          
           ,[InvoiceCurrencyCode]          
           ,[PurchaseOrderId]          
           ,[ContractId]          
           ,[SupplyDate]          
           ,[SupplyEndDate]          
           ,[BuyerMasterCode]          
           ,[BuyerName]          
           ,[BuyerVatCode]          
           ,[BuyerContact]          
           ,[BuyerCountryCode]          
           ,[InvoiceLineIdentifier]          
           ,[ItemMasterCode]          
           ,[ItemName]          
           ,[UOM]          
           ,[GrossPrice]          
           ,[Discount]          
           ,[NetPrice]          
           ,[Quantity]          
           ,[LineNetAmount]          
           ,[VatCategoryCode]          
           ,[VatRate]          
           ,[VatExemptionReasonCode]          
           ,[VatExemptionReason]          
           ,[VATLineAmount]          
           ,[LineAmountInclusiveVAT]          
           ,[Processed]          
           ,[Error]          
           ,[BillingReferenceId]          
           ,[OrignalSupplyDate]          
           ,[ReasonForCN]          
           ,[BillOfEntry]          
           ,[BillOfEntryDate]          
           ,[CustomsPaid]          
           ,[CustomTax]          
           ,[WHTApplicable]          
           ,[PurchaseNumber]          
           ,[PurchaseCategory]          
           ,[LedgerHeader]          
           ,[TransType]          
           ,[AdvanceRcptAmtAdjusted]          
           ,[VatOnAdvanceRcptAmtAdjusted]          
           ,[AdvanceRcptRefNo]          
           ,[PaymentMeans]          
           ,[PaymentTerms]          
           ,[NatureofServices]          
           ,[Isapportionment]     
           ,[ExciseTaxPaid]          
           ,[OtherChargesPaid]          
           ,[TotalTaxableAmount]          
           ,[VATDeffered]          
           ,[PlaceofSupply]          
           ,[RCMApplicable]          
           ,[OrgType]          
           ,[CreationTime]          
           ,[CreatorUserId]          
           ,[LastModificationTime]          
           ,[LastModifierUserId]          
           ,[IsDeleted]        
           ,[DeleterUserId]          
           ,[DeletionTime]          
           ,[AffiliationStatus]          
           ,[CapitalInvestedbyForeignCompany]          
           ,[CapitalInvestmentCurrency]          
           ,[CapitalInvestmentDate]          
           ,[ExchangeRate]          
           ,[PerCapitaHoldingForiegnCo]          
           ,[ReferenceInvoiceAmount]          
           ,[VendorCostitution])               
                     
     select i.[TenantId],          
           i.[UniqueIdentifier]          
           ,i.[BatchId]          
           ,i.[Filename]          
           ,i.[InvoiceType]          
           ,i.[IRNNo]          
           ,i.[InvoiceNumber]          
           ,i.[IssueDate]          
           ,i.[IssueTime]          
           ,i.[InvoiceCurrencyCode]          
           ,i.[PurchaseOrderId]          
           ,i.[ContractId]          
           ,i.[SupplyDate]          
           ,i.[SupplyEndDate]          
           ,i.[BuyerMasterCode]          
           ,i.[BuyerName]          
           ,i.[BuyerVatCode]          
           ,i.[BuyerContact]          
           ,i.[BuyerCountryCode]          
           ,i.[InvoiceLineIdentifier]          
           ,i.[ItemMasterCode]          
           ,i.[ItemName]          
           ,i.[UOM]          
           ,isnull(i.[GrossPrice],0)          
           ,isnull(i.[Discount],0)          
           ,isnull(i.[NetPrice],0)          
           ,isnull(i.[Quantity],0)          
           ,isnull(i.[LineNetAmount],0)          
           ,i.[VatCategoryCode]          
           ,isnull(i.[VatRate],0)          
           ,i.[VatExemptionReasonCode]          
           ,i.[VatExemptionReason]          
           ,isnull(i.[VATLineAmount],0)          
           ,isnull(i.[LineAmountInclusiveVAT],0)          
           ,i.[Processed]          
           ,i.[Error]          
           ,i.[BillingReferenceId]          
           ,i.[OrignalSupplyDate]          
           ,i.[ReasonForCN]          
           ,i.[BillOfEntry]          
           ,i.[BillOfEntryDate]          
           ,isnull(i.[CustomsPaid],0)          
           ,isnull(i.[CustomTax],0)          
           ,i.[WHTApplicable]          
           ,i.[PurchaseNumber]          
           ,i.[PurchaseCategory]          
           ,i.[LedgerHeader]          
           ,i.[TransType]          
           ,isnull(i.[AdvanceRcptAmtAdjusted],0)          
           ,isnull(i.[VatOnAdvanceRcptAmtAdjusted],0)          
           ,i.[AdvanceRcptRefNo]          
           ,i.[PaymentMeans]          
           ,i.[PaymentTerms]          
           ,i.[NatureofServices]          
           ,i.[Isapportionment]          
           ,isnull(i.[ExciseTaxPaid],0)          
           ,isnull(i.[OtherChargesPaid],0)          
           ,isnull(i.[TotalTaxableAmount],0)          
           ,i.[VATDeffered]          
           ,i.[PlaceofSupply]          
           ,i.[RCMApplicable]          
           ,i.[OrgType]          
           ,i.[CreationTime]          
           ,i.[CreatorUserId]          
           ,i.[LastModificationTime]          
           ,i.[LastModifierUserId]          
           ,i.[IsDeleted]          
           ,i.[DeleterUserId]          
           ,i.[DeletionTime]          
           ,i.[AffiliationStatus]          
           ,isnull(i.[CapitalInvestedbyForeignCompany],0)          
           ,i.[CapitalInvestmentCurrency]          
           ,i.[CapitalInvestmentDate]          
           ,isnull(i.[ExchangeRate],0)          
           ,i.[PerCapitaHoldingForiegnCo]          
           ,isnull(i.[ReferenceInvoiceAmount],0)          
           ,i.[VendorConstitution]          
     from ##salesImportBatchDataTemp i inner join importstandardfiles_ErrorLists e on i.UniqueIdentifier = e.uniqueIdentifier and i.Batchid=@batchno and i.TenantId=@tenantid and e.status = '1'          
    
--update VI_importstandardfiles_Processed set effdate = (case when IssueDate < SupplyDate then issuedate else SupplyDate end) where         
--batchid = @batchno and issuedate is not null and supplydate is not null and TenantId=@tenantid        
    
update VI_importstandardfiles_Processed set effdate = IssueDate  where         
batchid = @batchno and issuedate is not null  and TenantId=@tenantid        
    
--update VI_importstandardfiles_Processed     
begin          
        
          
declare @failedRecords int =0            
    
set @failedRecords = (select count(distinct uniqueidentifier) from importstandardfiles_ErrorLists where Batchid = @batchno and status = 0 and tenantid=@tenantid)            
            
update BatchData set  SuccessRecords = totalRecords- @failedRecords ,FailedRecords=@failedRecords , status='Processed' where batchid=@batchno and TenantId=@tenantid              
    
end          
          
end
GO
