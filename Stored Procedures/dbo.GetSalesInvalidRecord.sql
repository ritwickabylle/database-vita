SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE     PROCEDURE [dbo].[GetSalesInvalidRecord]  --exec GetSalesInvalidRecord 38,159,'Success'          
(            
@batchId int=108,          
@tenantId int=172,  
@status nvarchar(max)='Failed'  
)            
AS            
BEGIN         
declare @type nvarchar(max)        
set @type=(select top 1 type from batchdata where batchid=@batchId and Tenantid = @tenantId)          
    
if exists (select 1 from MappingConfiguration where TenantId = @tenantId and TransactionType = @type)  
Begin  
exec GetSalesInvalidRecordByDynamicMapping @batchId, @tenantId,@status  
End  
  
else   
  
Begin  
        
If (@type='Sales')        
begin        
        
select         
InvoiceType as 'Invoice Type',        
TransType as 'TransType',        
IRNNo as 'IRN Number',        
InvoiceNumber as 'Invoice Number *',        
IssueDate as 'Invoice Issue Date*',        
IssueDate as 'Invoice Issue Time *',        
InvoiceCurrencyCode as 'Invoice currency code *',        
PurchaseOrderId as 'Purchase Order ID',        
ContractId as 'Contract ID',        
SupplyDate as 'Supply Date',        
SupplyEndDate as 'Supply End Date',        
BuyerMasterCode as 'Buyer Master Code',        
BuyerName as 'Buyer Name',        
BuyerVatCode as 'Buyer VAT number',        
BuyerContact as 'Buyer Contact',        
BuyerCountryCode as 'Buyer Country Code',        
InvoiceLineIdentifier as 'Invoice line identifier *',        
ItemMasterCode as 'Item Master Code',        
ItemName as 'Item name',        
 UOM as 'Invoiced quantity unit of measure',        
 GrossPrice as 'Item gross price',        
 Discount as 'Item price discount',        
 NetPrice as 'Item net price*',        
 Quantity as 'Invoiced quantity ',        
 LineNetAmount as 'Invoice line net amount ',        
 VatCategoryCode as 'Invoiced item VAT category code*',        
 VatRate as 'Invoiced item VAT rate*',        
 VatExemptionReasonCode as 'VAT exemption reason Code',        
 VatExemptionReason as 'VAT exemption reason  ',        
 VATLineAmount as 'VAT line amount*',        
 LineAmountInclusiveVAT as'Line amount inclusive VAT*',        
 AdvanceRcptAmtAdjusted as 'Advance Rcpt Amount Adjusted',        
 VatOnAdvanceRcptAmtAdjusted as 'VAT on Advance Receipt Amount Adjusted',        
 AdvanceRcptRefNo as 'Advance Receipt Reference Number',        
 PaymentMeans as 'Payment Means',        
 PaymentTerms as 'Payment Terms',        
 OrgType  as 'Buyer Type',        
 dbo.get_errormessage(UniqueIdentifier) as 'Error'        
from ImportBatchData         
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)    
and dbo.get_errormessage(UniqueIdentifier) <> ''    
order by CreationTime desc          
        
end        
        
else if(@type='credit')        
begin        
select          
 InvoiceType as 'Credit Note Type',          
    IRNNo as 'IRN Number',          
    InvoiceNumber as 'Credit Note Number *',          
    IssueDate as 'Credit Note Issue Date *',          
    IssueTime as 'Credit Note Issue Time *',          
    InvoiceCurrencyCode as 'Credit Note currency code *',          
    BillingReferenceId as 'Billing Refrence Id',          
    OrignalSupplyDate as 'Original Supply  Date*',          
    ReasonForCN as 'Reason for Issuance of Credit Note',          
    PurchaseOrderId as 'Purchase Order ID',          
    ContractId as 'Contract ID',          
    BuyerMasterCode as 'Buyer Master Code',          
    BuyerName as 'Buyer Name',          
    BuyerVatCode as 'Buyer VAT number',          
    BuyerContact as 'Buyer Contact',          
    BuyerCountryCode as 'Buyer Country Code',            
    InvoiceLineIdentifier as 'Credit Note line identifier *',          
    ItemMasterCode as 'Item Master Code',          
    ItemName as 'Item name',          
    UOM as ' quantity unit of measure',          
    GrossPrice as 'Item gross price',          
    Discount as 'Item price discount',          
    NetPrice as 'Item net price*',          
    Quantity as 'Credit Note quantity ',          
    LineNetAmount 'Credit Note line net amount ',       
    VatCategoryCode as 'Credit Note item VAT category code*',          
    VatRate as 'Credit Note item VAT rate*',          
    VatExemptionReasonCode as 'VAT exemption reason code' ,          
    VatExemptionReason as 'VAT exemption reason',          
    VATLineAmount as 'VAT line amount*',          
    LineAmountInclusiveVAT as 'Line amount inclusive VAT*',  
 OrgType  as 'Buyer Type',  
 dbo.get_errormessage(UniqueIdentifier) as 'Error'        
 from ImportBatchData         
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)    
and dbo.get_errormessage(UniqueIdentifier) <> ''    
order by CreationTime desc        
end        
        
