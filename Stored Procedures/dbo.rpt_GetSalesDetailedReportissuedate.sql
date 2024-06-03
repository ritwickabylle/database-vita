SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create          procedure [dbo].[rpt_GetSalesDetailedReportissuedate]   -- exec GetSalesDetailedReportissuedate '2022-09-01', '2022-09-30'    
(    
@fromDate Date=null,    
@toDate Date=null  
 
)    
as begin    
    
select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as IRNNo,BillingReferenceId  as Invoicenumber,    
    
IssueDate  as  InvoiceDate,    
    
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'    
and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)     
 TaxableAmount,    
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'    
and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)     
 as GovtTaxableAmt,    
isnull(sum(case when (VatCategoryCode='Z'     
and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)     
 as ZeroRated,    
isnull(sum(case when ( BuyerCountryCode <>'SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)     
 as Exports,    
isnull(sum(case when (VatCategoryCode='E'     
and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)     
as Exempt,    
isnull(sum(case when (VatCategoryCode='O'     
and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)     
 as OutofScope,    
vatrate as Vatrate,    
sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))      
 as  VatAmount,    
sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))    
 as  TotalAmount,    
BillingReferenceId    
as ReferenceNo    
from VI_importstandardfiles_Processed where TenantId=2 and
CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate
and invoicetype like 'Sales Invoice%'    
group by IRNNo,IssueDate,InvoiceNumber,BillingReferenceId,VatRate    
    
end
GO
