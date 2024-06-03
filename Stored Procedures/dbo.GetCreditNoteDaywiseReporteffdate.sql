SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[GetCreditNoteDaywiseReporteffdate]    -- exec GetCreditNoteDaywiseReporteffdate '2023-11-01', '2023-11-30',148      
(          
@fromDate Date=null,          
@toDate Date=null,      
@tenantId int=null      
)          
as begin          
          
select           
         
format(effdate,'dd-MM-yyyy')          
as  InvoiceDate,    
  
sum(case when InvoiceLineIdentifier = 1 then 1 else 0 end) as Invoicenumber,  
         
         
format(isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'          
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0) else 0 end ),0),'#,##0.00')           
 as TaxableAmount,          
format(isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'          
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0) else 0 end ),0),'#,##0.00')           
 as GovtTaxableAmt,          
format(isnull(sum(case when (VatCategoryCode='Z'           
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')          
 as ZeroRated,          
format(isnull(sum(case when ( BuyerCountryCode not like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')           
 as Exports,          
          
format(isnull(sum(case when (VatCategoryCode='E'           
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00')          
 as Exempt,         
 format(isnull(sum(case when (VatCategoryCode='O'           
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0),'#,##0.00') as OutofScope,        
--vatRate as  VatRate,          
format(sum(VATLineAmount),'#,##0.00')  as  VatAmount,          
format(sum(LineAmountInclusiveVAT),'#,##0.00')  as  TotalAmount         
             
from VI_importstandardfiles_Processed where TenantId=@tenantId and     
CAST(effdate AS DATE)>=@fromDate and CAST(effdate AS DATE)<=@toDate    
and invoicetype like 'Credit Note%'          
group by effdate         
          
end
GO
