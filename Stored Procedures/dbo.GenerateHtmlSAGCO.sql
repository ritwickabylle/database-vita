SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   Procedure [dbo].[GenerateHtmlSAGCO]
(@tenantId int null=131,                         
@isqrCode bit=0,                        
@reportName nvarchar(100)='Sales',                 
@json nvarchar(max)='{
  "IRNNo": "193",
  "InvoiceNumber": "211984",
  "IssueDate": "2023-04-17T03:00:00",
  "DateOfSupply": "2023-04-17T00:00:00Z",
  "InvoiceCurrencyCode": "USD",
  "CurrencyCodeOriginatingCountry": "SA",
  "PurchaseOrderId": "",
  "BillingReferenceId": null,
  "ContractId": null,
  "LatestDeliveryDate": "2023-04-17T00:00:00Z",
  "Location": "203",
  "CustomerId": "203",
  "Status": "OP",
  "Additional_Info": "a906a4a3-45b8-4e1e-8384-e46e8487a2c1",
  "InvoiceNotes": "RE - Stock Rotation",
  "PaymentType": "Immediate",
  "AccountName": "Saudi Arabian Glass Co.Ltd",
  "AccountNumber": "0202221184003",
  "IBAN": "SA030000000608010167519",
  "BankName": "The Saudi Investments Bank",
  "SwiftCode": "SIBCSSARIXXX",
  "BranchName": "Riyadh Branch",
  "BranchAddress": "King Abdul Aziz Road, Market Square, KSA",
  "Supplier": [
    {
      "RegistrationName": "Saudi Arabian Glass Company Ltd",
      "VATID": "300166057500003",
      "GroupVATID": null,
      "CRNumber": "7000812045",
      "OtherID": null,
      "CustomerId": null,
      "Type": "Supplier",
      "FaxNo": "+966-12-6377462",
      "Website": "www.saudi-glass.com",
      "Address": {
        "Street": "Industrial Area, Phase-4, Street No 65",
        "AdditionalStreet": "P.O.Box 17900",
        "BuildingNo": "",
        "AdditionalNo": "",
        "City": "Jeddah",
        "PostalCode": "21494",
        "State": "",
        "Neighbourhood": null,
        "CountryCode": "SA",
        "Type": "Supplier",
        "Language": "EN",
        "AdditionalData1": []
      },
      "ContactPerson": {
        "Name": null,
        "EmployeeCode": null,
        "ContactNumber": "+966-12-6364959",
        "GovtId": null,
        "Email": null,
        "Address": null,
        "Location": null,
        "Type": "Supplier",
        "Language": "EN",
        "AdditionalData1": []
      },
      "Language": "EN",
      "AdditionalData1": []
    },
    {
      "RegistrationName": "الشركة السعودية العربية للزجاج المحدودة",
      "VATID": "300166057500003",
      "GroupVATID": null,
      "CRNumber": "7000812045",
      "OtherID": null,
      "CustomerId": null,
      "Type": "ORGANIZATION",
      "FaxNo": null,
      "Website": "www.saudi-glass.com",
      "Address": {
        "Street": "المنطقة الصناعية - المرحلة الرابعة شارع رقم 65",
        "AdditionalStreet": "ص.ب. 17900 جدة 21494 المملكة العربية السعودية",
        "BuildingNo": null,
        "AdditionalNo": null,
        "City": null,
        "PostalCode": null,
        "State": null,
        "Neighbourhood": null,
        "CountryCode": null,
        "Type": null,
        "Language": "AR",
        "AdditionalData1": []
      },
      "ContactPerson": {
        "Name": null,
        "EmployeeCode": null,
        "ContactNumber": "+تيلفون: 6364959 12 966+ فاكس: 6377462 12 966",
        "GovtId": null,
        "Email": null,
        "Address": null,
        "Location": null,
        "Type": null,
        "Language": "AR",
        "AdditionalData1": []
      },
      "Language": "AR",
      "AdditionalData1": []
    }
  ],
  "Buyer": [
    {
      "RegistrationName": "Napagapa Beverages Corporation",
      "VATID": "",
      "GroupVATID": null,
      "CRNumber": "",
      "OtherID": null,
      "CustomerId": "203",
      "Type": "Buyer",
      "FaxNo": null,
      "Website": null,
      "Address": {
        "Street": "Manila",
        "AdditionalStreet": null,
        "BuildingNo": null,
        "AdditionalNo": null,
        "City": "Manila ",
        "PostalCode": null,
        "State": null,
        "Neighbourhood": null,
        "CountryCode": "PH",
        "Type": "Buyer",
        "Language": null,
        "AdditionalData1": []
      },
      "ContactPerson": {
        "Name": null,
        "EmployeeCode": null,
        "ContactNumber": null,
        "GovtId": null,
        "Email": null,
        "Address": null,
        "Location": null,
        "Type": "Buyer",
        "Language": null,
        "AdditionalData1": []
      },
      "Language": "EN",
      "AdditionalData1": []
    },
    {
      "RegistrationName": "Napagapa Beverages Corporation",
      "VATID": "",
      "GroupVATID": null,
      "CRNumber": "",
      "OtherID": null,
      "CustomerId": "203",
      "Type": "Delivery",
      "FaxNo": null,
      "Website": null,
      "Address": {
        "Street": "Manila",
        "AdditionalStreet": null,
        "BuildingNo": null,
        "AdditionalNo": null,
        "City": " ",
        "PostalCode": null,
        "State": null,
        "Neighbourhood": null,
        "CountryCode": "PH",
        "Type": "Delivery",
        "Language": null,
        "AdditionalData1": []
      },
      "ContactPerson": {
        "Name": null,
        "EmployeeCode": null,
        "ContactNumber": null,
        "GovtId": null,
        "Email": null,
        "Address": null,
        "Location": null,
        "Type": "Buyer",
        "Language": null,
        "AdditionalData1": []
      },
      "Language": "EN",
      "AdditionalData1": []
    }
  ],
  "Items": [
    {
      "Identifier": "1",
      "Name": "FG-0330-22-0001",
      "Description": "330 ml. Engkanto NRB, Amber",
      "BuyerIdentifier": "",
      "SellerIdentifier": null,
      "StandardIdentifier": null,
      "Quantity": 63580,
      "UOM": "Bottle",
      "UnitPrice": 0.1326,
      "CostPrice": 0,
      "DiscountPercentage": 0,
      "DiscountAmount": 0,
      "GrossPrice": 8430.71,
      "NetPrice": 8430.71,
      "VATRate": 0,
      "VATCode": "KSA_VAT",
      "VATAmount": 0,
      "LineAmountInclusiveVAT": 8430.71,
      "CurrencyCode": "SAR",
      "TaxSchemeId": null,
      "Notes": null,
      "ExcemptionReasonCode": null,
      "ExcemptionReasonText": null,
      "Language": null,
      "AdditionalData1": [
        {
          "descriptionAr": "330ملي أنجكانتو ن ر ب أمبر"
        }
      ],
      "AdditionalData2": [
        {
          "date_of_supply": null,
          "delivery_note_number": null
        }
      ],
      "isOtherCharges": false,
      "isDeleted": false
    },
    {
      "Identifier": "2",
      "Name": "FG-0330-22-0001",
      "Description": "330 ml. Engkanto NRB, Amber",
      "BuyerIdentifier": "",
      "SellerIdentifier": null,
      "StandardIdentifier": null,
      "Quantity": 63580,
      "UOM": "Bottle",
      "UnitPrice": 0.1326,
      "CostPrice": 0,
      "DiscountPercentage": 0,
      "DiscountAmount": 0,
      "GrossPrice": 8430.71,
      "NetPrice": 8430.71,
      "VATRate": 0,
      "VATCode": "KSA_VAT",
      "VATAmount": 0,
      "LineAmountInclusiveVAT": 8430.71,
      "CurrencyCode": "SAR",
      "TaxSchemeId": null,
      "Notes": null,
      "ExcemptionReasonCode": null,
      "ExcemptionReasonText": null,
      "Language": null,
      "AdditionalData1": [
        {
          "descriptionAr": "330ملي أنجكانتو ن ر ب أمبر"
        }
      ],
      "AdditionalData2": [
        {
          "date_of_supply": null,
          "delivery_note_number": null
        }
      ],
      "isOtherCharges": false,
      "isDeleted": false
    },
    {
      "Identifier": "3",
      "Name": "FG-0330-22-0001",
      "Description": "330 ml. Engkanto NRB, Amber",
      "BuyerIdentifier": "",
      "SellerIdentifier": null,
      "StandardIdentifier": null,
      "Quantity": 63580,
      "UOM": "Bottle",
      "UnitPrice": 0.1326,
      "CostPrice": 0,
      "DiscountPercentage": 0,
      "DiscountAmount": 0,
      "GrossPrice": 8430.71,
      "NetPrice": 8430.71,
      "VATRate": 0,
      "VATCode": "KSA_VAT",
      "VATAmount": 0,
      "LineAmountInclusiveVAT": 8430.71,
      "CurrencyCode": "SAR",
      "TaxSchemeId": null,
      "Notes": null,
      "ExcemptionReasonCode": null,
      "ExcemptionReasonText": null,
      "Language": null,
      "AdditionalData1": [
        {
          "descriptionAr": "330ملي أنجكانتو ن ر ب أمبر"
        }
      ],
      "AdditionalData2": [
        {
          "date_of_supply": null,
          "delivery_note_number": null
        }
      ],
      "isOtherCharges": false,
      "isDeleted": false
    },
    {
      "Identifier": "4",
      "Name": "FG-0330-22-0001",
      "Description": "330 ml. Engkanto NRB, Amber",
      "BuyerIdentifier": "",
      "SellerIdentifier": null,
      "StandardIdentifier": null,
      "Quantity": 63580,
      "UOM": "Bottle",
      "UnitPrice": 0.1326,
      "CostPrice": 0,
      "DiscountPercentage": 0,
      "DiscountAmount": 0,
      "GrossPrice": 8430.71,
      "NetPrice": 8430.71,
      "VATRate": 0,
      "VATCode": "KSA_VAT",
      "VATAmount": 0,
      "LineAmountInclusiveVAT": 8430.71,
      "CurrencyCode": "SAR",
      "TaxSchemeId": null,
      "Notes": null,
      "ExcemptionReasonCode": null,
      "ExcemptionReasonText": null,
      "Language": null,
      "AdditionalData1": [
        {
          "descriptionAr": "330ملي أنجكانتو ن ر ب أمبر"
        }
      ],
      "AdditionalData2": [
        {
          "date_of_supply": null,
          "delivery_note_number": null
        }
      ],
      "isOtherCharges": false,
      "isDeleted": false
    }
  ],
  "InvoiceSummary": {
    "NetInvoiceAmount": 33722.84,
    "NetInvoiceAmountCurrency": "SAR",
    "SumOfInvoiceLineNetAmount": 33722.84,
    "SumOfInvoiceLineNetAmountCurrency": "SAR",
    "TotalAmountWithoutVAT": 33722.84,
    "TotalAmountWithoutVATCurrency": "SAR",
    "TotalVATAmount": 0,
    "CurrencyCode": "SAR",
    "TotalAmountWithVAT": 33722.84,
    "PaidAmount": 0,
    "PaidAmountCurrency": "SAR",
    "PayableAmount": 33722.84,
    "PayableAmountCurrency": "SAR",
    "AdvanceAmountwithoutVat": 0,
    "AdvanceVat": 0,
    "AdditionalData1": []
  },
  "Discount": [],
  "VATDetails": [
    {
      "TaxSchemeId": "203333",
      "VATCode": "KSA_VAT",
      "VATRate": 0,
      "ExcemptionReasonCode": null,
      "ExcemptionReasonText": null,
      "TaxableAmount": 33722.84,
      "TaxAmount": 0,
      "CurrencyCode": "SAR",
      "Language": null,
      "AdditionalData1": []
    }
  ],
  "PaymentDetails": [
    {
      "PaymentMeans": "Cash",
      "CreditDebitReasonText": null,
      "PaymentTerms": "",
      "Language": null,
      "AdditionalData1": []
    }
  ],
  "InvoiceType": null,
  "InvoiceTypeCode": "388",
  "Language": null,
  "AdditionalData1": [
    {
      "exchangeRate": "3.75"
    }
  ],
  "AdditionalData2": [
    {
      "invoice_due_date": "17-APR-23",
      "export_invoice_number": " 4NG33023",
      "customer_contact": ""
    }
  ],
  "AdditionalData3": [],
  "AdditionalData4": []
}')
as
begin                             
                           
