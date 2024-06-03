SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[GetCreditDetailedReportUnderAdjustments]   --  exec GetCreditDetailedReportUnderAdjustments '2023-04-08', '2023-04-30' ,'VATCNS001',33           
(              
@fromDate Date=null,              
@toDate Date=null,  
@tenantId int=null,
@code nvarchar(max)               

)              
as begin              
              
--select               
select (case when (irnno is null or irnno = '') then InvoiceNumber else irnno end) as IRNNo,BillingReferenceId  as Invoicenumber,   
BuyerName as CustomerName,
format(effdate,'dd-MM-yyyy') as  InvoiceDate,              
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'              
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0) else 0 end ),0) as TaxableAmount,              
isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'              
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,              
isnull(sum(case when (VatCategoryCode='Z'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as ZeroRated,              
isnull(sum(case when ( BuyerCountryCode not like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exports,              
isnull(sum(case when (VatCategoryCode='E'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exempt,              
isnull(sum(case when (VatCategoryCode='O'               
and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,              
vatrate as Vatrate,              
sum(VATLineAmount)  as  VatAmount,              
sum(LineAmountInclusiveVAT) as  TotalAmount              
from VI_importstandardfiles_Processed where TenantId=@tenantId       
and  effdate >=@fromDate and effdate<=@toDate       
and invoicetype like 'Credit Note%'              
group by effdate,IRNNo,Billingreferenceid,invoicenumber,VatRate,BuyerName              
    end       
      
-- select * from importbatchdata where batchid = 6      
GO
