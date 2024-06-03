SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
        
CREATE    procedure [dbo].[GetCreditNotePurchaseDaywiseReporteffdate]   --  exec GetCreditNotePurchaseDaywiseReporteffdate '2023-11-01', '2023-11-29',148            
(            
@fromDate Date=null,            
@toDate Date=null,      
@tenantId int=null      
)            
as begin            
        
--select             
select   format(effdate ,'dd-MM-yyyy')  --IssueDate       
 as  InvoiceDate,count(invoicenumber) as invoicecount,        
purchasecategory as Purchasecategory,            
format(isnull(sum(case when (trim(VatCategoryCode)='S'             
and trim(BuyerCountryCode) like 'SA%') Then isnull(LineNetAmount,0) else 0 end) ,0),'#,##0.00')           
 as TaxableAmount,          
         
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'            
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,            
format(isnull(sum(case when (VatCategoryCode='Z'             
) Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')             
    --and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)            
 as ZeroRated,          
format(isnull(sum(case when (VatCategoryCode='E'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as Exempt,            
format(isnull(sum(case when (VatCategoryCode='O'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as OutofScope,            
format(isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='0' and BuyerCountryCode not like 'SA%')         
Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as ImportVATCustoms,        
format(isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='0' and VATDeffered='1' and BuyerCountryCode not like 'SA%')         
Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as VATDeffered,        
format(isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='1') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as ImportsatRCM,            
format(sum(isnull(customspaid,0)),'#,##0.00')              
 as CustomsPaid,            
format(sum(isnull(excisetaxpaid,0)),'#,##0.00')              
 as ExciseTaxPaid,            
format(sum(isnull(OtherChargespaid,0)),'#,##0.00')             
 as OtherChargesPaid  ,            
format(sum(VATLineAmount),'#,##0.00')   as  VatAmount,            
format(sum(LineAmountInclusiveVAT),'#,##0.00')  as  TotalAmount            
from VI_importstandardfiles_Processed where  TenantId=@tenantId and   
CAST(effdate AS DATE)>=@fromDate and CAST(effdate AS DATE)<=@toDate  
and invoicetype like 'CN Purchase%'            
group by effdate,purchasecategory           
            
  end
GO