Declare @irnNo bigint                      
Declare @langtype nvarchar(200)                      
--select @irnNo=max(irnno)  from irnmaster                          
--set @langtype= (select Language from TenantConfiguration where tenantid=@tenantId and TransactionType='General');                      
Declare @invNo as nvarchar(500)= (select top 1 ClientName from AbpAuditLogs where TenantId=@tenantId and CustomData='Request Body Validation has started')                 
--Exec InsertAuditLogs  null,@invNo,'PDF Generation','PDF Generation started',@TenantId                                      
--select * from logs order by id desc                                
--set @reportName='Sales'                             
                           
declare @invoiceNumber nvarchar(200),         
@refInvoiceNumber nvarchar(200),
@invoiceDate nvarchar(200),                                           
@invoiceType nvarchar(200),                                           
@headerEnglish nvarchar(200),---SAGCO                                           
@headerArabic nvarchar(200),---SAGCO                                           
@vendorName nvarchar(200),  ---SAGCO                                         
@vendorAddress nvarchar(1000), 
@sagcoVendorAddress nvarchar(1000),---SAGCO
@sagcoContactNumber nvarchar(100),---SAGCO
@sagcolang_vendoraddress nvarchar(max),---SAGCO   
@sagcolang_vendorcontactNo nvarchar(max),    
@sagcolang_faxNo nvarchar(max),
@sagcolang_customerContactNumber nvarchar(max),

@faxNo nvarchar(1000),---SAGCO                          
@website nvarchar(1000),---SAGCO                         
@vendorVatId nvarchar(200),---SAGCO                                           
@vendorCrNumber nvarchar(200),---SAGCO                                           
@customerName nvarchar(200),                                           
@customerAddress nvarchar(1000),                                           
@customerContactNumber nvarchar(200),                                           
@customerVatId nvarchar(200),                                           
@customerEmail nvarchar(200),                                           
@customerCrNumber nvarchar(200),                                           
@itemRows nvarchar(max),                             
@chargesRows nvarchar(max),                            
@itemsfooter nvarchar(max),                            
@chargefooter nvarchar(max),                            
@totalBeforeVat decimal(15,2),                                           
@totalDiscount decimal(15,2),                      
@finalTotalBeforeDiscount decimal(15,2),                            
@totalothercharges decimal(15,2),                            
@totalotherVATcharges decimal(15,2),                        
@totalVat decimal(15,2),                                           
@totalWithVat decimal(15,2),                
@dueBalance decimal(15,2),                                           
@taxableAmountStd decimal(15,2),                                           
@taxAmountStd decimal(15,2),                                           
@totalAmountStd decimal(15,2),                                           
@taxableAmountZero decimal(15,2),                                           
@taxAmountZero decimal(15,2),                         
@totalAmountZero decimal(15,2),                            
@taxableAmountOut decimal(15,2),                                           
@taxAmountOut decimal(15,2),                        
@totalAmountOut decimal(15,2),                            
@taxableAmountExmpt decimal(15,2),                                           
@taxAmountExmpt decimal(15,2),                                           
@totalAmountExmpt decimal(15,2),                            
@referenceNumber nvarchar(50),                                    
@notes nvarchar(max),                                           
@html nvarchar(max),                                          
@rowHtml nvarchar(max),                              
@chargesrow nvarchar(max),                              
@orientation varchar(10),                              
@exchangeRate decimal(15,2),                            
@invoiceCurrencyCode nvarchar(200), 
@purchaseOrderId nvarchar(200),
@customerPo nvarchar(200),
@customerId nvarchar(200),                       
@lang_vendorbuildingNo nvarchar(max),                      
@lang_vendoradditionalBuildNo nvarchar(max),                      
@lang_vendorstreet nvarchar(max),                      
@lang_vendoradditionalStreet nvarchar(max),                      
@lang_vendorpostalcode nvarchar(max),                      
@lang_vendorcountrycode nvarchar(max),                      
@lang_vendoraddress nvarchar(max),    
@lang_faxNo nvarchar(200),   
@lang_website nvarchar(200),   
@lang_vendorName nvarchar(200),---SAGCO                      
@lang_vendorVatId nvarchar(200),                                           
@lang_vendorCrNumber nvarchar(200),                                           
@lang_customerName nvarchar(200),                         
@lang_customerId nvarchar(200),                      
@lang_customerAddress nvarchar(1000),                                                                                                                                                                        
@lang_customerCrNumber nvarchar(200),                      
@arabicdescription nvarchar(max),                    
--  if(@tenantId <> 127) --brady tenantid                            
--begin                            
--set @tenantId=9                                
--set @exchangeRate=1                            
--end                            
-- Invoice Master Details begin --                         
@tenancyname nvarchar(max),                  
@totaldiscwithVAT nvarchar(100),                                                                      
@invoiceText nvarchar(max)         
          
                      
set @tenancyname =(select name from AbpTenants where id=@tenantId)                  
if (@tenantId not in (select distinct TenantId from ReportTemplate))                  
Begin                  
set @tenantId=9                  
End                          
 select @totalBeforeVat = sum(UnitPrice * Quantity),
 @totalVat = sum(VATAmount),
 @totalWithVat=sum(LineAmountInclusiveVAT),
 @totalDiscount = sum(DiscountAmount)
 from openjson(@json,'$.Items')                                           
 with                                           
 (UnitPrice float '$.UnitPrice',                                          
 Quantity decimal(15,2) '$.Quantity',
 VATAmount decimal(15,2) '$.VATAmount',                                          
 LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',
 DiscountAmount decimal(15,2) '$.DiscountAmount',
 isOtherCharges bit '$.isOtherCharges',                
  isDeleted bit '$.isDeleted'                
 ) where isOtherCharges =0 and isnull(isDeleted,0)=0;                                 
                           
 --set @totalDiscount = @totalBeforeVat - (@totalWithVat - @totalVat);                                       
 set @finalTotalBeforeDiscount = @totalBeforeVat - @totalDiscount;                                             
 set @dueBalance  = @totalWithVat;                              
                               
 select @exchangeRate = isnull(exchangeRate,1)                             
 from openjson(@json,'$.AdditionalData1[0]')                              
 with(exchangeRate decimal(15,2) '$.exchangeRate')          
                
      
                              
--print @pdffooter   --exec generatehtml          
          
  if (@tenantId<>125)                          
begin                                        
 if(@totalWithVat<1000)                                          
 begin                                
 (select @html=Html,@orientation=orientation from ReportTemplate where TenantId = @tenantId and name=@reportName+'Simplified')  -- to be changed to -> name=@reportName+' simplified'                                         
 set @rowHtml = (select RowHtml from ReportTemplate where TenantId = @tenantId  and name=@reportName+'Simplified')                            
  set @chargesrow = (select chargesrow from ReportTemplate where TenantId = @tenantId  and name=@reportName+'Simplified')-- to be changed to -> name=@reportName+' simplified'                           
                            
 --set @invoiceNumber = '0200000'                              
 set @invoiceType = '0200000'                                          
