SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             procedure [dbo].[GetSalesDaywiseReportissuedate]  --exec GetSalesDaywiseReportissuedate '2023-01-21', '2024-02-21', 148        
(            
@fromDate Date=null,              
@toDate Date=null,          
@tenantId int=null          
)              
as begin              
--DECLARE @d DATETIME = GETDATE()              
select               
format(issuedate ,'dd-MM-yyyy')  --effdate            
  as  InvoiceDate,              
--count(InvoiceNumber) as InvoiceNumber,              
sum(case when InvoiceLineIdentifier = 1 then 1 else 0 end) as invoicenumber,        
format(isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'              
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted ,0) else 0 end ),0),'#,0.00')               
 as TaxableAmount,   
  format(isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'                
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0),'#,0.00')                
  as GovtTaxableAmt,    
              
format(isnull(sum(case when (VatCategoryCode='Z'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0),'#,0.00')            
              
 as ZeroRated,     
     
 format(isnull(sum(case when (VatCategoryCode='E'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)- isnull(advancercptamtadjusted,0) else 0 end ),0),'#,0.00')           
              
 as Exempt,      
              
format(isnull(sum(case when ( BuyerCountryCode not like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0),'#,0.00')              
              
 as Exports,              
              
            
              
format(isnull(sum(case when (VatCategoryCode='O'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0),'#,0.00')               
              
 as OutofScope,              
              
              
format(sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)),'#,0.00')              
as  VatAmount,              
format(sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0)),'#,0.00')    as  TotalAmount              
              
              
from VI_importstandardfiles_Processed where TenantId=@tenantId and       
CAST(issuedate AS DATE)>=@fromDate and CAST(issuedate AS DATE)<=@toDate       
and invoicetype like 'Sales Invoice%'  group by  format(issuedate ,'dd-MM-yyyy')              
              
              
  --select * from VI_importstandardfiles_Processed where InvoiceNumber =1968            
end
GO
