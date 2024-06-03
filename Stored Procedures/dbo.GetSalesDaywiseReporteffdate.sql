SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[GetSalesDaywiseReporteffdate]  --exec GetSalesDaywiseReporteffdate '2023-02-01', '2023-02-28' ,42          
(            
@fromDate Date=null,            
@toDate Date=null,        
@tenantId int=null        
)            
as begin            
--DECLARE @d DATETIME = GETDATE()            
select             
format(effdate ,'yyyy-MM-dd')  --effdate          
  as  InvoiceDate,            
--count(InvoiceNumber) as InvoiceNumber,            
sum(case when InvoiceLineIdentifier = 1 then 1 else 0 end) as invoicenumber,      
isnull(sum(case when (VatCategoryCode='S'  and upper(orgtype)<>'GOVERNMENT'            
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(AdvanceRcptAmtAdjusted ,0) else 0 end ),0)             
 as TaxableAmount, 
 
  isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'              
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)               
  as GovtTaxableAmt, 
            
isnull(sum(case when (VatCategoryCode='Z'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)             
            
 as ZeroRated,   
   
 isnull(sum(case when (VatCategoryCode='E'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)- isnull(advancercptamtadjusted,0) else 0 end ),0)             
            
 as Exempt,    
            
isnull(sum(case when ( BuyerCountryCode not like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)             
            
 as Exports,            
            
          
            
isnull(sum(case when (VatCategoryCode='O'             
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)             
            
 as OutofScope,            
            
            
sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))              
as  VatAmount,            
sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))    as  TotalAmount            
            
            
from VI_importstandardfiles_Processed where TenantId=@tenantId and     
CAST(effdate AS DATE)>=@fromDate and CAST(effdate AS DATE)<=@toDate     
and invoicetype like 'Sales Invoice%'  group by effdate           
            
            
  --select * from VI_importstandardfiles_Processed where InvoiceNumber =1968          
end
GO
