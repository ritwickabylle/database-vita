SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   Procedure [dbo].[CreateInvoiceFromDraft] -- CreateInvoiceFromDraft 2624,140             
@draftIrnno nvarchar(max)=2424,              
@tenantid int=140,            
@userid bigint=null            
as              
begin              
declare @typecode int= null            
declare @source nvarchar(max)= null            
declare @billingrefid nvarchar(100)=null            
declare @cndnamount decimal(20,2)=null            
declare @salesamount decimal(20,2)=null     
declare @currentLineAmountInclusiveVAT decimal(20,2)=null   
declare @result int = null  
declare @salesbillingrefid nvarchar(max)  
declare @salerefid nvarchar(max)  
declare @draftexchangeRate decimal(20,2) = null  
declare @salesexchangeRate decimal(20,2) = null  
  
            
set @typecode=(select InvoiceTypeCode from draft  WHERE id=@draftIrnno and tenantid=@tenantid)            
set @source=(select Source from draft  WHERE id=@draftIrnno and tenantid=@tenantid)   
set @salesbillingrefid = (select InvoiceNumber from draft where id=@draftIrnno and TenantId=@tenantid and InvoiceTypeCode = '381') 
set @salerefid = (select BillingReferenceId from draft where id=@draftIrnno and TenantId=@tenantid and InvoiceTypeCode = '388') 

  
set @currentLineAmountInclusiveVAT = (select sum(LineAmountInclusiveVAT) from DraftItem where IRNNo=@draftIrnno and TenantId=@tenantid and Identifier like '%Credit%')  
  
if( @source not in ('FTP','API'))  
begin            
if(@typecode in ('381'))    
begin            
set @billingrefid=(select isnull(BillingReferenceId,'NAN') from draft where id=@draftIrnno and TenantId=@tenantid and InvoiceTypeCode = '381' )   
end   

  
select @draftexchangeRate=isnull(exchangeRate,1)  
FROM [dbo].[Draft]           
cross apply openjson(additionaldata1)            
with            
(exchangeRate decimal(20,2) '$.exchangeRate')            
where id=@draftIrnno and TenantId=@tenantid  
  
  
select @salesexchangeRate=isnull(exchangeRate,1)  
FROM [dbo].[Draft]           
cross apply openjson(additionaldata1)            
with            
(exchangeRate decimal(20,2) '$.exchangeRate')   
where BillingReferenceId=@salesbillingrefid and TenantId=@tenantid  
    
if(@billingrefid <> 'NAN' )            
begin            
select * into #cndndata from            
(   
select di.LineAmountInclusiveVAT,d.AdditionalData1,di.LineAmountInclusiveVAT*(select isnull(exchangerate,1) from openjson(d.additionaldata1) with (exchangerate decimal(20,2) '$.exchangeRate')) as TotalCNDNAmount from DraftItem di  
inner join draft d on d.Id=di.IRNNo where d.TenantId = @tenantid and di.IRNNo  
in (select id from DRAFT where InvoiceNumber= @salesbillingrefid and isSent=1 and InvoiceTypeCode = '381' ) and di.TenantId = @tenantid and d.TenantId = @tenantid and di.IsDeleted=0           
) as t;  

select * into #salesdata from            
(            
select sum(di.LineAmountInclusiveVAT) as LineAmountInclusiveVAT,max(di.IRNNo) as Irnno from SalesInvoiceItem di            
inner join SalesInvoice d with(nolock) on di.IRNNo = d.IRNNo            
where d.IRNNo = @billingrefid and d.TenantId = @tenantid and di.TenantId=@tenantid and InvoiceTypeCode='388'           
) as s;    
      
