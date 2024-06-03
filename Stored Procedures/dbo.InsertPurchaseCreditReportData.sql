SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

    
CREATE    procedure [dbo].[InsertPurchaseCreditReportData]   -- exec InsertPurchaseCreditReportData 6,33    
(@IRNNo bigint,    
@TenantId int=null)    
As    
Begin    
 insert into VI_ImportstandardFiles_Processed    
 (    
 --Id,    
 TenantId,BatchId,Filename,IRNNo,InvoiceNumber,IssueDate,Effdate,IssueTime,OrignalSupplyDate,SupplyDate,InvoiceCurrencyCode,    
 PurchaseOrderId,BillingReferenceId,ContractId,SupplyEndDate,BuyerCountryCode,BuyerMasterCode,IsDeleted,TransType,InvoiceType,    
 InvoiceLineIdentifier,ItemMasterCode,ItemName,Quantity,UOM,Discount,GrossPrice,NetPrice,VatRate,VatCategoryCode,VATLineAmount,    
 LineNetAmount,LineAmountInclusiveVAT,TotalTaxableAmount,Processed,Error,BillOfEntry,BillOfEntryDate,CustomsPaid,CustomTax,WHTApplicable,    
 PurchaseNumber,PurchaseCategory,LedgerHeader,AdvanceRcptAmtAdjusted,VatOnAdvanceRcptAmtAdjusted,AdvanceRcptRefNo,BuyerName,BuyerVatCode,    
 NatureofServices,Isapportionment,ExciseTaxPaid,OtherChargesPaid,CreationTime,CreatorUserId,BuyerContact,VATDeffered,PlaceofSupply,    
 RCMApplicable,OrgType,LastModificationTime,LastModifierUserId,AffiliationStatus,VatExemptionReasonCode,VatExemptionReason,DeleterUserId,DeletionTime,PaymentMeans,ReasonForCN,PaymentTerms,CapitalInvestedbyForeignCompany,CapitalInvestmentCurrency,    
 CapitalInvestmentDate,ExchangeRate,PerCapitaHoldingForiegnCo,ReferenceInvoiceAmount,VendorCostitution)     
 select     
 --ih.IRNNo as Id,    
 ih.TenantId as TenantId,    
 0 as BatchId,    
 ih.uniqueidentifier as Filename,    
 ih.id as IRNNo,    
 ih.InvoiceNumber as InvoiceNumber,    
 ih.IssueDate as IssueDate,    
 ih.issuedate as Effdate,    
 ih.IssueDate as IssueTime,    
 ih.DateOfSupply as OrignalSupplyDate,     
 ih.DateOfSupply as SupplyDate,    
 ih.InvoiceCurrencyCode as InvoiceCurrencyCode,     
 ih.PurchaseOrderId as PurchaseOrderId,     
 ih.BillingReferenceId as BillingReferenceId,     
 ih.ContractId as ContractId, ih.LatestDeliveryDate as SupplyEndDate,    
 ia.CountryCode  as BuyerCountryCode, ih.CustomerId as BuyerMasterCode,     
 0 as IsDeleted, 'Sales' as TransType,    
 case when ia.CountryCode = 'SA' and ii.LineAmountInclusiveVAT < 1000 then 'CN Purchase - Nominal'    