if(@reportName like '%Sales%')                            
 begin                            
 set @headerEnglish = 'Simplified Tax Invoice'                                      
 set @headerArabic = N'فاتورة ضريبية مبسطة'                             
 end                            
 else if(@reportName like '%Credit%')                            
 begin                            
  set @headerEnglish = 'Simplified Credit Note'                                      
 set @headerArabic = N'إشعار دائن مبسط'                             
 end                            
 else                            
 begin                            
  set @headerEnglish = 'Simplified Debit Note'                                      
 set @headerArabic = N'إشعار خصم مبسط'                             
 end                                         
 end                           
 else                                          
 begin                                          
 (select @html=Html,@orientation=orientation from ReportTemplate where TenantId = @tenantId and name=@reportName)                                           
 set @rowHtml = (select RowHtml from ReportTemplate where TenantId = @tenantId  and name=@reportName)                            
 set @chargesrow = (select chargesrow from ReportTemplate where TenantId = @tenantId  and name=@reportName)                            
 --set @invoiceNumber = '0100000'                              
 set @invoiceType = '0100000'                                          
if(@reportName like '%Sales%')                            
 begin                            
 set @headerEnglish = 'Tax Invoice'                                      
 set @headerArabic = N'الفاتورة الضريبية'                             
 end                              
 else if(@reportName like '%Credit%')                            
 begin                            
  set @headerEnglish = 'Credit Note'                                      
 set @headerArabic = N'إشعار دائن'        
 end                            
 else                            
 begin                            
  set @headerEnglish = 'Debit Note'                                      
 set @headerArabic = N'إشعار مدين'                             
 end                                          
 end                               
 end                          
 else                          
 begin                          
  begin                                          
 (select @html=Html,@orientation=orientation from ReportTemplate where TenantId = @tenantId and name=@reportName)                                           
 set @rowHtml = (select RowHtml from ReportTemplate where TenantId = @tenantId  and name=@reportName)                            
 set @chargesrow = (select chargesrow from ReportTemplate where TenantId = @tenantId  and name=@reportName)                            
 --set @invoiceNumber = '0100000'                              
 set @invoiceType = '0100000'                                          
if(@reportName like '%Sales%')                            
 begin                            
 set @headerEnglish = 'Tax Invoice'                                      
 set @headerArabic = N'الفاتورة الضريبية'                             
 end                              
 else if(@reportName like '%Credit%')                            
 begin                            
  set @headerEnglish = 'Credit Note'                                      
 set @headerArabic = N'إشعار دائن'                             
 end                            
 else                            
 begin       
  set @headerEnglish = 'Debit Note'                                      
 set @headerArabic = N'إشعار مدين'                             
 end                                          
 end                               
 end                          
--------Invoice Master Details end -------------                  
                                                  
declare @billtoattention  nvarchar(200),                                
                                                 
@shiptoaddress  nvarchar(500), 
@shiptocountryCode nvarchar(max),                               
@referenceinvoiceno  nvarchar(200),                                                            
                            
@referenceinvoicenoPO  nvarchar(200), 
@sagcopaymentterms nvarchar(300),
          
@deliveryTermsDescription nvarchar(200),                                                      
@sapinvoicenumber nvarchar(200),                           
                                                                                                        
@deliverydate  nvarchar(200),                                                                
@customer2  nvarchar(200),                                
@yourvatnumber  nvarchar(200),                                
@freight  decimal(15,2),                                
@custom1  decimal(15,2),                                
@invoicetotal  decimal(15,2),                                                            
@desc1 nvarchar(200),                              
@desc2 nvarchar(200),                                                      
@invoiceRefDate nvarchar(200),                                                   
@invoiceDueDate nvarchar(200),                
@shiptoName nvarchar(200), 
@sagco_shiptoaddress nvarchar(max),
@lang_shiptoAddress nvarchar(200),                
@lang_shiptoname nvarchar(200),    

@sagco_deliverynotenumber nvarchar(200),
@sagco_dateofsupply nvarchar(200),
@sagco_exportinvoicenumber nvarchar(200),

@sagco_invoiceduedate nvarchar(200),
@sagcocustomercontact nvarchar(200),
@sagco_shiptocountry nvarchar(max)

                          
declare @accountName nvarchar(max);                          
declare @accountNumber nvarchar(max);                          
declare @iban nvarchar(max);                          
declare @nameofbank nvarchar(max);                          
declare @swiftcode nvarchar(max);                          
declare @branchName nvarchar(max);                          
declare @branchAddress nvarchar(max);                          
declare @customerCountryCode nvarchar(50)='';                              
declare @currency2 nvarchar(50)=''                   

if(UPPER(@tenancyname) LIKE 'SAUDI ARABIAN GLASS%')                      
begin
 select                     
 @sagco_shiptoaddress = isnull(sagcobuildingNo,'')+' '+                 
  isnull(sagcoadditionalno,'')+' '+                
  isnull(sagcostreet,'')+' '+                
  isnull(sagcoShiptoAdditionalStreet,'')+' '+                
  isnull(sagcocity,'')+' '+                
  isnull(sagconeighbourhood,'')+' '+                
  isnull(sagcostate,'')+' '+                
  isnull(sagcopostalCode,'')+' '+                
  isnull(sagcocountryCode,''),
  @sagco_shiptocountry= isnull(sagcocountryCode,'')
 from openjson(@json,'$.Buyer')                                           
 with                                           
 ( sagcobuildingNo nvarchar(200) '$.Address.BuildingNo',                
  sagcoadditionalno nvarchar(200) '$.Address.AdditionalNo',                
  sagcocity nvarchar(200) '$.address.City',                                
  sagconeighbourhood nvarchar(200) '$.Address.Neighbourhood',                                
  sagcostreet nvarchar(200) '$.Address.Street',                 
  sagcoShiptoAdditionalStreet nvarchar(200) '$.Address.AdditionalStreet',                
  sagcostate nvarchar(200) '$.Address.State',                                
  sagcopostalCode nvarchar(200) '$.Address.PostalCode',                                
  sagcocountryCode nvarchar(200) '$.Address.CountryCode',                         
 sagcolang nvarchar(200) '$.Language',
 sagcotype nvarchar(200) '$.Type')where (sagcolang = 'EN' or sagcolang is null) and  sagcotype <> 'Buyer' ;  
 --print @sagco_shiptoaddress
 end



  select  @shiptoaddress=isnull(buildingNo,'')+' '+                 
  isnull(additionalno,'')+' '+                
  isnull(street,'')+' '+                
  isnull(ShiptoAdditionalStreet,'')+' '+                
  isnull(city,'')+' '+                
  isnull(neighbourhood,'')+' '+                
  isnull(state,'')+' '+                
  isnull(postalCode,'')+' '+                
  isnull(countryCode,''), 
  @shiptocountryCode=isnull(countryCode,''),                          
  @customer2 = shiptocode,                     
  @yourvatnumber = yourvatnumber                    
  from openjson(@json,'$.Buyer[0].AdditionalData1[0]')                                 
  with                 
  (buildingNo nvarchar(200) '$.address.buildingNo',                
  additionalno nvarchar(200) '$.address.AdditionalNo',                
  city nvarchar(200) '$.address.city',                                
  neighbourhood nvarchar(200) '$.address.neighbourhood',                                
  street nvarchar(200) '$.address.street',                 
  ShiptoAdditionalStreet nvarchar(200) '$.address.additionalStreet',                
  state nvarchar(200) '$.address.state',                                
  postalCode nvarchar(200) '$.address.postalCode',                                
  countryCode nvarchar(200) '$.address.countryCode',                                
  contactNo nvarchar(200) '$.contactPerson.contactNumber',                                
  shiptoaccount nvarchar(200) '$.registrationName',                                                           
  shiptocode nvarchar(200) '$.crNumber',                    
  yourvatnumber nvarchar(200) '$.vatid')                                
                         
select                                           
                            
@referenceinvoiceno = billreferenceNumber,

@sagcopaymentterms=sagcopaymentterms
-- = REPLACE(customerVatNo,'VAT:','') ,                            
--@customerId = customerId                            
FROM OPENJSON(@json)                                          
  WITH (                                        
  billreferenceNumber nvarchar(50) '$.BillingReferenceId',
  sagcopaymentterms	  nvarchar(100) '$.PaymentType'
 --customer nvarchar(200) '$.Buyer.RegistrationName',                                            
 --customerVatNo nvarchar(200) '$.Buyer.VATID' ,                            
 --customerId nvarchar(200) '$.Buyer.CustomerId'                            
  )                             
                        
--  ----- Customer, Vendor, Notes begin ------------                                          
                                          
                             
select                                           
@referenceNumber = referenceNumber,                            
@invoiceCurrencyCode= invoiceCurrencyCode,
@customerPo=customerPo,

@invoiceNumber = invoiceNumber,
@refInvoiceNumber = invoiceNumber,
@invoiceDate =  cast(invoiceDate as date),                                          
@currency2 = InvoiceCurrencyCode ,                        
@notes =notes   ,        
@irnNo = irnNo        
FROM OPENJSON(@json)                                          
  WITH (                                        
  referenceNumber nvarchar(50) '$.BillingReferenceId',                            
  invoiceCurrencyCode nvarchar(50) '$.InvoiceCurrencyCode',                            
    invoiceNumber nvarchar(50) '$.InvoiceNumber',  
    invoiceDate nvarchar(50) '$.IssueDate',                                                              
 notes nvarchar(500) '$.InvoiceNotes',                              
 InvoiceCurrencyCode nvarchar(50) '$.InvoiceCurrencyCode' , 
 customerPo nvarchar(200) '$.PurchaseOrderId' ,
 irnNo nvarchar(50) '$.IRNNo'                              
  );                                          
                                 
                          
declare @showCur nvarchar(50)='display : none'                              
declare @show1 nvarchar(50)='display : none'                            
if(@currency2<>'SAR')                              
begin                              
set @showCur=''                            
set @show1='display : none'                            
end                            
else                            
begin                            
set @show1=''                            
set @showCur='display : none'                            
end                              
                               
------ Customer, Vendor, Notes end --------                       
                
