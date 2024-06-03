SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
        
       
CREATE     PROCEDURE [dbo].[InsertBatchUploadEinvocing] (              
  @json nvarchar(max)='[
  {
    "TransactionType": "381",
    "SAPDocumentNumber": "2300000017",
    "SAPDocumentDate": "23-08-2023 03:45",
    "SAPInvoiceDueDate": "22-08-2023",
    "SupplyDate": "21-08-2023",
    "SupplyEndDate": "24-08-2023",
    "PurchaseOrderID": "test full address+fr+pay meth",
    "SAPSalesOrder": "1000053200",
    "OrderPlacedBy": "",
    "PaymentMeans": "Brady - Credit Card",
    "PaymentTerms": "Credit Card",
    "OriginalQuote Number": "5665",
    "DeliveryDocumentNo": "",
    "CarrierAndService": "BEST WAY AIR - INTERNATIONAL",
    "TermsOfDelivery": "DELIVERED AT PLACE",
    "DocumentCurrencyCode": "SAR",
    "ExchangeRate": "1",
    "WeAreYourVendor": "",
    "BillingReferenceID": "",
    "Reason for Issuance of Credit/Debit Note": "",
    "Notes": "test billing external text for payer 209609 KSA_AC",
    "BankName": "The Saudi British Bank",
    "AccountName": "BRADY ARABIA MANUFACTURING COMPANY",
    "SARAccount": "003-842770-001",
    "IBAN": "SA7045000000003842770001",
    "SWIFT": "SABBSARI",
    "PayerMasterCode": "209609",
    "PayerName": "SAUDI ERICSSON COMMUNICATIONS SES/CGN/M-D. ATTIAH",
    "PayerVATNumber": "300071179800003",
    "PayerStreet": "SETEEN ST MAIAZ",
    "PayerAdditional Street": "",
    "PayerBuilding Number": "2",
    "PayerAdditional Number": "",
    "PayerCity": "RIYADH",
    "PayerPostalCode": "11423",
    "PayerPOBox": "PO-BOX-9903",
    "PayerDistrictOrNeighbourhood": "ALkhobar",
    "Payer ProvinceOrState": "ALkhobar",
    "PayerCountry Code": "SA",
    "Attn": "",
    "PayerOtherID": "",
    "PayerContactNumber": "96614785800",
    "PayerEmail": "",
    "ShipToMaster Code": "1173605",
    "ShipToName": "MOHAMMED AL-HAJRI TRADING EST.",
    "ShipToStreet": "JUBAIL HIGHWAY",
    "ShipToAdditional Street": "QATIF MAIN",
    "ShipToBuilding Number": "",
    "ShipToAdditional Number": "",
    "ShipToCity": "DAMMAM",
    "ShipToPostalCode": "32244",
    "ShipToDisctrictOrNeighbourhood": "ALkhobar",
    "ShipTo ProvinceOrState": "ALkhobar",
    "ShipToCountry Code": "SA",
    "ShipToAttn": "",
    "ShipToContactNumber": "96638373777",
    "BuyerOtherID": "",
    "DocumentlineIdentifier": "1",
    "LineOriginIndicator": "000010 Y135353",
    "PartNumberDescription": "Y135353 POSTBOX COLLECTION PLATE 138 X 211 BP2-Y",
    "UnitPrice": "289.95",
    "ListPrice": "289.95",
    "ItemUOM": "PAC",
    "ItemQuantity": "12",
    "LineAmountExclusiveVAT": "3479.4",
    "CurrencyCode": "SAR",
    "ItemFreight": "150",
    "ItemCustoms": "",
    "ItemHandling": "",
    "ItemOtherCharges": "0",
    "LineAmountExclusiveVAT+Charges": "3629.4",
    "ItemVATCode": "S",
    "ItemVATRate": "15",
    "ItemVATAmount": "544.41",
    "LineAmountInclusiveVAT": "4173.81",
    "VATExemptionReasonCode": "",
    "VATExemptionReason": "",
    "TotalNetAmount": "3629.4",
    "Freight": "150",
    "Customs": "0",
    "Handling Charges": "0",
    "Other Charges": "0",
    "TotalVATAmount": "544.41",
    "TotalAmount": "4173.81",
    "Footer": "Commercial registration nr: 2050164710 VAT nr: 311673386800003. For questions concerning the status of your account please contact our Accounts Receivable Department at +971 (4) 881 2524 or via brady.account.mea@bradycorp.com. For more information on Brady products please visit our website at www.bradyeurope.com. For our complete terms and conditions which apply to your order see www.bradyeurope.com/terms",
    "AdditionalDetails1": "",
    "AdditionalDetails2": "",
    "AdditionalDetails3": "",
    "AdditionalDetails4": "",
    "PayerCRNNumber": "45895215",
    "PayerNationalIDNumber": "5413000",
    "PayerMLSNumber": "",
    "PayerOtherNumber": "",
    "PayerIndustry": "Government",
    "PayerNaturalPerson": "Natural Person",
    "CreatedBy": "COLMANAN",
    "xml_uuid": "1a907dd8-59a3-42c9-8363-42b60be408ea"
  }
]',              
  @fileName nvarchar(max)=null,               
  @tenantId int=2139,               
  @fromDate datetime =null,               
  @toDate datetime =null,         
  @outBatchId  int = null OUTPUT         
) AS BEGIN Declare @MaxBatchId int,
@tenancyname nvarchar(max)

set @tenancyname = (select name from AbpTenants where id=@tenantId)
      
 Select               
   @MaxBatchId = isnull(max(batchId),0)               
   from               
   BatchData;              
 Declare @batchId int = @MaxBatchId + 1;              
    set @outBatchId = @batchId        
  Insert into dbo.logs               
 values               
   (              
  'Einvoicing '+@json,               
  @toDate,               
  @batchId              
   )              
                
 INSERT INTO [dbo].[BatchData] (              
   [TenantId], [BatchId], [FileName],               
   [TotalRecords], [Status], [Type],               
   [CreationTime], [IsDeleted], fromDate, toDate              
 )               
 VALUES               
   (              
  @tenantId,               
  @batchId,               
  @fileName,               
  0,               
  'Unprocessed',               
  'Sales',               
  GETDATE(),               
  0,              
  @fromDate,              
  @toDate              
   )               
                
IF(upper(@tenancyname) like 'BRADY%')  
BEGIN  
exec FileUploadSalesT1Brady  @batchId,@tenantId,@json        
END  
ELSE   
begin  
exec FileUploadSalesT1 @batchId,@tenantId,@json        
end  
end
GO
