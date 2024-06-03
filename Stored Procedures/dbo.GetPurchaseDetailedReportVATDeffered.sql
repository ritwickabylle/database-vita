SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[GetPurchaseDetailedReportVATDeffered]   -- exec GetPurchaseDetailedReportVATDeffered '2023-02-01', '2022-12-30',19,'VATPUR004'                        
(                        
@fromDate Date=null,                        
@toDate Date=null,                      
@tenantId int=null,                  
@code nvarchar(max)                  
)                        
as begin                        
set nocount off;                  
declare @querystring nvarchar(max)                  
declare @spName nvarchar(max)                  
declare @sql nvarchar(max)                  
                  
                  
set @querystring = (select querystring from ReportCode where Code = @code)                  
                  
print @querystring                   
                  
if @querystring is not null                   
begin                  
  select             
  format(IssueDate,'dd-MM-yyyy')             
   as  InvoiceDate,            
  InvoiceNumber            
  as InvoiceNumber,            
  BuyerName as VendorName,
  sum(case when (trim(VatCategoryCode)='S'             
  and trim(BuyerCountryCode) like 'SA%') Then isnull(LineNetAmount,0) else 0 end )          
   as TaxableAmount,            
            
  isnull(sum(case when (VatCategoryCode='Z'             
  ) Then isnull(LineNetAmount ,0) else 0 end ),0)            
  --and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)            
   as ZeroRated,            
            
  isnull(sum(case when ( VatCategoryCode='S' and VATDeffered='True') Then isnull(LineNetAmount ,0)             
  else 0 end ),0)            
            
   as ImportsatCustoms,            
            
  isnull(sum(case when ( VatCategoryCode='S'  and RCMApplicable='True') Then isnull(LineNetAmount ,0)             
  else 0 end ),0)             
   as ImportsatRCM,            
  rcmapplicable             
   as RCMApplicable,            
  vatdeffered             
   as VATDeffered,            
            
  sum(customspaid)             
   as CustomsPaid,            
            
  sum(excisetaxpaid)             
   as ExciseTaxPaid,            
  sum(OtherChargespaid)            
   as OtherChargesPaid  ,            
  Purchasecategory             
   as PurchaseCategory,            
  vatrate             
   as vatrate,            
            
  isnull(sum(case when (VatCategoryCode='E'             
  and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0)             
   as Exempt,        
   isnull(sum(case when (VatCategoryCode='O'             
  and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,     
            
  sum(VATLineAmount)              
   as  VatAmount,            
            
  sum(LineAmountInclusiveVAT)             
   as  TotalAmount            
                           
 from VI_importstandardfiles_Processed  with (nolock)               
 where CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate and InvoiceType like 'Purchase%'   and VATDeffered is not null and VATDeffered=1                 
AND TenantId=@tenantId              
group by IssueDate,PurchaseCategory,RCMApplicable,VATDeffered,InvoiceNumber ,VatRate,BuyerName                      
                      
                  
end                  
                  
end
GO