when ia.CountryCode = 'SA' and ii.LineAmountInclusiveVAT >= 1000 then 'CN Purchase - Standard'    
when ia.CountryCode <> 'SA' then 'CN Purchase - Export'     
else 'CN Purchase - Standard' end as InvoiceType ,    
--ii.Identifier as InvoiceLineIdentifier,    
ROW_NUMBER() OVER(ORDER BY ih.id asc) AS InvoiceLineIdentifier,    
 ii.Name as ItemMasterCode, ii.Description as ItemName,    
 ii.Quantity as Quantity, ii.UOM as UOM, ii.DiscountAmount as Discount,    
 ii.GrossPrice as GrossPrice, ii.NetPrice as NetPrice,     
 ii.VATRate as VatRate, ii.VATCode as VatCategoryCode,     
 ii.VATAmount as VATLineAmount,    
 --ii.netprice * ii.Quantity as LineNetAmount,    
 ii.netprice  as LineNetAmount,    
 ii.LineAmountInclusiveVAT as LineAmountInclusiveVAT,     
 ii.LineAmountInclusiveVAT as TotalTaxableAmount, 1 as Processed, ' ' as Error,    
 ' ' as BillOfEntry, null as BillOfEntryDate, 0 as CustomsPaid,    
 0 as CustomTax, 0 as WHTApplicable, ' ' as PurchaseNumber,    
 ' ' as PurchaseCategory, ' ' as LedgerHeader,    
 PaidAmount - round((ss.PaidAmount)*15/(100+ii.vatrate),2) as AdvanceRcptAmtAdjusted,     
 round((ss.PaidAmount)*15/(100+ii.vatrate),2) as VatOnAdvanceRcptAmtAdjusted, ' ' as AdvanceRcptRefNo, bu.RegistrationName as BuyerName,    
 bu.VATID as BuyerVatCode, ' ' as NatureofServices, 0 as Isapportionment, 0 as ExciseTaxPaid, 0 as OtherChargesPaid,    
 ih.CreationTime as CreationTime, ih.CreatorUserId as CreatorUserId, cp.ContactNumber as BuyerContact, 0 as VATDeffered,    
 ih.Location as PlaceofSupply, 0 as RCMApplicable, 'PRIVATE' as OrgType, ih.LastModificationTime as LastModificationTime,    
 ih.LastModifierUserId as LastModifierUserId, ' ' as AffiliationStatus,     
-- vd.ExcemptionReasonCode as VatExemptionReasonCode,    
-- vd.ExcemptionReasonText as VatExemptionReason,     
' ' as VatExemptionReasonCode,    
 ' ' as VatExemptionReason,     
 ih.DeleterUserId as DeleterUserId, ih.DeletionTime as DeletionTime,    
 pd.PaymentMeans as PaymentMeans, pd.CreditDebitReasonText as ReasonForCN, pd.PaymentTerms as PaymentTerms,     
 0 as CapitalInvestedbyForeignCompany, ' ' as CapitalInvestmentCurrency, null as CapitalInvestmentDate,    
 0 as ExchangeRate, 0 as PerCapitaHoldingForiegnCo, 0 as ReferenceInvoiceAmount,    
 ' ' as VendorCostitution from PurchaseCreditNote ih inner join PurchaseCreditNoteItem ii on ih.id = Ii.IRNNo  and ih.tenantid = ii.TenantId     
  inner join PurchaseCreditNoteAddress ia on Ih.id = Ia.IRNNo and ih.tenantid = ia.TenantId     
  inner join PurchaseCreditNotePartiy bu on ih.id = bu.IRNNo  and ih.tenantid = bu.TenantId     
  inner join PurchaseCreditNoteContactPerson cp on ih.id = Cp.IRNNo and ih.tenantid = cp.TenantId      
 -- left outer join CreditNoteVATDetail vd on ih.irnno = Vd.IRNNo  and ih.tenantid = vd.TenantId     
 left outer join PurchaseCreditNotePaymentDetail pd on ih.id = Pd.IRNNo and ih.tenantid = pd.TenantId     
  inner join PurchaseCreditNoteSummary ss on ih.id = ss.irnno and ih.tenantid = ss.TenantId     
 where Ia.Type = 'Supplier'     
 and Cp.type = 'Supplier'    
 and bu.type = 'Supplier'    
 and ih.tenantid = @tenantid and ih.id=@IRNNo and ih.IRNNo     
 not in     
 (select distinct irnno from vi_importstandardfiles_processed where  batchid = 0 and tenantid = @TenantId and irnno = @IRNNo and InvoiceType like 'CN Purchase-%')       
end
GO