---tenant dertails multilang--                      
--select @lang_vendorbuildingNo=BuildingNo,                      
--@lang_vendoradditionalBuildNo= AdditionalBuildingNumber,              
--@lang_vendorstreet=Street,@lang_vendoradditionalStreet= AdditionalStreet,@lang_vendorpostalcode=PostalCode,@lang_vendorcountrycode=CountryCode from TenantAddress where tenantid=@tenantId;                      
-- select @lang_vendoraddress = isnull(Street,'')+' '+isnull(AdditionalStreet,'')+' '+isnull(BuildingNo,'')+' '+isnull(city,'')+' '+isnull(state,'')+' '+isnull(PostalCode,'')+' '+isnull(CountryCode,'')                      
--from TenantAddress where tenantid=@tenantId and AddressType='AR'                      
--set @lang_vendoraddress=N'الأمير سعود الفيصل2652                      
-- 7490 الخالدية جدة المنطقة الغربية المملكة العربية السعودية 23422'                      
                      
set @lang_vendorName=( select LangTenancyName from TenantBasicDetails where tenantid=@tenantId)      
  
select                  
@lang_vendorName = langregistrationName,    
@lang_vendorCrNumber = langvendorCrNumber,                                          
@lang_vendorVatId = REPLACE(langvendorVatId,'VAT:',''),    
@lang_vendorAddress = isNull(langvendorBuildingNo,'')+' '                  
+isNull(langvendoradditionalnumber,'')+' '                  
+isNull(langvendorStreet,'')+' '             
+isNull(langvendorAdditonalStreet,'')+' '                  
+isNull(langvendorCity,'')+' '                  
+isNull(langvendorNeighbourhood,'')+' '                  
+isNull(langvendorState,'')+' '                  
+isNull(langvendorPostalCode,'')+' '                  
+isNull(langvendorCountryCode,'')+                  
N' تيلفون: '+isNull(langvendorContactNumber,''),
@sagcolang_vendoraddress=N'المنطقة الصناعية - المرحلة الرابعة شارع رقم 65
ص.ب. 17900 جدة 21494 المملكة العربية السعودية',
@sagcolang_customerContactNumber=concat('966-12-6364959 +',N': تيلفون'),
@sagcolang_faxNo=concat('966-12-6377462 +',N': فاكس'),
--@sagcolang_vendoraddress = isNull(langvendorBuildingNo,'')+' '                  
--+isNull(langvendoradditionalnumber,'')+' '                  
--+isNull(langvendorStreet,'')+' '             
--+isNull(langvendorAdditonalStreet,'')+' '                  
--+isNull(langvendorCity,'')+' '                  
--+isNull(langvendorNeighbourhood,'')+' '                  
--+isNull(langvendorState,'')+' '                  
--+isNull(langvendorPostalCode,'')+' '                  
--+isNull(langvendorCountryCode,''),
--@lang_customerContactNumber=isNull(langvendorContactNumber,''),
@lang_faxNo=langfaxNo,                          
@lang_website=langwebsite  
 from openjson(@json,'$.Supplier')                                           
 with                                           
(langregistrationName nvarchar(200) '$.RegistrationName',  
langvendorBuildingNo nvarchar(200) '$.Address.BuildingNo',    
langvendoradditionalnumber nvarchar(200) '$.Address.AdditionalNo',  
langvendorStreet nvarchar(200) '$.Address.Street',  
langfaxNo nvarchar(200) '$.FaxNo',                              
langwebsite nvarchar(200) '$.Website',   
langvendorAdditonalStreet nvarchar(200) '$.Address.AdditionalStreet',  
langvendorCity nvarchar(200) '$.Address.City',  
langvendorNeighbourhood nvarchar(200) '$.Address.Neighbourhood',  
langvendorState nvarchar(200) '$.Address.State',  
langvendorPostalCode nvarchar(200) '$.Address.PostalCode',  
langvendorCountryCode nvarchar(200) '$.Address.CountryCode',  
langvendorContactNumber nvarchar(200) '$.ContactPerson.ContactNumber',  
langvendorVatId nvarchar(200) '$.VATID',                         
langvendorCrNumber nvarchar(200) '$.CRNumber',   
lang nvarchar(200) '$.Language' )where lang <> 'EN';    
                      
select                                           
@vendorName = vendorName,                                          
@vendorCrNumber = vendorCrNumber,                                          
@vendorVatId = REPLACE(vendorVatId,'VAT:',''),                                          
@vendorAddress = isNull(vendorBuildingNo,'')+' '                  
+isNull(vendoradditionalnumber,'')+' '                  
+isNull(vendorStreet,'')+' '             
+isNull(vendorAdditonalStreet,'')+' '                  
+isNull(vendorCity,'')+' '                  
+isNull(vendorNeighbourhood,'')+' '                  
+isNull(vendorState,'')+' '                  
+isNull(vendorPostalCode,'')+' '                  
+isNull(vendorCountryCode,'')+                  
' Contact No: '+isNull(vendorContactNumber,''),  
@sagcoVendorAddress = isNull(vendorBuildingNo,'')+' '                  
+isNull(vendoradditionalnumber,'')+' '                  
+isNull(vendorStreet,'')+' '             
+isNull(vendorAdditonalStreet,'')+' '                  
+isNull(vendorCity,'')+' '                  
+isNull(vendorNeighbourhood,'')+' '                  
+isNull(vendorState,'')+' '                  
+isNull(vendorPostalCode,'')+' '                  
+isNull(vendorCountryCode,''),
@sagcoContactNumber = isNull(vendorContactNumber,''),
@faxNo=FaxNo,                          
@website=Website                            
 from openjson(@json,'$.Supplier')                                           
  WITH (                                        
 vendorName nvarchar(200) '$.RegistrationName',                                              
 vendorStreet nvarchar(200) '$.Address.Street' ,                                              
 vendorAdditonalStreet nvarchar(200) '$.Address.AdditionalStreet',                              
 faxNo nvarchar(200) '$.FaxNo',                              
 website nvarchar(200) '$.Website',                   
 vendoradditionalnumber nvarchar(100) '$.Address.AdditionalNo',                  
 vendorBuildingNo nvarchar(200) '$.Address.BuildingNo',                                              
    vendorCity nvarchar(200) '$.Address.City' ,                    
 vendorNeighbourhood nvarchar(100) '$.Address.Neighbourhood',                  
 vendorState nvarchar(200) '$.Address.State'  ,                                              
 vendorPostalCode nvarchar(200) '$.Address.PostalCode' ,                                              
 vendorCountryCode nvarchar(200) '$.Address.CountryCode',                                              
    vendorContactNumber nvarchar(200) '$.ContactPerson.ContactNumber' ,                                              
 vendorVatId nvarchar(200) '$.VATID',                         
 vendorCrNumber nvarchar(200) '$.CRNumber',  
  lang nvarchar(200) '$.Language' ) where (lang = 'EN' or lang is null);                   
                      
                      
 select                       
 @lang_customerName=langcustomerName,                      
 @lang_customerId =langcustomerId,                      
 @lang_customerAddress=isnull(langcustomerBuildingNo,'')+' '                   
   +isnull(langcustomerStreet,'')+' '                 
   +isnull(langcustomerAdditonalStreet,'')+' '                  
  +isnull(langcustomerCity,'')+' '                  
  +isnull(langcustomerNeighbour,'')+' '                  
  +isnull(langcustomerState,'')+' '                  
  +isnull(langcustomerPostalCode,'')+' '                  
  +isnull(langcustomerCountryCode,'')                                           
 from openjson(@json,'$.Buyer')                             
 with       
(langcustomerName nvarchar(200) '$.RegistrationName',                      
 langcustomerId nvarchar(200) '$.CustomerId',                       
 langcustomerStreet nvarchar(200) '$.Address.Street' ,                                 
 langcustomerAdditonalStreet nvarchar(200) '$.Address.AdditionalStreet',                                        
 langcustomerBuildingNo nvarchar(200) '$.Address.BuildingNo',                                          
 langcustomerCity nvarchar(200) '$.Address.City' ,                                          
 langcustomerState nvarchar(200) '$.Address.State'  ,                       
 langcustomerNeighbour nvarchar(200) '$.Address.Neighbourhood'  ,                                          
 langcustomerPostalCode nvarchar(200) '$.Address.PostalCode' ,                                          
 langcustomerCountryCode nvarchar(200) '$.Address.CountryCode',                      
 langcustomerbilltoAttn nvarchar(200) '$.ContactPerson.Name' ,                                         
 langcustomerContactNumber nvarchar(200) '$.ContactPerson.ContactNumber' ,                                        
 langcustomerVatId nvarchar(200) '$.VATID',                                          
 langcustomerCrNumber nvarchar(200) '$.CRNumber',                                          
 langcustomerEmail nvarchar(200) '$.ContactPerson.Email',                
 langcustomertype nvarchar(200) '$.Type',                        
 lang nvarchar(200) '$.Language' )where lang <> 'EN' and langcustomertype = 'Buyer' ;                            
                       
            
 select                       
