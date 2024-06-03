SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[GetPurchaseDaywiseReport] --exec GetPurchaseDaywiseReport '2023-11-01', '2023-11-30' ,148 
(      
@fromDate Date=null,      
@toDate Date=null,  
@tenantId int=null  
)      
as begin      
      
select       
format(cast(IssueDate as date),'dd-MM-yyyy')       
 as  InvoiceDate,      
count(*)        
 as InvoiceNumber,      
      
format(isnull(sum(case when (VatCategoryCode='S'       
and LEFT(BuyerCountryCode,2) like 'SA%') Then isnull(LineNetAmount,0) else 0 end ),0),'#,##0.00')        
 as TaxableAmount,      
      
format(isnull(sum(case when (VatCategoryCode='Z'       
and LEFT(BuyerCountryCode,2) like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')        
 as ZeroRated,      
      
format(isnull(sum(case when ( VatCategoryCode='S'  and VATDeffered=1) Then isnull(LineNetAmount ,0)       
else 0 end ),0),'#,##0.00')        
 as ImportsatCustoms,      
      
format(isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable=1) Then isnull(LineNetAmount ,0)       
else 0 end ),0),'#,##0.00')       
 as ImportsatRCM,      
      
rcmapplicable      
      
 as RCMApplicable,      
      
vatdeffered       
 as VATDeffered,      
      
format(sum(customspaid),'#,##0.00')        
 as CustomsPaid,      
      
format(sum(excisetaxpaid),'#,##0.00')       
 as ExciseTaxPaid,      
      
format(sum(OtherChargespaid),'#,##0.00')       
 as OtherChargesPaid  ,      
      
Purchasecategory      
 as PurchaseCategory,      
      
format(isnull(sum(case when (VatCategoryCode='E'       
and LEFT(BuyerCountryCode,2) like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')        
 as Exempt, 
 format(isnull(sum(case when (VatCategoryCode='O'         
and LEFT(BuyerCountryCode,2) like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')  as OutofScope,
      
--sum(VATLineAmount)       
   format(isnull(sum(case when RCMApplicable=1 then 0
   when VATDeffered=1 then 0  else isnull(VATLineAmount,0) end),0),'#,##0.00')             

 as  VatAmount,      
      
format(sum(LineAmountInclusiveVAT),'#,##0.00')       
 as  TotalAmount      
      
from VI_importstandardfiles_Processed 
where TenantId=@tenantId and IssueDate >=@fromDate and IssueDate<=@toDate
--and format(issuedate,'yyyy-MM-dd') between       
--@fromDate and @toDate 
and invoicetype like 'Purchase%'      
group by cast(IssueDate as date),PurchaseCategory,RCMApplicable,VATDeffered      
ORDER BY CAST(ISSUEDATE AS DATE),PurchaseCategory,RCMApplicable,VATDeffered        
      
      
      
end
GO
