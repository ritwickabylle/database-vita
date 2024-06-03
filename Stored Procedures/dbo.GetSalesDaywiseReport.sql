SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[GetSalesDaywiseReport]  --exec GetSalesDaywiseReport '2023-02-08', '2023-02-08', 2    
(      
@fromDate Date=null,      
@toDate Date=null,  
@tenantId int=null  
)      
as begin  

exec GetSalesDaywiseReportissuedate @fromdate,@toDate,@tenantId

--exec GetSalesDaywiseReporteffdate @fromdate,@toDate,@tenantId


end

--DECLARE @d DATETIME = GETDATE()      
----select       
--format(Issuedate ,'yyyy-MM-dd')  --IssueDate    
--  as  InvoiceDate,      
--count(InvoiceNumber) as InvoiceNumber,      
--isnull(sum(case when (VatCategoryCode='S'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted ,0) else 0 end ),0)       
-- as TaxableAmount,      
      
--isnull(sum(case when (VatCategoryCode='Z'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)       
      
-- as ZeroRated,      
      
--isnull(sum(case when ( BuyerCountryCode <>'SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)       
      
-- as Exports,      
      
--isnull(sum(case when (VatCategoryCode='E'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)- isnull(advancercptamtadjusted,0) else 0 end ),0)       
      
-- as Exempt,      
      
--isnull(sum(case when (VatCategoryCode='O'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)       
      
-- as OutofScope,      
      
      
--sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))        
--as  VatAmount,      
--sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))    as  TotalAmount      
      
      
--from VI_importstandardfiles_Processed where TenantId=@tenantId and format(issuedate,'yyyy-MM-dd') between       
--@fromdate and @todate and invoicetype like 'Sales Invoice%'  group by IssueDate      
      
      
  --select * from VI_importstandardfiles_Processed where InvoiceNumber =1968    
GO