@customerAddress=isnull(customerBuildingNo,'')+' '+                    
isnull(customerAdditionalNo,'')+' '+                  
isnull(customerStreet,'')+' '+                  
  isnull(customerAdditonalStreet,'')+' '+                  
  isnull(customerCity,'')+' '+                  
  isnull(customerNeighbour,'')+' '+                  
  isnull(customerState,'')+' '+                  
  isnull(customerPostalCode,'')+' '+                  
  isnull(customerCountryCode,''),                
                
                  
  @customerContactNumber=customerContactNumber,                                
  @customerEmail = customerEmail,                      
  @customerName = customerName,                                           
  @customerVatId=customerVatId,                      
  @billtoattention=isnull(billtoAttn,billtoAttnftp),                    
  @customerId = customerId,                    
  @customerCountryCode=customerCountryCode                    
 from openjson(@json,'$.Buyer')                                           
 with                                           
 ( customerName nvarchar(200) '$.RegistrationName',                            
 customerId nvarchar(200) '$.CustomerId',                           
 customerStreet nvarchar(200) '$.Address.Street' ,                                     
 customerAdditonalStreet nvarchar(200) '$.Address.AdditionalStreet',                                            
 customerBuildingNo nvarchar(200) '$.Address.BuildingNo',                   
 customerAdditionalNo nvarchar(200) '$.Address.AdditionalNo',                  
 customerCity nvarchar(200) '$.Address.City' ,                                              
 customerState nvarchar(200) '$.Address.State'  ,                           
  customerNeighbour nvarchar(200) '$.Address.Neighbourhood'  ,                                              
 customerPostalCode nvarchar(200) '$.Address.PostalCode' ,                                              
 customerCountryCode nvarchar(200) '$.Address.CountryCode',                          
 billtoAttn nvarchar(200) '$.ContactPerson.Name' ,                  
 billtoAttnftp nvarchar(200) '$.ContactPerson.ShipToAttn' ,                  
 customerContactNumber nvarchar(200) '$.ContactPerson.ContactNumber' ,                                              
 customerVatId nvarchar(200) '$.VATID',                    
 customerCrNumber nvarchar(200) '$.CRNumber',                                              
 customerEmail nvarchar(200) '$.ContactPerson.Email',                          
 customertype nvarchar(200) '$.Type',                 
 lang nvarchar(200) '$.Language' )where (lang = 'EN' or lang is null) and  customertype = 'Buyer' ;                  
                 
  select                     
  @shiptoName = shiptoName                    
 from openjson(@json,'$.Buyer')                                           
 with                                           
 ( shiptoName nvarchar(200) '$.RegistrationName',                                      
 customertype nvarchar(200) '$.Type',                        
 lang nvarchar(200) '$.Language' )where (lang = 'EN' or lang is null) and  customertype = 'Delivery' ;                 
                
  select                  
  @lang_shiptoname = langcustomerName,                
  @lang_shiptoAddress=isnull(langcustomerBuildingNo,'')+' '+                                    
  isnull(langcustomerCity,'')+' '                  
  +isnull(langcustomerNeighbour,'')+' '             
  +isnull(langcustomerStreet,'')+' '                  
  +isnull(langcustomerAdditonalStreet,'')+' '                  
  +isnull(langcustomerState,'')+' '                  
  +isnull(langcustomerPostalCode,'')+' '                  
  +isnull(langcustomerCountryCode,'')                    
 from openjson(@json,'$.Buyer')                                           
 with                                           
(langcustomerName nvarchar(200) '$.RegistrationName',                      
 langcustomerId nvarchar(200) '$.CustomerId',                       
 langcustomerStreet nvarchar(200) '$.Address.Street' ,                                 
 langcustomerAdditonalStreet nvarchar(200) '$.Address.AdditionalStreet',                                        
 langcustomerBuildingNo nvarchar(200) '$.Address.BuildingNo',                                          
 langcustomerCity nvarchar(200) '$.Address.City' ,                                          
 langcustomerState nvarchar(200) '$.Address.State'  ,                       
 langcustomerNeighbour nvarchar(200) '$.Address.Neighbourhood'  ,                                          
 langcustomerPostalCode nvarchar(200) '$.Address.PostalCode' ,                                          
 langcustomerCountryCode nvarchar(200) '$.Address.CountryCode',                      
 langcustomerbilltoAttn nvarchar(200) '$.ContactPerson.Name' ,                                         
 langcustomerContactNumber nvarchar(200) '$.ContactPerson.ContactNumber' ,                                        
 langcustomerVatId nvarchar(200) '$.VATID',                                          
 langcustomerCrNumber nvarchar(200) '$.CRNumber',                                          
 langcustomerEmail nvarchar(200) '$.ContactPerson.Email',                
 langcustomertype nvarchar(200) '$.Type',                        
 lang nvarchar(200) '$.Language' )where lang <> 'EN' and langcustomertype = 'Delivery' ;                  
   
declare @sagco_isexport nvarchar(100)='' --SAGCO
IF (@customerCountryCode LIKE 'SA')
BEGIN
    IF (@sagco_shiptocountry <> 'SA' AND @sagco_shiptocountry NOT LIKE 'Saudi Arabia')
    BEGIN
        SET @invoiceType = STUFF(@invoiceType, 5, 1, '1')
    END
   ELSE
    BEGIN
        SET @invoiceType = STUFF(@invoiceType, 5, 1, '0')                           

    END
END
ELSE
BEGIN
        IF (@sagco_shiptocountry <> 'SA' AND @sagco_shiptocountry NOT LIKE 'Saudi Arabia')
    BEGIN
        SET @invoiceType = STUFF(@invoiceType, 5, 1, '1')
		set @sagco_isexport=''-- Used to replace the 5th character of @invoiceType
    END
    ELSE
    BEGIN
        SET @invoiceType = STUFF(@invoiceType, 5, 1, '0')
		set @sagco_isexport ='display : none;'                            
    END
END

 IF(@invoiceCurrencyCode <>'SAR')
	BEGIN 
            set @sagco_isexport=''-- Used to replace the 5th character of @invoiceType                        
        END
	ELSE
	BEGIN
            set @sagco_isexport ='display : none;'                            
	END


                      
select @freight= case when val1='' then '0' else val1 end,     @custom1=case when val2='' then '0' else val2 end,         @invoicetotal= isNull(totalOther,0) + @totalWithVat,     @desc1 = desc1,     @desc2 = desc2                        
                
from openjson(@json,'$.InvoiceSummary.AdditionalData1[0]')                        
with(val1 nvarchar(200) '$.val1',val2 nvarchar(200) '$.val2',totalOther decimal(15,2) '$.totalOther',desc1 nvarchar(200) '$.desc1',desc2 nvarchar(200) '$.desc2')                            
declare @showFreight nvarchar(50)=''                               
if(cast(@freight as nvarchar)<>'0.00')                              
begin                              
set @showFreight='display : none'                              
end                            
else                            
begin                            
set @showFreight='display : none'    --exec generatehtml                        
end                         
                        
declare @isqrCodedisplay nvarchar(300) = 'width: 100px; height: 100px; float: initial; vertical-align: top; margin: 0px 50px;'                      
declare @isqrCodedisplay1 nvarchar(300) = 'width: 150px;height: 150px;display: block;margin-left: auto;margin-right: auto;margin-top: 20px;padding-top: 2%;'  -- for tenant 131                      
                      
if(@isqrCode = 1)                        
begin                              
set @isqrCodedisplay='width: 100px; height: 100px; float: initial; vertical-align: top; margin: 0px 50px;display : none;'                      
set @isqrCodedisplay1 = 'width: 150px;height: 150px;display: block;margin-left: auto;margin-right: auto;margin-top: 20px;padding-top: 2%;display : none;'                   
set @invoiceText='Draft Fee Number'                
                      
end                            
else                            
begin                            
set @isqrCodedisplay='width: 100px; height: 100px; float: initial; vertical-align: top; margin: 0px 50px;'                      
set @isqrCodedisplay1 = 'width: 150px;height: 150px;display: block;margin-left: auto;margin-right: auto;margin-top: 20px;padding-top: 2%;'                      
if(@reportName like '%Sales%')                            
begin                
set @invoiceText='Invoice Number'                
end                
else if(@reportName like '%Credit%')                 
begin                
set @invoiceText='Credit Note Number'                
end                
else if(@reportName like '%Debit%')                            
begin                
set @invoiceText='Debit Note Number'                
end                
                
end                         
                            
                            
declare @showCustom nvarchar(50)=''                               
if(cast(@custom1 as nvarchar)<>'0.00')                              
begin                              
set @showCustom=''                              
end                            
else                            
begin                            
set @showCustom='display : none'                            
end                            
                            
declare @showTotal nvarchar(50)=''                               
if(cast(@freight as nvarchar)<>'0.00' or cast(@custom1 as nvarchar)<>'0.00')                              
begin                              
set @showTotal=''                              
end                            
else                            
begin                            
set @showTotal='display : none'                            
end                            
                           
                           
    select                                                                                       
              
                           
 --@referenceinvoiceno=billreferenceNumber,                                                       
 @referenceinvoicenoPO=purchaseOrderNo,                                           
 @sapinvoicenumber=sapinvoicenumber,                       
                        
@deliveryTermsDescription=deliveryTermsDescription,                                                                    
@deliverydate=dueDate,                            
                                                            
@invoiceRefDate=invoiceRefDate,                                                    
@invoiceDueDate=invoiceDueDate,

@sagco_exportinvoicenumber=sagcoexportinvoicenumber,
@sagco_invoiceduedate=sagcoinvoiceDueDate,
@sagcocustomercontact=sagcocustomercontact
  from openjson(@json,'$.AdditionalData2[0]')                                 
  with                                
  (bankInformation nvarchar(200) '$.bank_information',                                                     
  purchaseOrderNo nvarchar(200) '$.purchase_order_no',                              
  orderPlacedBy nvarchar(200) '$.order_placed_by',                              
  dueDate nvarchar(200) '$.invoice_due_date',  
  debitMemoDueDate nvarchar(200)  '$.dn_due_date',
  originalQuoteNum nvarchar(200) '$.original_quote_number',                                    
  sapinvoicenumber nvarchar(200) '$.sap_invoice_number' ,                                  
  sapdnnumber nvarchar(200)  '$.sap_dn_number',          
  sapdndate nvarchar(200)  '$.sap_dn_date',                
  termsOfDelivery nvarchar(200) '$.terms_of_delivery',             
  deliveryTermsDescription nvarchar(200) '$.delivery_terms_description',                                             
  carrier nvarchar(200) '$.carrier_and_services',                              
  deliveryDocumentNo nvarchar(200) '$.delivery_document_no',                                                
  purchaseOrderNo nvarchar(200) '$.purchase_order_no',                              
  deliveryDate nvarchar(200) '$.delivery_date',                            
  invoiceRefDate nvarchar(200) '$.invoice_reference_date' ,                                                 
--  customerPo nvarchar(200) '$.customer_Po', --
  invoiceDueDate nvarchar(200) '$.due_date',
  sagcoinvoiceDueDate nvarchar(200) '$.invoice_due_date',  
  sagcoexportinvoicenumber nvarchar(200) '$.export_invoice_number', 
    sagcocustomercontact nvarchar(200) '$.customer_contact',
  sap_cn_number nvarchar(200) '$.sap_cn_number'    
  )                                     