set @cndnamount = isnull((select sum(isnull(TotalCNDNAmount,0)) from #cndndata),0) + @currentLineAmountInclusiveVAT*isnull(@draftexchangeRate,1)           
set @salesamount = (select LineAmountInclusiveVAT from #salesdata)  

if exists(select * from SalesInvoice where IRNNo = @billingrefid and TenantId = @tenantid and InvoiceTypeCode='388')
begin
	if((isnull(@cndnamount,0)) > (isnull(@salesamount,0)*isnull(@salesexchangeRate,1)))            
	begin     
	set @result = 0            
	end            
	else            
	begin            
	set @result = 1            
	end         
end
else
begin
set @result = 1
end
end


end   
if(@typecode in ('383'))            
begin           
set @result = 1            
end            
            
if( @source  in ('FTP','API'))            
begin            
set @result = 1            
end  
if(@billingrefid = 'NAN')      
begin      
set @result = 1            
end   

  
if(@typecode = '388')  
begin  
if exists(select BillingReferenceId from SalesInvoice where BillingReferenceId=@salerefid and TenantId=@tenantid)  
begin  
set @result = 0            
end  
else  
begin  
set @result = 1  
end  
end  
  
if (@result = 1)            
begin            
update draft set isSent=1  WHERE id=@draftIrnno and tenantid=@tenantid;         
update draft set CreatorUserId = @userid WHERE id=@draftIrnno and tenantid=@tenantid;         
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
if(@typecode = 388)              
begin              
---sales              
              
INSERT INTO [dbo].[SalesInvoice]              
           ([TenantId]              
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
           ,[PdfBase64]               ,[IsArchived]              
           ,[TransTypeCode]              
           ,[TransTypeDescription]              
           ,[AdvanceReferenceNumber]              
           ,[Invoicetransactioncode]              
           ,[BusinessProcessType]              
           ,[CreationTime]              
           ,[CreatorUserId]              
           ,[IsDeleted]              
           ,[InvoiceNotes]              
           ,[XmlUuid]              
           ,[AdditionalData1]              
           ,[AdditionalData2]              
           ,[AdditionalData3]              
           ,[AdditionalData4]              
           ,[InvoiceTypeCode]            
           ,[Language]          
     ,[Source],          
     [AccountName],          
     [AccountNumber],          
     [IBAN],          
     [BankName],          
     [SwiftCode])           
      SELECT               
  [TenantId]              
      ,[UniqueIdentifier]              
      ,@irnno              
      ,isnull([InvoiceNumber],'')               
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
   ,getdate()              
   ,@userid              
   ,0              
      ,[InvoiceNotes]              
      ,[XmlUuid]              
      ,[AdditionalData1]              
      ,[AdditionalData2]              
      ,[AdditionalData3]              
      ,[AdditionalData4]              
      ,[InvoiceTypeCode]              
      ,[Language]          
   ,[Source],          
   [AccountName],          
     [AccountNumber],          
     [IBAN],          
     [BankName],          
     [SwiftCode]          
               
  FROM Draft  WHERE id=@draftIrnno and tenantid=@tenantid              
              
-----------------------------------------------------              
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
          ,[Language],            
     [CreatorUserId])              
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
      ,[Language],            
   @userid            
  FROM DraftAddress  WHERE irnno=@draftIrnno and tenantid=@tenantid              
--------------------------------------------------------------------              
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
           ,[OtherDocumentTypeId],            
     [CreatorUserId])              
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
      ,[OtherDocumentTypeId] ,            
   @userid            
  FROM [dbo].draftparty  WHERE irnno=@draftIrnno and tenantid=@tenantid              
--------------------------------------------------------------------------------             
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
      ,[Language],            
   [CreatorUserId])              
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
      ,[Language],            
   @userid            
  FROM DraftContactPerson  WHERE irnno=@draftIrnno and tenantid=@tenantid                 
--------------------------------------------------------------------------------              
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
     ,[isOtherCharges],            
   [CreatorUserId])              
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
   ,[isOtherCharges],            
   @userid            
  FROM DraftItem  WHERE irnno=@draftIrnno and tenantid=@tenantid  and isdeleted=0            
--------------------------------------------------------------------------------              
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
           ,[AdditionalData1],            
   [CreatorUserId])            
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
      ,[AdditionalData1],            
   @userid            
  FROM DraftSummary  WHERE irnno=@draftIrnno and tenantid=@tenantid              
--------------------------------------------------------------------------------              
---Sales End              
end              
else if(@typecode =381)              
begin              
---Credit Start              
insert into CreditNote(              
Id,[TenantId]                  
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
,[Language],            
[CreatorUserId],          
 [AccountName],          
[AccountNumber],          
[IBAN],          
[BankName],          
[SwiftCode],      
[Source])            
select                   
NEWID(),              
   [TenantId]                  
           ,[UniqueIdentifier]                  
           ,@irnno                  
           ,isnull([InvoiceNumber],'')                  
           ,[IssueDate]                  
           ,[DateOfSupply]                  
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
           ,[InvoiceTypeCode]                  
           ,[Language] ,            
     @userid  ,          
   [AccountName],          
     [AccountNumber],          
     [IBAN],          
     [BankName],          
     [SwiftCode],      
  [Source]      
