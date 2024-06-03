SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[FileUpload_InsertToDraftDebitTables]              
(@uuid UniqueIdentifier,              
@tenantId int)              
as               
begin            
declare @irnno nvarchar(10) = '-1'              
                   
insert into Draft([TenantId]              
,[UniqueIdentifier]              
,[IRNNo]              
,[InvoiceNumber]              
,[IssueDate]              
,[DateOfSupply]              
,[InvoiceCurrencyCode]              
,[CurrencyCodeOriginatingCountry]              
,[PurchaseOrderId]              
,[BillingReferenceId]              
,[ContractId]              
,[LatestDeliveryDate]              
,[Location]              
,[CustomerId]              
,[Status]              
,[Additional_Info]              
,[PaymentType]              
,[PdfUrl]              
,[QrCodeUrl]              
,[XMLUrl]              
,[ArchivalUrl]              
,[PreviousInvoiceHash]              
,[PerviousXMLHash]              
,[XMLHash]              
,[PdfHash]              
,[XMLbase64]              
,[PdfBase64]              
,[IsArchived]              
,[TransTypeCode]              
,[TransTypeDescription]              
,[AdvanceReferenceNumber]              
,[Invoicetransactioncode]              
,[BusinessProcessType]              
,[CreationTime]              
,[IsDeleted]              
,[InvoiceNotes]              
,[XmlUuid]              
,[AdditionalData1]              
,[AdditionalData2]              
,[AdditionalData3]              
,[AdditionalData4]              
,[InvoiceTypeCode]              
,[Language]      
,[isSent]      
,[Source]
,[BankName]
,[AccountName]
,[AccountNumber]
,[IBAN]
,[SwiftCode])              
select               
   [TenantId]              
           ,[UniqueIdentifier]              
           ,@irnno              
           ,[InvoiceNumber]              
           ,[IssueDate]              
           ,ISNULL([DateOfSupply],[IssueDate])             
           ,[InvoiceCurrencyCode]              
           ,[CurrencyCodeOriginatingCountry]              
           ,[PurchaseOrderId]              
           ,[BillingReferenceId]              
           ,[ContractId]              
           ,isnull([LatestDeliveryDate],[IssueDate])              
           ,[Location]              
           ,[CustomerId]              
           ,[Status]              
           ,[Additional_Info]              
           ,[PaymentType]              
           ,[PdfUrl]              
           ,[QrCodeUrl]              
           ,[XMLUrl]              
           ,[ArchivalUrl]              
           ,[PreviousInvoiceHash]              
           ,[PerviousXMLHash]              
           ,[XMLHash]              
           ,[PdfHash]              
           ,[XMLbase64]              
           ,[PdfBase64]              
           ,[IsArchived]              
           ,[TransTypeCode]              
           ,[TransTypeDescription]              
           ,[AdvanceReferenceNumber]              
           ,[Invoicetransactioncode]              
           ,[BusinessProcessType]              
           ,GETDATE()              
     ,0              
           ,[InvoiceNotes]              
           ,[XmlUuid]              
           ,[AdditionalData1]              
           ,[AdditionalData2]              
           ,[AdditionalData3]              
           ,[AdditionalData4]              
           ,'383'              
           ,[Language]      
     ,0      
     ,'FTP' 
	 	 ,[BankName]
	 ,[AccountName]
	 ,[AccountNumber]
	 ,[IBAN]
	 ,[SwiftCode]
from [dbo].[FileUpload_TransactionHeader] where [UniqueIdentifier] = @uuid    
  
select @irnno = SCOPE_IDENTITY()  
-----------------------------------------------              
              
              
INSERT INTO [dbo].[DraftAddress]              
           ([TenantId]              
           ,[UniqueIdentifier]              
           ,[IRNNo]              
           ,[Street]              
           ,[AdditionalStreet]              
           ,[BuildingNo]              
           ,[AdditionalNo]              
    ,[City]              
           ,[PostalCode]              
           ,[State]              
           ,[Neighbourhood]              
           ,[CountryCode]              
           ,[Type]              
           ,[CreationTime]              
           ,[IsDeleted]              
           ,[AdditionalData1]              
    ,[Language])              
              
