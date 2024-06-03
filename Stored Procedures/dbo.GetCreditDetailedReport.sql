SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[GetCreditDetailedReport]   --  exec GetCreditDetailedReport '2022-09-01', '2022-09-30' ,null     
(      
@fromDate Date=null,      
@toDate Date=null,
@tenantId int=null,
@code nvarchar(max)=null,
@type NVARCHAR(MAX)=NULL,    
@text NVARCHAR(MAX)=NULL  
)      
as begin   

--exec GetCreditDetailedReportIssuedate '2022-10-01','2022-11-30',2
declare @sql nvarchar(max)
--exec GetSalesDetailedReportissuedate @fromDate ,@toDate ,@tenantId 

set @sql = (select SPname from ReportCode where Code = @code)

--insert into logs(json,date,batchid) values('Code'+@code,getdate(),@tenantid)
--insert into logs(json,date,batchid) values('SQL'+@sql,getdate(),@tenantid)

if @code is null or @sql is null
begin

exec GetCreditDetailedReportEffdate @fromdate,@todate,@tenantId,@type,@text


end
else
begin
exec @sql @fromDate,@toDate,@tenantId,@code
  end
end

--select       
--select (case when (irnno is null or irnno = '') then InvoiceNumber else irnno end) as IRNNo,BillingReferenceId  as Invoicenumber,Invoicenumber as ReferenceNo,      
--IssueDate as  InvoiceDate,      
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'      
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as TaxableAmount,      
--isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'      
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0) as GovtTaxableAmt,      
--isnull(sum(case when (VatCategoryCode='Z'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0) as ZeroRated,      
--isnull(sum(case when ( BuyerCountryCode <>'SA') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exports,      
--isnull(sum(case when (VatCategoryCode='E'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0) as Exempt,      
--isnull(sum(case when (VatCategoryCode='O'       
--and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0) as OutofScope,      
--vatrate as Vatrate,      
--sum(VATLineAmount)  as  VatAmount,      
--sum(LineAmountInclusiveVAT) as  TotalAmount      
--from VI_importstandardfiles_Processed where TenantId=@tenantId and  format(issuedate,'yyyy-MM-dd') between       
--@fromDate and @toDate and invoicetype like 'Credit Note%'      
--group by IRNNo,IssueDate,BillingReferenceId,InvoiceNumber,VatRate      
--    end  
      
----1 as IRNNo,      
------Invoicenumber      
----1 as Invoicenumber,      
------BillingReferenceId      
----1 as ReferenceNo,      
------IssueDate      
----1 as  InvoiceDate,      
      
------isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)<>'GOVERNMENT'      
------and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0)       
----1 as TaxableAmount,      
------isnull(sum(case when (VatCategoryCode='S' and upper(orgtype)='GOVERNMENT'      
------and BuyerCountryCode ='SA') Then isnull(LineNetAmount,0) else 0 end ),0)       
----1 as GovtTaxableAmt,      
      
------isnull(sum(case when (VatCategoryCode='Z'       
------and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)       
----1 as ZeroRated,      
------isnull(sum(case when ( BuyerCountryCode <>'SA') Then isnull(LineNetAmount ,0) else 0 end ),0)       
----1 as Exports,      
------isnull(sum(case when (VatCategoryCode='E'       
------and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)       
----1 as Exempt,      
------isnull(sum(case when (VatCategoryCode='O'       
------and BuyerCountryCode ='SA') Then isnull(LineNetAmount ,0) else 0 end ),0)       
----1 as OutofScope,      
      
------vatrate       
----1 as Vatrate,      
------sum(VATLineAmount)        
----1 as  VatAmount,      
------sum(LineAmountInclusiveVAT)      
----1 as  TotalAmount      
      
------from VI_importstandardfiles_Processed where format(issuedate,'yyyy-MM-dd') between       
------@fromDate and @toDate and invoicetype like 'Credit Note%'      
------group by IRNNo,IssueDate,InvoiceNumber,VatRate,BillingReferenceId      
      
----end      
GO
