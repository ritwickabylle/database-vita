SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[GetSalesDetailedReporteffdateUnderAdjustments]   -- exec GetSalesDetailedReporteffdateUnderAdjustments '2022-12-01', '2022-12-30',19,'VATSAL002'                      
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
                            
begin                
select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as Invoicenumber, 
BuyerName as CustomerName,
    format(effdate ,'dd-MM-yyyy') as  InvoiceDate,                       
 isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'                      
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                       
  TaxableAmount,                      
 isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'                      
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                       
  as GovtTaxableAmt,                      
 isnull(sum(case when (VatCategoryCode='Z'                
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                       
  as ZeroRated,                      
 isnull(sum(case when ( BuyerCountryCode not like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                       
  as Exports,                      
 isnull(sum(case when (VatCategoryCode='E'                       
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                       
 as Exempt,                      
 isnull(sum(case when (VatCategoryCode='O'                       
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)                       
  as OutofScope,                
 vatrate as Vatrate, sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))                        
  as  VatAmount, sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))                      
  as  TotalAmount,                 
 BillingReferenceId                 
 as ReferenceNo                 
 from VI_importstandardfiles_Processed                   
 where CAST(IssueDate AS DATE)>=@fromDate and CAST(IssueDate AS DATE)<=@toDate and InvoiceType like '%Credit%'        
 and orignalSupplyDate < @fromDate                
AND TenantId=@tenantId            
group by IRNNo,effdate,InvoiceNumber,BillingReferenceId,VatRate,BuyerName         
end                
                
end
GO