else if(@type='Debit')        
begin        
select         
 InvoiceType as 'Debit Note Type',          
    IRNNo  as 'IRN Number',   
    InvoiceNumber as 'Debit Note Number *',          
    IssueDate as 'Debit Note Issue Date *',          
    IssueTime as 'Debit Note Issue Time *',          
    InvoiceCurrencyCode as 'Debit Note currency code *',          
    BillingReferenceId as 'Billing Refrence Id',          
    OrignalSupplyDate as 'Original Supply  Date*',          
    ReasonForCN as 'Reason for Issuance of Debit Note',          
    PurchaseOrderId as 'Purchase Order ID',          
    ContractId as 'Contract ID',          
    BuyerMasterCode as 'Buyer Master Code',          
    BuyerName as 'Buyer Name',          
    BuyerVatCode as 'Buyer VAT number',          
    BuyerContact as 'Buyer Contact',          
    BuyerCountryCode as 'Buyer Country Code',          
    InvoiceLineIdentifier as 'Debit Note line identifier *',          
    ItemMasterCode as 'Item Master Code',          
    ItemName as 'Item name',          
    UOM as ' quantity unit of measure',          
    GrossPrice as 'Item gross price',           
    Discount as 'Item price discount',          
    NetPrice as 'Item net price*',          
    Quantity as 'Debit Note quantity ',          
    LineNetAmount as 'Debit Note line net amount ',          
    VatCategoryCode as 'Debit Note item VAT category code*',          
    VatRate as 'Debit Note item VAT rate*',          
    VatExemptionReasonCode as 'VAT exemption reason code',          
    VatExemptionReason as 'VAT exemption reason',  
    VATLineAmount as 'VAT line amount*',          
    LineAmountInclusiveVAT as 'Line amount inclusive VAT*',   
 OrgType  as 'Buyer Type',  
 dbo.get_errormessage(UniqueIdentifier) as 'Error'        
from ImportBatchData         
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)     
and dbo.get_errormessage(UniqueIdentifier) <> ''    
order by CreationTime desc        
end        
        
else if(@type='Credit-purchase')        
begin        
select         
 InvoiceType as 'Credit Note Type',            
 PurchaseCategory as 'Purchase Category',          
    IRNNo as 'IRN Number',   
 LedgerHeader as 'Ledger Head',              
NatureofServices as 'Nature of Service (Mandatory for WHT related transactions)' ,              
Isapportionment as 'Overhead apportionment (Y/N)',  
    InvoiceNumber as 'Credit Note Number *',            
    IssueDate as 'Credit Note Issue Date *',            
    IssueTime as 'Credit Note Issue Time *',            
    InvoiceCurrencyCode as 'Credit Note currency code *',            
    BillingReferenceId as 'Billing Refrence Id',            
    OrignalSupplyDate as'Original Purchase  Date*',           
    ReasonForCN as 'Reason for Issuance of Credit Note',            
    PurchaseOrderId as 'Purchase Order ID',            
    ContractId as 'Contract ID',            
    BuyerMasterCode as 'Supplier Master Code' ,          
    BuyerName AS 'Supplier Name',            
    BuyerVatCode AS'Supplier VAT number',            
    BuyerContact AS 'Supplier Contact',            
    BuyerCountryCode AS 'Supplier Country Code',            
    OrgType AS'Supplier Type',            
    InvoiceLineIdentifier AS 'Credit Note line identifier *',            
    ItemMasterCode AS 'Item Master Code',            
    ItemName AS 'Item name',            
    UOM AS ' quantity unit of measure',            
    GrossPrice as 'Item gross price',            
    Discount as 'Item price discount',            
    NetPrice as 'Item net price*',            
    Quantity as 'Credit Note quantity ',            
    LineNetAmount as 'Credit Note line net amount ',            
    VatCategoryCode as 'Credit Note item VAT category code*',            
    VatRate as 'Credit Note item VAT rate*',            
    VatExemptionReasonCode as 'VAT exemption reason code',            
    VatExemptionReason as 'VAT exemption reason',  
 BillOfEntry as 'Bill of Entry/ Airway Bill No',         