SELECT               
      [TenantId]              
      ,NEWID()              
      ,@irnno              
      ,[Street]              
      ,[AdditionalStreet]              
      ,[BuildingNo]              
      ,[AdditionalNo]              
      ,[City]              
      ,[PostalCode]              
   ,[State]              
      ,[Neighbourhood]              
      ,[CountryCode]              
      ,[Type]              
      ,GETDATE()              
   ,0              
      ,[AdditionalData1]              
      ,[Language]              
  FROM [dbo].[FileUpload_TransactionAddress] where [UniqueIdentifier] = @uuid              
              
-------------------------------------------------             
              
INSERT INTO [dbo].[DraftParty]              
           ([TenantId]              
           ,[UniqueIdentifier]              
           ,[IRNNo]              
           ,[RegistrationName]              
           ,[VATID]              
           ,[GroupVATID]              
           ,[CRNumber]              
           ,[OtherID]              
           ,[CustomerId]              
           ,[Type]              
           ,[CreationTime]              
        ,[IsDeleted]              
           ,[AdditionalData1]              
           ,[Language]              
           ,[OtherDocumentTypeId])              
SELECT [TenantId]              
      ,NEWID()              
      ,@irnno              
      ,[RegistrationName]              
      ,[VATID]              
      ,[GroupVATID]              
      ,[CRNumber]              
      ,[OtherID]              
      ,[CustomerId]              
      ,[Type]              
      ,GetDate()              
   ,0              
      ,[AdditionalData1]              
      ,[Language]              
      ,[OtherDocumentTypeId]              
  FROM [dbo].[FileUpload_TransactionParty] where [UniqueIdentifier]=@uuid              
              
-------------------------------------------------           
INSERT INTO [dbo].[DraftContactPerson]              
           ([TenantId]              
      ,[UniqueIdentifier]              
      ,[IRNNo]              
      ,[Name]              
      ,[EmployeeCode]              
      ,[ContactNumber]              
      ,[GovtId]              
      ,[Email]              
      ,[Address]              
      ,[Location]              
      ,[Type]              
      ,[CreationTime]              
      ,[IsDeleted]              
      ,[AdditionalData1]              
      ,[Language])              
SELECT [TenantId]              
      ,NEWID()              
      ,@irnno              
      ,[Name]              
      ,[EmployeeCode]              
      ,[ContactNumber]              
      ,[GovtId]              
      ,[Email]              
      ,[Address]              
      ,[Location]              
      ,[Type]              
      ,GETDATE()              
   ,0              
      ,[AdditionalData1]              
      ,[Language]              
  FROM [dbo].[FileUpload_TransactionContactPerson] where [UniqueIdentifier]=@uuid              
              
-----------------------------------------------------------              
              
INSERT INTO [dbo].[DraftItem]              
           ([TenantId]              
           ,[UniqueIdentifier]              
           ,[IRNNo]              
           ,[Identifier]              
           ,[Name]              
           ,[Description]              
           ,[BuyerIdentifier]              
           ,[SellerIdentifier]              
           ,[StandardIdentifier]              
           ,[Quantity]              
           ,[UOM]              
           ,[UnitPrice]              
           ,[CostPrice]              
           ,[DiscountPercentage]              
           ,[DiscountAmount]              
           ,[GrossPrice]              
           ,[NetPrice]              
           ,[VATRate]              
           ,[VATCode]              
           ,[VATAmount]              
           ,[LineAmountInclusiveVAT]              
           ,[CurrencyCode]              
           ,[TaxSchemeId]              
           ,[Notes]              
           ,[ExcemptionReasonCode]              
           ,[ExcemptionReasonText]              
           ,[CreationTime]              
           ,[IsDeleted]              
           ,[AdditionalData1]              
           ,[AdditionalData2]              
           ,[Language]          
     ,[isOtherCharges])              
