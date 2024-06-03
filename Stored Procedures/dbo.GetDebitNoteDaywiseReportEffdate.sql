SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[GetDebitNoteDaywiseReportEffdate]              
(              
@fromDate Date=null,              
@toDate Date=null,          
@tenantId int=null          
)              
as begin              
              
select               
            
 format(effdate ,'dd-MM-yyyy') --effdate               
as  InvoiceDate,              
  sum(case when InvoiceLineIdentifier = 1 then 1 else 0 end) as Invoicenumber,             
             
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'              
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0) else 0 end ),0)               
 as TaxableAmount,              
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'              
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0) else 0 end ),0)               
 as GovtTaxableAmt,              
isnull(sum(case when (VatCategoryCode='Z'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0)              
 as ZeroRated,              
isnull(sum(case when ( BuyerCountryCode not like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0)               
 as Exports,              
              
isnull(sum(case when (VatCategoryCode='E'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0)              
 as Exempt,             
 isnull(sum(case when (VatCategoryCode='O'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,            
--vatRate as  VatRate,              
sum(VATLineAmount)  as  VatAmount,              
sum(LineAmountInclusiveVAT)  as  TotalAmount             
                 
from VI_importstandardfiles_Processed       
where TenantId=@tenantId and CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate      
--format(effdate,'yyyy-MM-dd') between               
--@fromdate and @todate       
and invoicetype like 'Debit Note%'              
group by effdate             
              
end
GO
