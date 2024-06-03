SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE        PROCEDURE [dbo].[GetSalesDetailedReport]   -- exec GetSalesDetailedReport '2023-07-01', '2023-07-28',127,null,null,'invoicenumber','106' 
(  
@fromDate DATE=NULL,  
@toDate DATE=NULL,
@tenantId INT=NULL,
@code NVARCHAR(MAX)=NULL,
@subcode NVARCHAR(MAX)=NULL,
@type NVARCHAR(MAX)=NULL,
@text NVARCHAR(max)=null
)  
as begin  

declare @sql nvarchar(max)
--exec GetSalesDetailedReportissuedate @fromDate ,@toDate ,@tenantId 

set @sql = (select SPname from ReportCode where Code = @code)

--insert into logs(json,date,batchid) values('Code12'+@code,getdate(),@tenantid)
--insert into logs(json,date,batchid) values('SQL12'+@sql,getdate(),@tenantid)

--select * from logs order by id desc 

if @code is null or @sql is null or len(@sql)=0
begin
  --insert into logs(json,date,batchid) values('NULL123',getdate(),@tenantid)
--select * from logs order by id desc
--exec GetSalesDetailedReporteffdate @fromDate,@toDate,@tenantId
exec GetSalesDetailedReportissuedate @fromDate,@toDate,@tenantId,@type,@text
end
else
begin

if (@subcode is null)
begin 
exec @sql @fromDate,@toDate,@tenantId,@code
end
else 
begin
exec @sql @fromDate,@toDate,@tenantId,@code,@subcode
--select * from logs order by id desc
  end
  end
--select case when (irnno is null or irnno ='') then InvoiceNumber else irnno end as IRNNo,Invoicenumber as Invoicenumber,  
  
--IssueDate  as  InvoiceDate,  
  
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'  
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)   
-- TaxableAmount,  
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'  
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)   
-- as GovtTaxableAmt,  
--isnull(sum(case when (VatCategoryCode='Z'   
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)   
-- as ZeroRated,  
--isnull(sum(case when ( BuyerCountryCode <>'SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)   
-- as Exports,  
--isnull(sum(case when (VatCategoryCode='E'   
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)   
--as Exempt,  
--isnull(sum(case when (VatCategoryCode='O'   
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0)-isnull(advancercptamtadjusted,0) else 0 end ),0)   
-- as OutofScope,  
--vatrate as Vatrate,  
--sum(isnull(VATLineAmount,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0))    
-- as  VatAmount,  
--sum(isnull(LineAmountInclusiveVAT,0)-isnull(VatOnAdvanceRcptAmtAdjusted,0)-isnull(advancercptamtadjusted,0))  
-- as  TotalAmount,  
--BillingReferenceId  
--as ReferenceNo  
--from VI_importstandardfiles_Processed where TenantId=@tenantId and format(issuedate,'yyyy-MM-dd') between   
--@fromDate and @toDate and invoicetype like 'Sales Invoice%'  
--group by IRNNo,IssueDate,InvoiceNumber,BillingReferenceId,VatRate  
  
end
GO
