SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE       procedure [dbo].[InsertSalesReportData]  -- exec  InsertSalesReportData 376,140        
(@IRNNo bigint,        
@TenantId int=null)        
As        
Begin        
Insert into dbo.logs           
values           
(          
@IRNNo,          
getdate(),           
@TenantId         
)   

declare @text nvarchar(20) = 'Buyer'
declare @type nvarchar(20)
set @type = (select isnull([Type],'') from SalesInvoiceAddress where [Type] = 'Delivery' and IRNNo = @IRNNo and TenantId=@TenantId)

if (@type = 'delivery')
begin
set @text = 'Delivery'
end

insert into VI_ImportstandardFiles_Processed        
( TenantId,   
BatchId,        
Filename,        
IRNNo,        
InvoiceNumber,        
IssueDate,        
Effdate,        
IssueTime,        
OrignalSupplyDate,        
SupplyDate,        
InvoiceCurrencyCode,        
PurchaseOrderId,        
BillingReferenceId,        
ContractId,        
SupplyEndDate,        
BuyerCountryCode,        
BuyerMasterCode,        
IsDeleted,        
TransType,        
InvoiceType,        
InvoiceLineIdentifier,        
ItemMasterCode,        
ItemName,        
Quantity,        
UOM,        
Discount,        
GrossPrice,        
NetPrice,        
VatRate,        
VatCategoryCode,        
VATLineAmount,        
LineNetAmount,        
LineAmountInclusiveVAT,        
TotalTaxableAmount,        
Processed,        
Error,        
BillOfEntry,        
BillOfEntryDate,        
CustomsPaid,        
CustomTax,        
WHTApplicable,        
PurchaseNumber,        
PurchaseCategory,        
LedgerHeader,        
AdvanceRcptAmtAdjusted,        
VatOnAdvanceRcptAmtAdjusted,        
AdvanceRcptRefNo,        
BuyerName,        
BuyerVatCode,        
NatureofServices,        
Isapportionment,        
ExciseTaxPaid,        
OtherChargesPaid,        
CreationTime,        
CreatorUserId,        
BuyerContact,        
VATDeffered,        
PlaceofSupply,        
RCMApplicable,        
OrgType,        
LastModificationTime,        
LastModifierUserId,        
AffiliationStatus,        
VatExemptionReasonCode,        
VatExemptionReason,        
DeleterUserId,        
DeletionTime,        
PaymentMeans,        
ReasonForCN,        
PaymentTerms,        
CapitalInvestedbyForeignCompany,        
CapitalInvestmentCurrency,        
CapitalInvestmentDate,        
ExchangeRate,        
PerCapitaHoldingForiegnCo,        
ReferenceInvoiceAmount,        
VendorCostitution      
      
--BillOfEntryDate,      
--BuyerName,      
--ContractId,      
--PurchaseOrderId,      
--BuyerMasterCode,      
--BillOfEntry      
)         
select --ih.Id as Id,         
ih.TenantId as TenantId,
0 as BatchId,         
ih.uniqueidentifier as Filename,        
ih.IRNNo as IRNNo,        
ih.InvoiceNumber as InvoiceNumber,        
ih.IssueDate as IssueDate,        
ih.IssueDate as EffDate,        
ih.IssueDate as IssueTime,        
ih.DateOfSupply as OrignalSupplyDate,         
ih.DateOfSupply as SupplyDate,        
ih.InvoiceCurrencyCode as InvoiceCurrencyCode,        
(select PurchaseOrderNumber from openjson(ih.additionaldata2) with (PurchaseOrderNumber nvarchar(max) '$.purchase_order_no')) as PurchaseOrderId,        
ih.BillingReferenceId as BillingReferenceId,       
(select SalesOrderNumber from openjson(ih.additionaldata2) with (SalesOrderNumber nvarchar(max) '$.original_order_number')) as ContractId,      
--ih.ContractId as ContractId,        
ih.LatestDeliveryDate as SupplyEndDate,