--print @deliverydate 

if (len(isnull(@deliverydate,'')) = 0)                  
begin                  
set @totaldiscwithVAT = 'Total with VAT'                                                                   
end                  
else                  
begin                  
set @totaldiscwithVAT = 'Total with VAT (To be paid before ' + CONVERT(VARCHAR(10), @deliverydate, 101) + ')'                  
end                                
  ----------------------                              
                      
        
------------------------------------------------                                
                                                           
------ VAT summary begin --------                                          
 select                                           
 @totalAmountStd = sum(LineAmountInclusiveVAT),                                           
 @taxAmountStd = sum(VATAmount),                              
 @taxableAmountStd=sum(NetPrice)                                           
 from openjson(@json,'$.Items')                                           
 with                                           
 (LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',                                          
 VATAmount decimal(15,2) '$.VATAmount',                                          
 NetPrice decimal(15,2) '$.NetPrice',
 Quantity decimal(15,2) '$.Quantity',
 VATCode nvarchar(50) '$.VATCode',  
 isDeleted bit '$.isDeleted',
isOtherCharges bit '$.isOtherCharges') where VATCode='S' and isnull(isDeleted,0)=0 and isnull(isOtherCharges,0)=0;

 select                                           
 @totalAmountZero = sum(LineAmountInclusiveVAT),                                                                            
 @taxAmountZero = sum(VATAmount),                                           
 @taxableAmountZero=sum(NetPrice)                                 
 from openjson(@json,'$.Items')                                           
 with                
 (LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',                                          
 VATAmount decimal(15,2) '$.VATAmount',                                          
 NetPrice decimal(15,2) '$.NetPrice',                                          
  VATCode nvarchar(50) '$.VATCode',                
    isDeleted bit '$.isDeleted',
isOtherCharges bit '$.isOtherCharges') where VATCode='Z' and isnull(isDeleted,0)=0 and isnull(isOtherCharges,0)=0; 
        
   select                                           
 @totalAmountOut = sum(LineAmountInclusiveVAT),                                           
 @taxAmountOut = sum(VATAmount),                                           
 @taxableAmountOut=sum(NetPrice)                                           
 from openjson(@json,'$.Items')                                           
 with                                           
 (LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',                                          
 VATAmount decimal(15,2) '$.VATAmount',                                          
 NetPrice decimal(15,2) '$.NetPrice',                                          
  VATCode nvarchar(50) '$.VATCode',                
    isDeleted bit '$.isDeleted',
isOtherCharges bit '$.isOtherCharges') where VATCode='O' and isnull(isDeleted,0)=0 and isnull(isOtherCharges,0)=0; 
                            
   select                                           
 @totalAmountExmpt = sum(LineAmountInclusiveVAT),                                           
 @taxAmountExmpt = sum(VATAmount),                                           
 @taxableAmountExmpt=sum(NetPrice)                                           
 from openjson(@json,'$.Items')                                           
 with                                           
 (LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',                                          
 VATAmount decimal(15,2) '$.VATAmount',                                          
 NetPrice decimal(15,2) '$.NetPrice',                                          
  VATCode nvarchar(50) '$.VATCode',                
    isDeleted bit '$.isDeleted',
isOtherCharges bit '$.isOtherCharges') where VATCode='E' and isnull(isDeleted,0)=0 and isnull(isOtherCharges,0)=0; 
                            
  -- VAT summary end --                                          
             ---bank details---  generatehtml              
select                        
@accountName = accountName,                            
@accountNumber= accountNumber,                            
@iban = iban,                                          
@swiftcode =  swiftcode,                                          
@nameofbank = nameofbank  ,
@branchName  = branchName,
@branchAddress = branchAddress
FROM OPENJSON(@json)                                          
  WITH (                                        
  accountName nvarchar(200) '$.AccountName',                            
  accountNumber nvarchar(200) '$.AccountNumber',                            
    iban nvarchar(200) '$.IBAN',                                          
    swiftcode nvarchar(200) '$.SwiftCode',
	branchName nvarchar(200) '$.BranchName',
	branchAddress nvarchar(200) '$.BranchAddress',
 nameofbank nvarchar(200) '$.BankName'                             
  );                  
            
select                                           
Sum(Quantity) as Quantity,                                          
Sum(UnitPrice) as UnitPrice,                                          
Sum(DiscountAmount) as DiscountAmount,                                          
Sum(NetPrice) as TaxableAmount,        --generatehtml                                  
Sum(VATAmount) as VATAmount,                                          
Sum(LineAmountInclusiveVAT) as LineAmountInclusiveVAT                                          
INTO #itemsfooter                                          
 from openjson(@json,'$.Items')                                           
 with                                           
 (Description nvarchar(max) '$.Description',                                
 Quantity decimal(15,2) '$.Quantity',                                          
 UnitPrice float '$.UnitPrice',      
  NetPrice decimal(15,2) '$.NetPrice', 
 DiscountPercentage decimal(15,2) '$.DiscountPercentage',                                          
 DiscountAmount decimal(15,2) '$.DiscountAmount',                                          
 VATAmount decimal(15,2) '$.VATAmount',                               
  LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',                                          
 LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',                                          
 VATRate decimal(15,2) '$.VATRate',                          
  isOtherCharges bit '$.isOtherCharges',                
  isDeleted bit '$.isDeleted') where isOtherCharges = 0 and isnull(isDeleted,0)=0  ; 
  
    ---/////////////////////////----                      
  -- dynamic item row generation begin --                                          
