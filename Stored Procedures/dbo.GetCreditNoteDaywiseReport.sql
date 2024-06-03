SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[GetCreditNoteDaywiseReport]    
(    
@fromDate Date=null,    
@toDate Date=null,
@tenantId int=null
)    
as begin    
   -- exec GetCreditNoteDaywiseReportissuedate @fromdate,@todate,@tenantId
	exec GetCreditNoteDaywiseReporteffdate @fromdate,@todate,@tenantId
--select     
--count(*) as Invoicenumber,   
--Issuedate    
--as  InvoiceDate,    
   
   
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'    
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0)     
-- as TaxableAmount,    
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'    
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0)     
-- as GovtTaxableAmt,    
--isnull(sum(case when (VatCategoryCode='Z'     
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)    
-- as ZeroRated,    
--isnull(sum(case when ( BuyerCountryCode <>'SA') Then isnull(LineNetAmount ,0) else 0 end ),0)     
-- as Exports,    
    
--isnull(sum(case when (VatCategoryCode='E'     
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)    
-- as Exempt,   
-- isnull(sum(case when (VatCategoryCode='O'     
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,  
----vatRate as  VatRate,    
--sum(VATLineAmount)  as  VatAmount,    
--sum(LineAmountInclusiveVAT)  as  TotalAmount   
       
--from VI_importstandardfiles_Processed where TenantId=@tenantId and format(issuedate,'yyyy-MM-dd') between     
--@fromdate and @todate and invoicetype like 'Credit Note%'    
--group by IssueDate   
    
end
GO
