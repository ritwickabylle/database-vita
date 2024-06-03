SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[GetSalesInvoiceData] --

@IrnNo nvarchar(10) =24, 

@tenantId int = 127,

@transtype NVARCHAR(10) = '388'

AS 


BEGIN 

Select 

  * 

from 

  IRNMaster 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId 

  IF(@transtype = '388')

  Begin

select 

  * 

from 

  SalesInvoice 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId;

Select 

  * 

from 

  SalesInvoiceItem 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId;

Select 

  * 

from 

  SalesInvoiceSummary 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId;

Select 

  * 

from 

  SalesInvoiceParty 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId and ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  SalesInvoiceAddress 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId and  ISNULL(Language,'EN')='EN';

Select * 

from 

  SalesInvoiceContactPerson 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  SalesInvoiceVATDetail 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  SalesInvoiceDiscount 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId ;

  END

  ELSE IF @transtype = '383'

  BEGIN

  select 

  * 

from 

  DebitNote 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  DebitNoteItem 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  DebitNoteSummary 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  ;

Select 

  * 

from 

  DebitNoteParty 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  DebitNoteAddress 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select * 

from 

  DebitNoteContactPerson 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  DebitNoteVATDetail 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  DebitNoteDiscount 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  ;

  END

  IF @transtype = '381'

  BEGIN

  select 

  1,[TenantId],[UniqueIdentifier],[IRNNo],[InvoiceNumber],[IssueDate],[DateOfSupply],[InvoiceCurrencyCode],[CurrencyCodeOriginatingCountry],[PurchaseOrderId],[BillingReferenceId],[ContractId],[LatestDeliveryDate],[Location],[CustomerId],[Status],[Additional_Info],[PaymentType],[PdfUrl],[QrCodeUrl],[XMLUrl],[ArchivalUrl],[PreviousInvoiceHash],[PerviousXMLHash],[XMLHash],[PdfHash],[XMLbase64],[PdfBase64],[IsArchived],[TransTypeCode],[TransTypeDescription],[AdvanceReferenceNumber],[Invoicetransactioncode],[BusinessProcessType],[InvoiceNotes],[CreationTime],[CreatorUserId],[LastModificationTime],[LastModifierUserId],[IsDeleted],[DeleterUserId],[DeletionTime],[XmlUuid],[AdditionalData1],[AdditionalData2],[AdditionalData3],[AdditionalData4],[InvoiceTypeCode],[Language]
 


from 

  CreditNote 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

     [Id],[TenantId],[UniqueIdentifier],[IRNNo],[Identifier],[Name],[Description],[BuyerIdentifier],[SellerIdentifier],[StandardIdentifier],[Quantity],[UOM],[UnitPrice],[CostPrice],[DiscountPercentage],cast([DiscountAmount] as decimal(18,2)),[GrossPrice],[NetPrice],[VATRate],[VATCode],[VATAmount],[LineAmountInclusiveVAT],[CurrencyCode],[TaxSchemeId],[Notes],[ExcemptionReasonCode],[ExcemptionReasonText],[CreationTime],[CreatorUserId],[LastModificationTime],[LastModifierUserId],[IsDeleted],[DeleterUserId],[DeletionTime],[AdditionalData1],[AdditionalData2],[Language],[isOtherCharges] 

from 

  CreditNoteItem 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  CreditNoteSummary 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  ;

Select 

  * 

from 

  CreditNoteParty 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  CreditNoteAddress 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select * 

from 

  CreditNoteContactPerson 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  CreditNoteVATDetail 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  and  ISNULL(Language,'EN')='EN';

Select 

  * 

from 

  CreditNoteDiscount 

where 

  IRNNo = @IrnNo 

  and tenantid = @tenantId  ;

  END

END
GO