select                               
identity(int,1,1) as Id,                            
Name as Name,                            
Description as Description,                                          
Quantity as Quantity,                                          
UnitPrice as UnitPrice,                                          
DiscountAmount as DiscountAmount,                                          
NetPrice as TaxableAmount,                            
VATCode as VATCode,                            
VATRate as VATRate,                                          
VATAmount as VATAmount,                                          
Identifier as Identifier,                                          
uom as uom,                                          
LineAmountInclusiveVAT as LineAmountInclusiveVAT,                            
ExemptionReason as ExemptionReason,                            
ExemptionReasonCode as ExemptionReasonCode,                            
isOtherCharges as isOtherCharges,                            
isDeleted as isDeleted,
ArbicDescription as ArbicDescription,
deliverynotenumber as deliverynotenumber,
dateofsupply as dateofsupply
INTO #items                                          
 from openjson(@json,'$.Items')                                           
 with                                           
 (Description nvarchar(max) '$.Description',
 Name nvarchar(max) '$.Name',                            
 Quantity decimal(15,2) '$.Quantity',                                       
 UnitPrice float '$.UnitPrice', 
 NetPrice decimal(15,2) '$.NetPrice', 
 DiscountPercentage decimal(15,2) '$.DiscountPercentage',                                          
 DiscountAmount decimal(15,2) '$.DiscountAmount',                          
 VATAmount decimal(15,2) '$.VATAmount',                                          
 LineAmountInclusiveVAT decimal(15,2) '$.LineAmountInclusiveVAT',                            
 VATCode nvarchar(max) '$.VATCode',                            
 VATRate decimal(15,2) '$.VATRate',                                          
 Identifier varchar(100) '$.Identifier',                                
 ExemptionReasonCode nvarchar(100) '$.ExcemptionReasonCode',                            
 ExemptionReason nvarchar(100) '$.ExcemptionReasonText',                            
 uom nvarchar(100) '$.UOM',                            
 isOtherCharges bit '$.isOtherCharges',
 ArbicDescription nvarchar(max) '$.AdditionalData1[0].descriptionAr',
 deliverynotenumber nvarchar(max) '$.AdditionalData2[0].delivery_note_number',
 dateofsupply nvarchar(max) '$.AdditionalData2[0].date_of_supply',
 isDeleted bit '$.isDeleted' ) where  isnull(isDeleted,0)=0 ;                                          
                                  
                                          
 ------------------                                          
 set @itemRows= ''                                          
 declare                                           
 @Id int,                            
 @Name nvarchar(max),                            
 @Description nvarchar(max),                                          
 @Quantity int,                                          
 @unit nvarchar(max),                                          
 @UnitPrice float,                                          
 @DiscountAmount decimal(15,2),                                          
 @TaxableAmount decimal(15,2),                             
 @VATCode nvarchar(max),                            
 @VATRate decimal(15,2),                                       
 @VATAmount decimal(15,2),                              
 @LineAmountInclusiveVATCurr decimal(15,2),                              
 @LineAmountInclusiveVAT decimal(15,2),                                          
 @Identifier varchar(100),                                          
 @uom varchar(100),                            
 @ExemptionReasonCode nvarchar(max),                            
 @ExemptionReason nvarchar(max),                            
 @totalrows int = (select count(*) from #items where isOtherCharges=0 and isnull(isDeleted,0)=0),                                           
 @currentrow int = 0
                                              
--select * from #items-- where isOtherCharges=0 and isnull(isDeleted,0)=0;                            
                            
    while @currentrow <  @totalrows                                            
    begin                                           
        select                                           
  @Id=Id,                            
  @Name=Name,                            
  @Description=Description,                                          
  @Quantity=Quantity,                                          
  @UnitPrice=UnitPrice,                                          
  @DiscountAmount = DiscountAmount,                                          
  @TaxableAmount= TaxableAmount,                                          
  @VATRate = VATRate,                              
  @VATCode=VATCode,                            
  @VATAmount = VATAmount,                                          
  @Identifier = Identifier,                              
  @LineAmountInclusiveVATCurr = LineAmountInclusiveVAT ,                              
  @LineAmountInclusiveVAT = LineAmountInclusiveVAT ,                            
  @ExemptionReason= ExemptionReason,                            
  @ExemptionReasonCode = ExemptionReasonCode,                            
  @uom = uom,
  @arabicdescription=isnull(ArbicDescription,''),
  @sagco_dateofsupply=dateofsupply,
  @sagco_deliverynotenumber=deliverynotenumber
  from #items                                           
  where Id = @currentrow + 1 and isOtherCharges = 0 and isnull(isDeleted,0)=0;                            
declare @itemsfooterstyle nvarchar(200) 
                            
declare @showreason nvarchar(50)='display : none'                            
if(@VATCode <> 'S')                            
begin                            
set @showreason=''                  
end                             
set @itemRows=@itemRows+' '+@rowHtml                                          
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@Slno',@Id)                          
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@Id',@Name)                                          
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@invoiceDate',cast(@invoiceDate as date))                                          
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@invoiceNumber',@irnNo)                               
--set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@DescriptionArabic',N'زجاجة - 225 مل')                            
                            
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@Description',@Description)                                          
if(UPPER(@tenancyname) LIKE 'SAUDI ARABIAN GLASS%')                      
begin                      
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@ItemIdentifier',@Identifier)
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@arabicdescription',@arabicdescription)      
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@sagco_dateofsupply',@sagco_dateofsupply) 
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@sagco_deliverynotenumber',@sagco_deliverynotenumber) 

set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@Quantity',@Quantity) --SAGCO                      
end                      
else                      
begin                      
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@Quantity',concat(Concat(@Quantity,'  '),@uom))                      
end                      
--set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@Quantity',concat(Concat(@Quantity,'  '),@uom))                          
--set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@Quantity',@Quantity) --SAGCO                      
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@profQuantity',@Quantity)  

set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@unitprice',cast (@UnitPrice as float))

set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@exemption',concat(Concat(@ExemptionReasonCode,':'),@ExemptionReason))                                          
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@unit',@uom)                            
set @itemRows = [dbo].ReplaceHtmlDecimal(@itemRows,'@DiscountAmount',@DiscountAmount )                                          
set @itemRows = [dbo].ReplaceHtmlDecimal(@itemRows,'@TaxableAmount',@TaxableAmount)                                          
set @itemRows = [dbo].ReplaceHtmlDecimal(@itemRows,'@VATRate',@VATRate)                                          
set @itemRows = [dbo].ReplaceHtmlDecimal(@itemRows,'@VATAmount',@VATAmount )                             
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@showreason',@showreason)                            
set @itemRows = [dbo].ReplaceHtmlDecimal(@itemRows,'@LineAmountInclusiveVATCur',cast(@LineAmountInclusiveVAT  as decimal(15,2)))                              
set @itemRows = [dbo].ReplaceHtmlDecimal(@itemRows,'@LineAmountInclusiveVAT',@LineAmountInclusiveVAT )                             
set @itemRows = [dbo].ReplaceHtmlString(@itemRows,'@itemsfooterstyle','')                  
set @currentrow = @currentrow +1  
end                                            
  -- dynamic item row generation end --                                
     ----othercharge                            
   declare @chargefooterstyle nvarchar(200)                            
   set @chargesRows= ''                                          
 declare                            
 @CId int,                            
 @chargename nvarchar(max),                            
 @chargedescription nvarchar(max),                                                    
 @chargeAmount decimal(15,2),                                          
 @totalchargerows int = (select max(Id) from #items where isOtherCharges=1 and isnull(isDeleted,0)=0),                                           
 @currentchargerow int = (select top 1 Id from #items where isOtherCharges=1 and isnull(isDeleted,0)=0)                                         
                            
                                    
while @currentchargerow <=  @totalchargerows                            
    begin                                           
        select                               
    @CId=Id,                            
  @chargename=Name,                            
  @chargedescription=Description,                                          
  @chargeAmount=UnitPrice                                               
  from #items                                           
  where  Id = @currentchargerow  and isOtherCharges =1;                            
                      
set @chargesRows=@chargesRows+' '+ @chargesrow                            
set @chargesRows = [dbo].ReplaceHtmlString(@chargesRows,'@chargename',@chargename)                                          
set @chargesRows = [dbo].ReplaceHtmlString(@chargesRows,'@chargedescription',@chargedescription)                                  
set @chargesRows = [dbo].ReplaceHtmlDecimal(@chargesRows,'@chargeAmount',@chargeAmount)                              
set @chargesRows = [dbo].ReplaceHtmlString(@chargesRows,'@chargefooterstyle','')                              
                            
set @currentchargerow = @currentchargerow +1                            
end                            
set @itemsfooter= ''                                          
                     
  ---footer---                              
                
 -------------------------------                                  
                
while @currentrow =  @totalrows                                            
begin                                     
select                                           
@Quantity=Quantity,                                          
@UnitPrice=UnitPrice,                                          
@DiscountAmount = DiscountAmount,                                          
@TaxableAmount= TaxableAmount,                                          
@VATAmount = VATAmount,                                       
@LineAmountInclusiveVAT = LineAmountInclusiveVAT                                           
from #itemsfooter                                           
set @currentrow = @currentrow +1                                       
set @html =[dbo].ReplaceHtmlDecimal(@html,'@SAGCOTaxableAmount',@TaxableAmount )                
set @html =[dbo].ReplaceHtmlDecimal(@html,'@SAGCOVATAmount',@VATAmount )                 
set @html =[dbo].ReplaceHtmlDecimal(@html,'@SAGCOLineAmountInclusiveVAT',@LineAmountInclusiveVAT )                
declare @amountinwords nvarchar(max);         
set @amountinwords=(SELECT NumberInEnglish=dbo.fnDecimalToWords ( cast(@LineAmountInclusiveVAT as  decimal(15,2))))                
set @html =[dbo].ReplaceHtmlString(@html,'@AmountinWords',@amountinwords)                                 
end                 

print @LineAmountInclusiveVAT
                
declare @otherchargecount int = (select count(*) from #items where isOtherCharges=1 and isnull(isDeleted,0)=0)                            
declare @showother nvarchar(50)=''                            
if(@otherchargecount = 0)                            
begin                            
set @showother='display : none'                            
set @totalotherVATcharges = 0.00                            
set @totalothercharges = 0.00                            
                            
end                            
else                            
begin 
declare @vatcal decimal(15,2)
set @totalothercharges = (select sum(UnitPrice  ) from #items where isOtherCharges=1 and isnull(isDeleted,0)=0)     
set @vatcal = (select sum(VATAmount) from #items where isOtherCharges=1 and isnull(isDeleted,0)=0)  
if(@totalVat <> '0.00')                            
begin                            
set @totalotherVATcharges = @vatcal                      
end                            
else                            
begin                            
set @totalotherVATcharges = 0.00                            
end                            
end                   
                  
 --charge footer--           
                                    
while @currentchargerow - 1 =  @totalchargerows                               
begin                              
set @chargefooterstyle= 'font-weight: bold;'                                          
set @chargesRows=@chargesRows+' '+ @chargesrow                            
set @chargesRows = [dbo].ReplaceHtmlString(@chargesRows,'@chargename','Total Other Charges')                                          
set @chargesRows = [dbo].ReplaceHtmlString(@chargesRows,'@chargedescription','')                                
set @chargesRows = [dbo].ReplaceHtmlDecimal(@chargesRows,'@chargeAmount',@totalothercharges)                            
set @chargesRows = [dbo].ReplaceHtmlString(@chargesRows,'@chargefooterstyle',@chargefooterstyle)                              
set @currentchargerow = @currentchargerow +1                            
end                                            
                                          
set @html = [dbo].ReplaceHtmlString(@html,'@referenceNumber', @referenceNumber)                               
set @html = [dbo].ReplaceHtmlString(@html,'@invoiceCurrencyCode', @invoiceCurrencyCode)      
set @html = [dbo].ReplaceHtmlString(@html,'@customerPo', @customerPo) 
set @html = [dbo].ReplaceHtmlString(@html,'@invoiceNumber', @invoiceNumber)  
set @html = [dbo].ReplaceHtmlString(@html,'@irnNo', @irnNo)  

set @html = [dbo].ReplaceHtmlString(@html,'@refInvoiceNumber', @refInvoiceNumber)                                               
------------------------------------------------------------------------------------------------------------------------------------------  
set @html = [dbo].ReplaceHtmlString(@html,'@invoiceDate',CONVERT(VARCHAR(10), isnull(@invoiceRefDate,@invoiceDate), 101))      
 
      
set @html = [dbo].ReplaceHtmlString(@html,'@invoiceType',@invoiceType)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@headerEnglish',@headerEnglish)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@headerArabic',@headerArabic)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@vendorName',@vendorName)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@vendorAddress',@vendorAddress)    
set @html = [dbo].ReplaceHtmlString(@html,'@sagcoVendorAddress',@sagcoVendorAddress)                           
set @html = [dbo].ReplaceHtmlString(@html,'@sagcoContactNumber',@sagcoContactNumber)     
set @html = [dbo].ReplaceHtmlString(@html,'@sagcolang_vendorcontactNo',@sagcolang_vendorcontactNo)                           
set @html = [dbo].ReplaceHtmlString(@html,'@sagcolang_vendoraddress',@sagcolang_vendoraddress)
set @html = [dbo].ReplaceHtmlString(@html,'@sagcolang_customerContactNumber',@sagcolang_customerContactNumber)                           
set @html = [dbo].ReplaceHtmlString(@html,'@sagcolang_faxNo',@sagcolang_faxNo)                           



set @html = [dbo].ReplaceHtmlString(@html,'@faxNo',@faxNo)                           
set @html = [dbo].ReplaceHtmlString(@html,'@website',@website)                           
set @html = [dbo].ReplaceHtmlString(@html,'@vendorVatId',@vendorVatId)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@vendorCrNumber',@vendorCrNumber)       
  
set @html = [dbo].ReplaceHtmlString(@html,'@lang_vendorName',@lang_vendorName)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@lang_vendorAddress',@lang_vendorAddress)                           
set @html = [dbo].ReplaceHtmlString(@html,'@lang_faxNo',@lang_faxNo)                           
set @html = [dbo].ReplaceHtmlString(@html,'@lang_website',@lang_website)                           
set @html = [dbo].ReplaceHtmlString(@html,'@lang_vendorVatId',@lang_vendorVatId)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@lang_vendorCrNumber',@lang_vendorCrNumber)   
  
set @html = [dbo].ReplaceHtmlString(@html,'@customerName',@customerName)  --@customerName                                        
set @html = [dbo].ReplaceHtmlString(@html,'@customerAddress',@customerAddress)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@customerContactNumber',@customerContactNumber)                                      
set @html = [dbo].ReplaceHtmlString(@html,'@customerVatId',@customerVatId)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@customerEmail',@customerEmail)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@customerCrNumber',@customerCrNumber)                              
set @html = [dbo].ReplaceHtmlString(@html,'@InvcDueDate',CONVERT(VARCHAR(10), @invoiceDueDate, 101))  --SAGCO                           
                              
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalBeforeVatCur',@TaxableAmount)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalDiscountCur',@totalDiscount )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@finalTotalBeforeDiscountCur',((@TaxableAmount) - isnull(@totalDiscount,0)) + @totalothercharges)                              
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalotherchargesCur',@totalothercharges  )                            
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalVatCur', @totalVat    + @totalotherVATcharges  )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalWithVatCur', @totalWithVat   + @totalotherVATcharges   + @totalothercharges   )                                         
set @html = [dbo].ReplaceHtmlDecimal(@html,'@dueBalanceCur',@dueBalance )                                  
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountStdCur',@taxableAmountStd )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountStdCur',@taxAmountStd )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountStdCur',@totalAmountStd )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountZeroCur',@taxableAmountZero )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountZeroCur',@taxAmountZero )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountZeroCur',@totalAmountZero )                             
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountExmptCur',@taxableAmountExmpt )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountExmptCur',@taxAmountExmpt )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountExmptCur',@totalAmountExmpt )                            
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountOutCur',@taxableAmountOut )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountOutCur',@taxAmountOut )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountOutCur',@totalAmountOut )                            
                       