from draft  WHERE id=@draftIrnno and tenantid=@tenantid              
--------------------------------------------------------------------------------              
INSERT INTO [dbo].[CreditNoteAddress]                  
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
           ,[Language],            
     [CreatorUserId])                  
                  
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
      ,[Language],            
   @userid            
  FROM draftAddress  WHERE irnno=@draftIrnno and tenantid=@tenantid              
--------------------------------------------------------------------------------              
INSERT INTO [dbo].[CreditNoteParty]                  
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
           ,[OtherDocumentTypeId],            
     [CreatorUserId])                  
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
      ,[OtherDocumentTypeId],            
   @userid            
  FROM draftParty  WHERE irnno=@draftIrnno and tenantid=@tenantid              
--------------------------------------------------------------------------------              
INSERT INTO [dbo].[CreditNoteContactPerson]                  
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
      ,[Language],            
   [CreatorUserId])                  
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
      ,[Language],            
   @userid            
  FROM draftContactPerson  WHERE irnno=@draftIrnno and tenantid=@tenantid              
--------------------------------------------------------------------------------              
INSERT INTO [dbo].[CreditNoteItem]                  
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
     ,[isOtherCharges],            
  [CreatorUserId])                  
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
   ,[isOtherCharges],            
   @userid            
  FROM draftItem  WHERE irnno=@draftIrnno and tenantid=@tenantid and IsDeleted=0                  
                  
-----------------------------------------------------------                  
                  
INSERT INTO [dbo].[CreditNoteSummary]                  
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
           ,[AdditionalData1],            
     [CreatorUserId])                  
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
      ,[AdditionalData1],            
   @userid            
  FROM DraftSummary  WHERE irnno=@draftIrnno and tenantid=@tenantid               
--------------------------------------------------------------------------------              
---Credit end              
end              
else              
begin           
----Debit start              
insert into DebitNote([TenantId]                  
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
,[Language],            
[CreatorUserId],          
 [AccountName],          
     [AccountNumber],          
     [IBAN],          
     [BankName],          
     [SwiftCode],      
  [Source])                  
select                   
   [TenantId]                  
  ,[UniqueIdentifier]                  
           ,@irnno                  
           ,isnull([InvoiceNumber],'')                  
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
           ,[InvoiceTypeCode]                  
           ,[Language],            
     @userid,          
   [AccountName],          
     [AccountNumber],          
     [IBAN],          
     [BankName],          
     [SwiftCode] ,      
  [Source]      
from draft  WHERE id=@draftIrnno and tenantid=@tenantid              
-----------------------------------------------                  
                  
                  
INSERT INTO [dbo].[DebitNoteAddress]                  
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
           ,[Language],            
     [CreatorUserId])            
                  
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
      ,[Language],            
   @userid            
  FROM draftAddress  WHERE irnno=@draftIrnno and tenantid=@tenantid                  
                  
-------------------------------------------------                 
                  
INSERT INTO [dbo].[DebitNoteParty]                  
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
           ,[OtherDocumentTypeId]            
     ,[CreatorUserId])            
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
      ,[OtherDocumentTypeId],            
   @userid            
  FROM draftParty  WHERE irnno=@draftIrnno and tenantid=@tenantid                 
                  
-------------------------------------------------               
INSERT INTO [dbo].[DebitNoteContactPerson]                  
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
      ,[Language],            
   [CreatorUserId])            
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
      ,[Language],            
   @userid            
  FROM draftContactPerson  WHERE irnno=@draftIrnno and tenantid=@tenantid                  
                  
-----------------------------------------------------------                  
                  
INSERT INTO [dbo].[DebitNoteItem]                  
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
     ,[isOtherCharges],            
  [CreatorUserId])            
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
   ,[isOtherCharges],            
   @userid            
  FROM draftItem  WHERE irnno=@draftIrnno and tenantid=@tenantid and IsDeleted=0          
                  
-----------------------------------------------------------                  
                  
INSERT INTO [dbo].[DebitNoteSummary]                  
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
           ,[AdditionalData1],            
     [CreatorUserId])            
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
      ,[AdditionalData1],            
   @userid            
  FROM draftSummary  WHERE irnno=@draftIrnno and tenantid=@tenantid                
----Debit End              
          end              
              
end            
select @irnno as invcNo, @typecode as transType,@result as result             
end
GO
