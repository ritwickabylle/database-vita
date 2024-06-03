SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
CREATE           procedure [dbo].[GetDebitNotePurchaseDetailedReport]   --  exec GetDebitNotePurchaseDetailedReport '2022-11-01', '2022-11-30'      
(    
@fromDate Date=null,    
@toDate Date=null,
@tenantId int=null,
@type NVARCHAR(MAX)=NULL,    
@text NVARCHAR(MAX)=NULL  
)    
as begin    

  --exec GetDebitNotePurchaseDetailedReportIssuedate @fromDate,@toDate,@tenantId

   exec GetDebitNotePurchaseDetailedReporteffdate  @fromdate,@todate,@tenantId,@type,@text 



----select       
--select (case when (irnno is null or irnno = '') then InvoiceNumber else irnno end) as IRNNo,    
--InvoiceNumber  as Invoicenumber,billingreferenceid  as ReferenceNo,      
--IssueDate as  InvoiceDate,purchasecategory as Purchasecategory,      
--isnull(sum(case when (trim(VatCategoryCode)='S'       
--and trim(BuyerCountryCode) ='SA') Then isnull(LineNetAmount,0) else 0 end) ,0)    
-- as TaxableAmount,    
   
----isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'      
----and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,      
--isnull(sum(case when (VatCategoryCode='Z'       
--) Then isnull(LineNetAmount ,0) else 0 end ),0)      
--    --and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)      
-- as ZeroRated,    
--isnull(sum(case when (VatCategoryCode='E'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exempt,      
--isnull(sum(case when (VatCategoryCode='O'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,      
--isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='0' and BuyerCountryCode <> 'SA')   
--Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportVATCustoms,  
--isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='1' and BuyerCountryCode <> 'SA')   
--Then isnull(LineNetAmount ,0) else 0 end ),0) as VATDeffered,  
--isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='1') Then isnull(LineNetAmount ,0) else 0 end ),0) as ImportsatRCM,      
--sum(isnull(customspaid,0))       
-- as CustomsPaid,      
--sum(isnull(excisetaxpaid,0))       
-- as ExciseTaxPaid,      
--sum(isnull(OtherChargespaid,0))      
-- as OtherChargesPaid  ,      
--vatrate       
-- as vatrate,  
--sum(VATLineAmount)  as  VatAmount,      
--sum(LineAmountInclusiveVAT) as  TotalAmount      
--from VI_importstandardfiles_Processed where TenantId=@tenantId and format(issuedate,'yyyy-MM-dd') between       
--@fromDate and @toDate and invoicetype like 'DN Purchase%'      
--group by IRNNo,IssueDate,BillingReferenceId,InvoiceNumber,VatRate ,PurchaseCategory,RCMApplicable,VATDeffered     
      
  end
GO
