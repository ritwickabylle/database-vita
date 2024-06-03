SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE            procedure [dbo].[GetSalesDetailedReporteffdate]   -- exec GetSalesDetailedReporteffdate '2023-01-08', '2023-01-10' ,40              
(              
@fromDate Date=null,              
@toDate Date=null,            
@tenantId int=null        
)              
as begin              
set nocount off;        
declare @querystring nvarchar(max)        
declare @spName nvarchar(max)        
declare @sql nvarchar(max)        
        
insert into logs(json,date,batchid) values('GetSalesDetailedReporteffdate',getdate(),@tenantid)    
    
--set @querystring = (select querystring from ReportCode where Code = @code)        
--select * from vi_importstandardfiles_processed        
begin        
select case when (irnno is null or len(trim(irnno)) =0) then InvoiceNumber else irnno end as IRNNo,    
     case when (BillingReferenceId is null or len(trim(billingreferenceid)) = 0 or BillingReferenceId= -1)  then InvoiceNumber else BillingReferenceId end as Invoicenumber,              
    effdate  as  InvoiceDate,               
 isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'              
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)               
  as TaxableAmount,              
 isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'              
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)               
  as GovtTaxableAmt,              
 isnull(sum(case when (VatCategoryCode='Z'        
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)               
  as ZeroRated,  
  isnull(sum(case when (VatCategoryCode='E'               
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)               
 as Exempt,  
 isnull(sum(case when ( BuyerCountryCode not like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)               
  as Exports,              
               
 isnull(sum(case when (VatCategoryCode='O'               
 and BuyerCountryCode like 'SA%') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)               
  as OutofScope,        
 vatrate as Vatrate, sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))                
  as  VatAmount, sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))              
  as  TotalAmount,         
 BillingReferenceId         
 as ReferenceNo         
  from VI_importstandardfiles_Processed              
 where effdate>=@fromDate and effdate<=@toDate  and upper(invoicetype) like 'SALES%' 
 AND  TenantId=@tenantId
 --and orignalSupplyDate < @fromDate        
group by IRNNo,effdate,InvoiceNumber,BillingReferenceId,VatRate             
 --print (@sql)        
 --exec (@sql)        
        
  --TenantId=@tenantId and format(effdate,'yyyy-MM-dd') between               
 --@fromDate and @toDate and invoicetype like 'Sales Invoice%'              
        
end        
        
end    
    
--select * from importbatchdata where tenantid = 2 order by  issuedate effdate
GO