BillOfEntryDate as 'Bill of Entry / AWB date',               
CustomsPaid as 'Customs Paid',               
ExciseTaxPaid as 'Excise Tax Paid',               
OtherChargesPaid as 'Other Charges Paid',  
TotalTaxableAmount as 'Total Taxable amount*',  
    VATLineAmount as 'VAT line amount*',            
    LineAmountInclusiveVAT as 'Line amount inclusive VAT*',  
 VATDeffered as 'VAT Deffered',              
PlaceofSupply AS 'Place of Supply (Within KSA/ Outside KSA)',              
RCMApplicable AS 'RCM Applicable (Y/N)',              
WHTApplicable AS 'WHT Applicable (Y/N)',  
PaymentMeans as 'Supply Type' ,   
 dbo.get_errormessage(UniqueIdentifier) as 'Error'        
from ImportBatchData         
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)    
and dbo.get_errormessage(UniqueIdentifier) <> ''    
order by CreationTime desc          
     end        
  
  else if(@type='Debit-purchase')        
begin        
select         
 InvoiceType as 'Debit Note Type',            
 PurchaseCategory as 'Purchase Category',          
    IRNNo as 'IRN Number',   
 LedgerHeader as 'Ledger Head',              
NatureofServices as 'Nature of Service (Mandatory for WHT related transactions)' ,              
Isapportionment as 'Overhead apportionment (Y/N)',  
    InvoiceNumber as 'Debit Note Number *',            
    IssueDate as 'Debit Note Issue Date *',            
    IssueTime as 'Debit Note Issue Time *',            
    InvoiceCurrencyCode as 'Debit Note currency code *',            
    BillingReferenceId as 'Billing Refrence Id',            
    OrignalSupplyDate as'Original Purchase  Date*',           
    ReasonForCN as 'Reason for Issuance of Debit Note',            
    PurchaseOrderId as 'Purchase Order ID',            
    ContractId as 'Contract ID',            
    BuyerMasterCode as 'Supplier Master Code' ,          
    BuyerName AS 'Supplier Name',            
    BuyerVatCode AS'Supplier VAT number',            
    BuyerContact AS 'Supplier Contact',            
    BuyerCountryCode AS 'Supplier Country Code',            
    OrgType AS'Supplier Type',            
    InvoiceLineIdentifier AS 'Debit Note line identifier *',            
    ItemMasterCode AS 'Item Master Code',            
    ItemName AS 'Item name',            
    UOM AS ' quantity unit of measure',            
    GrossPrice as 'Item gross price',            
    Discount as 'Item price discount',            
    NetPrice as 'Item net price*',            
    Quantity as 'Debit Note quantity',            
    LineNetAmount as 'Debit Note line net amount',            
    VatCategoryCode as 'Debit Note item VAT category code*',            
    VatRate as 'Debit Note item VAT rate*',            
    VatExemptionReasonCode as 'VAT exemption reason code',            
    VatExemptionReason as 'VAT exemption reason',  
 BillOfEntry as 'Bill of Entry/ Airway Bill No',         
BillOfEntryDate as 'Bill of Entry / AWB date',               
CustomsPaid as 'Customs Paid',               
ExciseTaxPaid as 'Excise Tax Paid',               
OtherChargesPaid as 'Other Charges Paid',  
TotalTaxableAmount as 'Total Taxable amount*',  
    VATLineAmount as 'VAT line amount*',            
    LineAmountInclusiveVAT as 'Line amount inclusive VAT*',  
 VATDeffered as 'VAT Deffered',              
PlaceofSupply AS 'Place of Supply (Within KSA/ Outside KSA)',              
RCMApplicable AS 'RCM Applicable (Y/N)',              
WHTApplicable AS 'WHT Applicable (Y/N)',  
PaymentMeans as 'Supply Type' ,   
 dbo.get_errormessage(UniqueIdentifier) as 'Error'        
from ImportBatchData         
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)    
and dbo.get_errormessage(UniqueIdentifier) <> ''    
order by CreationTime desc          
     end     
        
