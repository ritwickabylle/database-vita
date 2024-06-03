SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[InsertPurchaseReportData]   -- exec InsertPurchaseReportData 37,2
(@IRNNo bigint,
@TenantId int=null)
As
Begin
 Insert into dbo.logs   
values   
  (  
    @IRNNo,   
    getdate(),   
    0  
  )

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
) 
select --ih.Id as Id, 
ih.TenantId as TenantId, 
0 as BatchId, 
ih.uniqueidentifier as Filename,
ih.IRNNo as IRNNo,
ih.Id as InvoiceNumber,
ih.IssueDate as IssueDate,
ih.IssueDate as EffDate,
ih.IssueDate as IssueTime,
ih.DateOfSupply as OrignalSupplyDate, 
ih.DateOfSupply as SupplyDate,
ih.InvoiceCurrencyCode as InvoiceCurrencyCode,
ih.PurchaseOrderId as PurchaseOrderId,
ih.BillingReferenceId as BillingReferenceId,
ih.ContractId as ContractId,
ih.LatestDeliveryDate as SupplyEndDate,
ia.CountryCode  as BuyerCountryCode,
ih.CustomerId as BuyerMasterCode,
0 as IsDeleted,
'Purchase' as TransType,
case when ia.CountryCode  = 'SA' and ii.LineAmountInclusiveVAT < 1000 then 'Purchase Entry - Nominal'
when ia.CountryCode = 'SA' and ii.LineAmountInclusiveVAT >= 1000 then 'Purchase Entry - Standard'
when ia.CountryCode <> 'SA' then 'Purchase Entry - Import' 
else 'Purchase Entry - Standard' end as InvoiceType,
--ii.Identifier as InvoiceLineIdentifier,
ROW_NUMBER() OVER(ORDER BY ih.id asc) AS InvoiceLineIdentifier,
ii.Name as ItemMasterCode,
ii.Description as ItemName,
ii.Quantity as Quantity,
ii.UOM as UOM, 
ii.DiscountAmount as Discount,
ii.GrossPrice as GrossPrice,
ii.NetPrice as NetPrice,
ii.VATRate as VatRate,
ii.VATCode as VatCategoryCode, 
ii.VATAmount as VATLineAmount,
--ii.netprice * ii.Quantity as LineNetAmount,
ii.netprice  as LineNetAmount,
ii.LineAmountInclusiveVAT as LineAmountInclusiveVAT,
ii.LineAmountInclusiveVAT as TotalTaxableAmount,
1 as Processed,
' ' as Error,
' ' as BillOfEntry, 
null as BillOfEntryDate,
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
'PRIVATE' as OrgType,
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
from PurchaseEntry  ih 
inner join PurchaseEntryAddress  ia on Ih.id = Ia.id and ih.tenantid = ia.tenantid 
inner join PurchaseEntryParty bu on ih.id = bu.id and ih.tenantid = bu.tenantid 
inner join PurchaseEntryContactPerson cp on ih.id = Cp.id  and ih.tenantid = cp.tenantid 
--left outer join SalesInvoicevatdetail vd on ih.irnno = Vd.IRNNo    and ih.tenantid = vd.tenantid 
left outer join PurchaseEntryPaymentDetail  pd on ih.id = Pd.id and ih.tenantid = pd.tenantid 
inner join PurchaseEntrySummary ss on ih.id = ss.id and ih.tenantid = ss.tenantid
inner join PurchaseEntryitem ii on ih.id = Ii.id  and ih.tenantid = ii.tenantid 
where Ia.Type = 'Buyer' 
and Cp.type = 'Buyer' 
and bu.type = 'Buyer'
and ih.tenantid = @TenantId --and ih.irnno = @IRNNo   
and ih.id not in (select distinct irnno from vi_importstandardfiles_processed where  batchid = 0 and tenantid = @TenantId and IRNNo=@IRNNo and InvoiceType like 'Purchase%')
end

--select ih.*,i.*,j.* from PurchaseEntry ih inner join salesinvoiceitem i on ih.irnno = i.irnno
--inner join address j on ih.irnno = j.irnno 
----inner join SalesInvoiceAddress ia on Ih.IRNNo = Ia.IRNNo  and ih.tenantid = ia.tenantid 
----inner join SalesInvoiceParty bu on ih.irnno = bu.IRNNo    and ih.tenantid = bu.tenantid 
----inner join SalesInvoiceContactPerson cp on ih.IRNNo = Cp.IRNNo   and ih.tenantid = cp.tenantid 
----inner join SalesInvoicevatdetail vd on ih.irnno = Vd.IRNNo and ih.tenantid = vd.tenantid 
----left outer join SalesInvoicePaymentDetail  pd on ih.IRNNo = Pd.IRNNo   and ih.tenantid = pd.tenantid 
----inner join SalesInvoiceSummary ss on ih.irnno = ss.irnno 
--where 
--j.type = 'Buyer' 
----and bu.type = 'Buyer' and cp.type = 'Buyer' 
--and ih.irnno = 58 and ih.tenantid = 2

--select * from VI_importstandardfiles_Processed where IRNNo='37'

--select * from PurchaseEntry
GO
