SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
CREATE         procedure [dbo].[VI_insertProcessedImportOverheadFilesPurchases]         
(        
@batchno numeric,    
@tenantid int    
)        
as        
begin        
         
delete from VI_importOverheadfiles_processed where  batchid = @batchno and tenantid = @tenantid       
        
INSERT INTO [VI_importOverheadfiles_Processed]        
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
           ,[VendorCostitution],
		    effdate)             
                   
     select   
             [TenantId]        
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
           ,[VendorCostitution]
		   ,[effdate]
     from Vi_ImportStandardFiles_processed where Batchid=@batchno and TenantId=@tenantid  and upper(PurchaseCategory) like 'OVERHEAD%'   
  
  
  --- recalculation of apportioned Overhead  
  
begin        
        
declare @PrevAppor float = 0.00        
  
--select * from ApportionmentBaseData  
        
set @Prevappor = (select top 1 ApportionmentSupplies from ApportionmentBaseData  where  TenantId=@tenantid and type='Previous')        

if @prevappor = 0 begin set @prevappor = 100 end   -- 16-dec-2023

update vi_importstandardfiles_processed set grossprice=round(grossprice*@PrevAppor/100,2),netprice=round(netprice*@prevappor/100,2),  
LineNetAmount=round(LineNetAmount*@prevappor/100,2),vatlineamount=round(vatlineamount*@prevappor/100,2),LineAmountInclusiveVAT =round(lineamountinclusivevat*@prevappor/100,2),  
TotalTaxableAmount =round(totaltaxableamount*@prevappor/100,2)   
where batchid=@batchno and TenantId=@tenantid  and upper(PurchaseCategory) like 'OVERHEAD%' and Isapportionment = '1' and AffiliationStatus ='Y'
  
update vi_importstandardfiles_processed set grossprice=0,netprice=0,  
LineNetAmount=0,vatlineamount=0,LineAmountInclusiveVAT =0,  
TotalTaxableAmount =0 where batchid=@batchno and TenantId=@tenantid  and upper(PurchaseCategory) like 'OVERHEAD%' and (Isapportionment = '0' or AffiliationStatus ='N')  
  
        
end       
end  
  
--select * from VI_importstandardfiles_Processed where PurchaseCategory like 'O%' 
GO
