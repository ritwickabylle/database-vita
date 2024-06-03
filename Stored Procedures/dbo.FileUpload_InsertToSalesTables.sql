SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[FileUpload_InsertToSalesTables]    
(@uuid UniqueIdentifier,    
@tenantId int)    
as     
begin  
declare @irnno bigint = isnull((select max(irnno) from IRNMaster where TenantId=@tenantId),0)+1    
    
INSERT INTO [dbo].[IRNMaster]    
           ([TenantId]    
           ,[UniqueIdentifier]    
           ,[IRNNo]    
           ,[TransactionType]    
           ,[Status]    
           ,[CreationTime]    
           ,[IsDeleted])    
     VALUES    
           (@tenantId    
           ,NEWID()    
           ,@irnno    
           ,'SalesInvoice'    
           ,'Processing'    
           ,GETDATE()    
           ,0) 
insert into SalesInvoice([TenantId]    
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
,[Language])    
select     
   [TenantId]    
           ,[UniqueIdentifier]    
           ,@irnno    
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
           ,GETDATE()    
     ,0    
           ,[InvoiceNotes]    
           ,[XmlUuid]    
           ,[AdditionalData1]    
           ,[AdditionalData2]    
           ,[AdditionalData3]    
           ,[AdditionalData4]    
           ,[InvoiceTypeCode]    
           ,[Language]    
from [dbo].[FileUpload_TransactionHeader] where [UniqueIdentifier] = @uuid    
-----------------------------------------------    
    
    
INSERT INTO [dbo].[SalesInvoiceAddress]    
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
    
INSERT INTO [dbo].[SalesInvoiceParty]    
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
INSERT INTO [dbo].[SalesInvoiceContactPerson]    
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
    
INSERT INTO [dbo].[SalesInvoiceItem]    
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
    
INSERT INTO [dbo].[SalesInvoiceSummary]    
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
--  INSERT INTO [dbo].[SalesInvoiceContactPerson]    
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