else if(@type='Purchase')        
begin        
select         
PurchaseNumber as 'Purchase Number',               
PurchaseCategory as 'Purchase Category',              
LedgerHeader as 'Ledger Head',              
NatureofServices as 'Nature of Service (Mandatory for WHT related transactions)' ,              
Isapportionment as 'Overhead apportionment (Y/N)',   
AffiliationStatus as 'INPUT VAT CLAIMED (Y/N)',  
ReasonforCN as 'Reason for INPUT VAT CLAIMED =(N)',  
InvoiceNumber as 'Supplier Invoice Number *',              
IssueDate as 'Purchase  Date *',              
IssueTime as 'Purchase  Time *',               
InvoiceCurrencyCode as 'Purchase currency code *',              
SupplyDate as 'Supplier Invoice Date',              
BuyerMasterCode as 'Supplier Master Code',              
BuyerName as 'Supplier Name',              
BuyerVatCode as 'Supplier VAT number',              
BuyerContact as 'Supplier Contact',               
BuyerCountryCode as 'Supplier Country Code',         
OrgType as 'Supplier Type',        
InvoiceLineIdentifier as 'Purchase entry line identifier *',                 
ItemMasterCode as 'Item Master Code',              
ItemName as 'Item name',               
UOM as 'Purchased quantity unit of measure',               
GrossPrice as 'Item gross price',              
Discount as 'Item price discount',              
NetPrice as 'Item net price*',              
Quantity as 'Purchase quantity ',              
LineNetAmount as 'Purchase  line net amount ',              
VatCategoryCode as 'Purchase item VAT category code*',              
VatRate as 'Purchase item VAT rate*',               
VatExemptionReasonCode as 'VAT exemption reason code',        
VatExemptionReason as 'VAT exemption reason',              
BillOfEntry as 'Bill of Entry/ Airway Bill No',         
BillOfEntryDate as 'Bill of Entry / AWB date',               
CustomsPaid as 'Customs Paid',               
ExciseTaxPaid as 'Excise Tax Paid',               
OtherChargesPaid as 'Other Charges Paid',  
VATLineAmount as 'VAT line amount*',              
LineAmountInclusiveVAT as 'Line amount inclusive VAT*',               
VATDeffered as 'VAT Deffered',              
PlaceofSupply AS 'Place of Supply (Within KSA/ Outside KSA)',              
RCMApplicable AS 'RCM Applicable (Y/N)',              
WHTApplicable AS 'WHT Applicable (Y/N)',        
PaymentMeans as 'Supply Type' ,       
dbo.get_errormessage(UniqueIdentifier)as Error       
from ImportBatchData         
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)     
and dbo.get_errormessage(UniqueIdentifier) <> ''    
order by CreationTime desc          
        
end        
        
else if (@type='Payment')        
begin        
select         
InvoiceType as 'Payment Type',        
  BuyerName as 'Vendor name',         
  OrgType as 'Vendor Type',         
  BuyerCountryCode as 'Vendor country',        
  IssueDate as 'Payment date',         
  TotalTaxableAmount as 'Amount paid (charge)',         
  InvoiceCurrencyCode as 'CCY',        
  PaymentMeans as 'Payment Mode',         
  ExchangeRate as 'Exchange rate',         
  LineAmountInclusiveVAT as 'Amount in Saudi Riyal',         
  LedgerHeader as 'GL Head',        
  NatureofServices as 'Nature of Service',         
  ItemName as 'Brief nature of payment (2 or 3 words)',        
  PlaceofSupply as 'Place of performance of services',        
  AffiliationStatus as 'Affiliation status',         
  PurchaseNumber as 'Reference Invoice Number',        
  SupplyEndDate as 'Reference Invoice Date',        
  ReferenceInvoiceAmount as 'Reference Invoice Amount',         
  PaymentTerms as 'Payment Purpose',         
  PerCapitaHoldingForiegnCo as '% of Capital holding by Foreign Co',         
  CapitalInvestedbyForeignCompany as 'Capital Invested by Foreign Company',         
  CapitalInvestmentCurrency as 'Capital Investment Currency',        
  CapitalInvestmentDate as 'Capital Investment Date',         
  VendorConstitution as 'Vendor Costitution',        
  dbo.get_errormessage(UniqueIdentifier) as Error        
from ImportBatchData         
where BatchId = @batchId and ISNULL(TenantId,0)=ISNULL(@tenantId,0)    
and dbo.get_errormessage(UniqueIdentifier) <> ''    
order by CreationTime desc          
end        
END     
  
end  
        
--//pending debit-purchase 
GO