set @html = [dbo].ReplaceHtmlString(@html,'@accountName',@accountName)                            
set @html = [dbo].ReplaceHtmlString(@html,'@accountNumber',@accountNumber)                            
set @html = [dbo].ReplaceHtmlString(@html,'@iban',@iban)                            
set @html = [dbo].ReplaceHtmlString(@html,'@nameofbank',@nameofbank)                            
set @html = [dbo].ReplaceHtmlString(@html,'@swiftcode',@swiftcode)                        
set @html = [dbo].ReplaceHtmlString(@html,'@branchName',@branchName)                           
set @html = [dbo].ReplaceHtmlString(@html,'@branchAddress',@branchAddress)                          
                                   
set @html = [dbo].ReplaceHtmlString(@html,'@itemRows',@itemRows)                               
set @html = [dbo].ReplaceHtmlString(@html,'@Chargesrow',@chargesRows)                             
set @html = [dbo].ReplaceHtmlString(@html,'@itemsfooter',@itemsfooter)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@notes',@notes)                                                    
set @html = [dbo].ReplaceHtmlString(@html,'@exchangerate',@exchangeRate)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@customerId',@customerId)                     
                           
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalBeforeVat',@totalBeforeVat)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalDiscount',@totalDiscount)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@finalTotalBeforeDiscount',@finalTotalBeforeDiscount + @totalothercharges)                              
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalothercharges',@totalothercharges)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalVat',@totalVat + @totalotherVATcharges  )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalWithVat',@totalWithVat + @totalotherVATcharges   + @totalothercharges)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@dueBalance',@dueBalance)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountStd',(@taxableAmountStd ) + @totalothercharges )
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountStd',(@taxAmountStd + @totalotherVATcharges)*@exchangeRate)                        
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountStd',@totalAmountStd*@exchangeRate)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountZero',case when isnull(@taxableAmountStd,0)=0 then ((@taxableAmountZero  + @totalothercharges) ) else @taxableAmountZero  end)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountZero',@taxAmountZero*@exchangeRate)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountZero',@totalAmountZero + @totalothercharges)                            
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountExmpt',case when isnull(@taxableAmountStd,0)=0 then (@taxableAmountExmpt  + @totalothercharges) else @taxableAmountExmpt  end)                                     
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountExmpt',@taxAmountExmpt*@exchangeRate)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountExmpt',@totalAmountExmpt )                            
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxableAmountOut',case when isnull(@taxableAmountStd,0)=0 then (@taxableAmountOut  + @totalothercharges) else @taxableAmountOut  end)                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@taxAmountOut',@taxAmountOut*@exchangeRate )                                          
set @html = [dbo].ReplaceHtmlDecimal(@html,'@totalAmountOut',@totalAmountOut )                            
                
set @html = [dbo].ReplaceHtmlString(@html,'@currency2',@currency2)                                          
set @html = [dbo].ReplaceHtmlString(@html,'@showCur',@showCur)                             
set @html = [dbo].ReplaceHtmlString(@html,'@show1',@show1)                             
set @html = [dbo].ReplaceHtmlString(@html,'@showCustom',@showCustom)                             
set @html = [dbo].ReplaceHtmlString(@html,'@showother',@showother)                        
set @html = [dbo].ReplaceHtmlString(@html,'@isQr',@isqrCodedisplay)                       
set @html = [dbo].ReplaceHtmlString(@html,'@isQr1',@isqrCodedisplay1)                        
                            
set @html = [dbo].ReplaceHtmlString(@html,'@showFreight',@showFreight)                            
set @html = [dbo].ReplaceHtmlString(@html,'@showTotal',@showTotal)                                          
                     
set @html = [dbo].ReplaceHtmlString(@html,'@lang_customerAddress',@lang_customerAddress)                                                                                                                                                             
set @html = [dbo].ReplaceHtmlString(@html,'@lang_customerName',@lang_customerName)                                                                                             
                                                                             
                  
set @html = [dbo].ReplaceHtmlString(@html,'@billtoattention', @billtoattention)                                      
set @html = [dbo].ReplaceHtmlString(@html,'@shiptoaddress', @shiptoaddress)                                                                         
                                                                                                       

set @html = [dbo].ReplaceHtmlString(@html,'@referenceinvoicenoPO', @referenceinvoicenoPO)  
set @html = [dbo].ReplaceHtmlString(@html,'@sagcopaymentterms', @sagcopaymentterms)  

                            
set @html = [dbo].ReplaceHtmlString(@html,'@invoiceRefDate',CONVERT(VARCHAR(10), @invoiceRefDate, 101)  )                         
                                     
                         
set @html = [dbo].ReplaceHtmlString(@html,'@referenceinvoiceno', @referenceinvoiceno)                                                                                                
set @html = [dbo].ReplaceHtmlString(@html,'@sapinvoicenumber',@invoiceNumber)                                      
                                                                                                                        
set @html = [dbo].ReplaceHtmlString(@html,'@deliverydate', format(getdate(),'dd-MM-yyyy'))                                  
set @html = [dbo].ReplaceHtmlString(@html,'@invoiceduedate', @deliverydate)                                                                
                                      
set @html = [dbo].ReplaceHtmlString(@html,'@customer2',case when isnull(@customerId,'') = '' then @customer2 when isnull(@customer2,'') = '' then @customerId else concat(@customerId,'-',@customer2) end) --Brady                 
set @html = [dbo].ReplaceHtmlString(@html,'@custIdNew',@customerId)  --AATE                
                
set @html = [dbo].ReplaceHtmlString(@html,'@yourvatnumber', @yourvatnumber)                                     
set @html = [dbo].ReplaceHtmlString(@html,'@freightCur', cast(@freight  as decimal(15,2)))                                      
set @html = [dbo].ReplaceHtmlString(@html,'@custom1Cur', cast(@custom1  as decimal(15,2)))                              
set @html = [dbo].ReplaceHtmlString(@html,'@freight1', cast(@freight as decimal(15,2)))                                      
set @html = [dbo].ReplaceHtmlString(@html,'@custom3', cast(@custom1 as decimal(15,2)))                              
set @html = [dbo].ReplaceHtmlString(@html,'@invoicetotalCur', cast(@invoicetotal  as decimal(15,2)))                               
                              
set @html = [dbo].ReplaceHtmlString(@html,'@invoicetotal12', cast(@invoicetotal as decimal(15,2)))                                 
set @html = [dbo].ReplaceHtmlString(@html,'@desc1', @desc1)                                     
set @html = [dbo].ReplaceHtmlString(@html,'@desc2', @desc2)                    
set @html = [dbo].ReplaceHtmlString(@html,'@totaldiscwithVAT', @totaldiscwithVAT)                  
set @html = [dbo].ReplaceHtmlString(@html,'@invoiceText', @invoiceText)                  
set @html = [dbo].ReplaceHtmlString(@html,'@shiptoName', @shiptoName)                  
set @html = [dbo].ReplaceHtmlString(@html,'@lang_shiptoAddress', @lang_shiptoAddress)                  
set @html = [dbo].ReplaceHtmlString(@html,'@lang_shiptoname', @lang_shiptoname)                
set @html = [dbo].ReplaceHtmlString(@html,'@sagco_isexport',@sagco_isexport) 
set @html = [dbo].ReplaceHtmlString(@html,'@sagco_invoiceduedate', @sagco_invoiceduedate)  
set @html = [dbo].ReplaceHtmlString(@html,'@sagcocustomercontact',@sagcocustomercontact)     
set @html = [dbo].ReplaceHtmlString(@html,'@sagco_exportinvoicenumber', @sagco_exportinvoicenumber)     
set @html = [dbo].ReplaceHtmlString(@html,'@sagco_shiptoaddress', @sagco_shiptoaddress)     

set @html =[dbo].ReplaceHtmlDecimal(@html,'@CurSAGCOLineAmountInclusiveVAT',@LineAmountInclusiveVAT*@exchangeRate)   --SAGCO             
set @html =[dbo].ReplaceHtmlDecimal(@html,'@CurSAGCOVATAmount',@VATAmount*@exchangeRate )         --SAGCO

select @html as html, @orientation as orientation;                                  
--- select @Quantity;                            
--select @accountName                          
end
GO