SELECT [TenantId]              
      ,NEWID()              
      ,@irnno              
      ,[Identifier]              
      ,[Name]              
      ,[Description]              
      ,[BuyerIdentifier]              
      ,[SellerIdentifier]              
      ,[StandardIdentifier]              
      ,[Quantity]              
    ,[UOM]              
      ,[UnitPrice]              
      ,[CostPrice]              
      ,[DiscountPercentage]              
      ,[DiscountAmount]              
      ,[GrossPrice]              
      ,[NetPrice]              
      ,[VATRate]              
      ,[VATCode]              
      ,[VATAmount]              
      ,[LineAmountInclusiveVAT]              
      ,[CurrencyCode]              
      ,[TaxSchemeId]              
      ,[Notes]              
      ,[ExcemptionReasonCode]              
      ,[ExcemptionReasonText]              
      ,GETDATE()              
   ,0              
      ,[AdditionalData1]              
      ,[AdditionalData2]              
      ,[Language]          
   ,[isOtherCharges]          
  FROM [dbo].[FileUpload_TransactionItem] where [UniqueIdentifier]=@uuid              
              
-----------------------------------------------------------              
              
INSERT INTO [dbo].[DraftSummary]              
           ([TenantId]              
           ,[UniqueIdentifier]              
           ,[IRNNo]              
           ,[NetInvoiceAmount]              
           ,[NetInvoiceAmountCurrency]              
           ,[SumOfInvoiceLineNetAmount]              
           ,[SumOfInvoiceLineNetAmountCurrency]              
           ,[TotalAmountWithoutVAT]              
           ,[TotalAmountWithoutVATCurrency]              
           ,[TotalVATAmount]             
           ,[CurrencyCode]              
           ,[TotalAmountWithVAT]              
           ,[PaidAmount]              
           ,[PaidAmountCurrency]              
           ,[PayableAmount]              
           ,[PayableAmountCurrency]              
           ,[AdvanceAmountwithoutVat]              
           ,[AdvanceVat]              
           ,[CreationTime]              
           ,[IsDeleted]              
           ,[AdditionalData1])              
SELECT [TenantId]              
      ,NEWID()              
      ,@irnno              
      ,[NetInvoiceAmount]              
      ,[NetInvoiceAmountCurrency]              
      ,[SumOfInvoiceLineNetAmount]              
      ,[SumOfInvoiceLineNetAmountCurrency]              
      ,[TotalAmountWithoutVAT]              
      ,[TotalAmountWithoutVATCurrency]              
      ,[TotalVATAmount]              
      ,[CurrencyCode]              
      ,[TotalAmountWithVAT]              
      ,[PaidAmount]              
      ,[PaidAmountCurrency]              
      ,[PayableAmount]              
      ,[PayableAmountCurrency]              
      ,[AdvanceAmountwithoutVat]              
      ,[AdvanceVat]              
      ,GETDATE()              
   ,0              
      ,[AdditionalData1]              
  FROM [dbo].[FileUpload_TransactionSummary] where [UniqueIdentifier]=@uuid            
              
  ------------------------------------------------------------------------------------------------------------            
--  INSERT INTO [dbo].[DebitNoteContactPerson]              
--           ([TenantId]              
--           ,[UniqueIdentifier]              
--           ,[IRNNo]            
--     ,CreationTime            
--     ,IsDeleted            
--     ,[ContactNumber]          
--       ,[Type])              
--SELECT [TenantId]              
--      ,NEWID()              
--      ,@irnno            
--   ,CreationTime            
--   ,0            
--   ,ContactNumber          
--   ,[Type]          
--  FROM [dbo].[FileUpload_TransactionContactPerson] where [UniqueIdentifier]=@uuid           
end
GO