ia.CountryCode  as BuyerCountryCode,        
bu.CustomerId as BuyerMasterCode,        
0 as IsDeleted,        
'Sales' as TransType,        
case when ia.CountryCode  = 'SA' and ii.LineAmountInclusiveVAT < 1000 then 'Sales Invoice - Nominal'        
when ia.CountryCode = 'SA' and ii.LineAmountInclusiveVAT >= 1000 then 'Sales Invoice - Standard'        
when ia.CountryCode <> 'SA' then 'Sales Invoice - Export'         
else 'Sales Invoice - Standard' end as InvoiceType,        
--ii.Identifier as InvoiceLineIdentifier,        
ROW_NUMBER() OVER(ORDER BY ih.id asc) AS InvoiceLineIdentifier,        
ii.Name as ItemMasterCode,        
ii.Description as ItemName,        
ii.Quantity as Quantity,        
isnull(ii.UOM,'OtherCharge') as UOM,         
ii.DiscountAmount as Discount,        
ii.GrossPrice as GrossPrice,        
iif(ii.uom is null,ii.unitprice,ii.NetPrice) as NetPrice,        
ii.VATRate as VatRate,        
ii.VATCode as VatCategoryCode,        
ii.VATAmount as VATLineAmount,        
--ii.netprice * ii.Quantity as LineNetAmount,        
iif(ii.UOM is null,ii.unitprice,ii.netprice) as LineNetAmount,        
ii.LineAmountInclusiveVAT as LineAmountInclusiveVAT,        
ii.LineAmountInclusiveVAT as TotalTaxableAmount,        
1 as Processed,        
' ' as Error,       
(select ShipToNumber from openjson(bu.additionaldata1) with (ShipToNumber nvarchar(max) '$.crNumber')) as BillOfEntry,      
--' ' as BillOfEntry,      
(
SELECT
    CONVERT(DATETIME2, dbo.Dateconverter(billofentrydate), 105) as BillOfEntryDate
FROM
    openjson(ih.additionaldata2)
WITH
    (billofentrydate nvarchar(max) '$.invoice_reference_date') as json_data) as BillOfEntryDate,        
--null as BillOfEntryDate,        
0 as CustomsPaid,        
0 as CustomTax,        
0 as WHTApplicable,         
' ' as PurchaseNumber,        
' ' as PurchaseCategory,        
' ' as LedgerHeader,        
--Duplicate        
PaidAmount - round((ss.PaidAmount)*15/(100+ii.vatrate),2) as AdvanceRcptAmtAdjusted,         
round((ss.PaidAmount)*15/(100+ii.vatrate),2) as VatOnAdvanceRcptAmtAdjusted,        
' ' as AdvanceRcptRefNo,        
bu.RegistrationName as BuyerName,        
bu.VATID as BuyerVatCode,        
' ' as NatureofServices,        
0 as Isapportionment,        
0 as ExciseTaxPaid,        
0 as OtherChargesPaid,        
ih.CreationTime as CreationTime,         
ih.CreatorUserId as CreatorUserId,         
cp.ContactNumber as BuyerContact,        
0 as VATDeffered,        
ih.Location as PlaceofSupply,        
0 as RCMApplicable,        
case when bu.OtherDocumentTypeId is null then 'Private' else bu.OtherDocumentTypeId end as OrgType,        
ih.LastModificationTime as LastModificationTime,        
ih.LastModifierUserId as LastModifierUserId,        
' ' as AffiliationStatus,         
--vd.ExcemptionReasonCode as VatExemptionReasonCode,         
--vd.ExcemptionReasonText as VatExemptionReason,        
' ' as VatExemptionReasonCode,         
' ' as VatExemptionReason,        
ih.DeleterUserId as DeleterUserId,         
ih.DeletionTime as DeletionTime,        
pd.PaymentMeans as PaymentMeans,        
pd.CreditDebitReasonText as ReasonForCN,         
pd.PaymentTerms as PaymentTerms,        
0 as CapitalInvestedbyForeignCompany,         
' ' as CapitalInvestmentCurrency,        
null as CapitalInvestmentDate,        
0 as ExchangeRate,        
0 as PerCapitaHoldingForiegnCo,        
0 as ReferenceInvoiceAmount,        
' ' as VendorCostitution      
      
--(select InvoiceReferenceDate from openjson(ih.additionaldata2) with (billofentrydate nvarchar(max) '$.billofentrydate')) as InvoiceReferenceDate,      
--(select PurchaseOrderNumber from openjson(ih.additionaldata2) with (PurchaseOrderNumber nvarchar(max) '$.PurchaseOrderId')) as PurchaseOrderNumber,      
      
from SalesInvoice ih         
inner join SalesInvoiceAddress ia on Ih.IRNNo = Ia.IRNNo and ih.tenantid = ia.tenantid         
inner join SalesInvoiceParty bu on ih.irnno = bu.IRNNo and ih.tenantid = bu.tenantid         
inner join SalesInvoiceContactPerson cp on ih.IRNNo = Cp.IRNNo  and ih.tenantid = cp.tenantid         
--left outer join SalesInvoicevatdetail vd on ih.irnno = Vd.IRNNo    and ih.tenantid = vd.tenantid         
left outer join SalesInvoicePaymentDetail  pd on ih.IRNNo = Pd.IRNNo and ih.tenantid = pd.tenantid         
inner join SalesInvoiceSummary ss on ih.irnno = ss.irnno and ih.tenantid = ss.tenantid        
inner join SalesInvoiceitem ii on ih.IRNNo = Ii.IRNNo  and ih.tenantid = ii.tenantid         
where Ia.Type = @text
and Cp.type = 'Buyer'         
and bu.type = 'Buyer'        
and ih.tenantid = @TenantId and ih.irnno = @IRNNo           
and ih.irnno not in (select distinct irnno from vi_importstandardfiles_processed where  batchid = 0 and tenantid = @TenantId and irnno = @IRNNo)        
        
end
GO
