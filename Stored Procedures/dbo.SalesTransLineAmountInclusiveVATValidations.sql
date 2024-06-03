SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[SalesTransLineAmountInclusiveVATValidations]  -- exec SalesTransLineAmountInclusiveVATValidations 657237  
(  
@BatchNo numeric,  
@validstat int,
@tenantid int
)  
as  
begin  
  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (22,187,307,727)  
end  
  
begin  

  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Invalid Line Amount Inclusive VAT',22,0,getdate() from ##salesImportBatchDataTemp   
where invoicetype like 'Sales Invoice%' and LineAmountInclusiveVAT <> (NetPrice * Quantity) + VATLineAmount and batchid = @batchno  and tenantid = @tenantid 
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Simplified Invoice should be less than 1000 SAR or Buyer VAT ID should be blank(B2C)',187,0,getdate() from ##salesImportBatchDataTemp   
where invoicetype like 'Sales Invoice%' and LineAmountInclusiveVAT > 1000 and BuyerVatCode is not null
and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like '%SIMPLIFIED%'  
and batchid = @batchno   and tenantid = @tenantid            --15-12-2023
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
select tenantid,@batchno,uniqueidentifier,'0','Amount less than 1000SAR, is this a Simplified Invoice',307,0,getdate() from ##salesImportBatchDataTemp   
where invoicetype like 'Sales Invoice%' and LineAmountInclusiveVAT < 1000 and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'Standard'  
and batchid = @batchno   

--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)   
--select tenantid,@batchno,uniqueidentifier,'0','VAT ID is blank, is this a Simplified Invoice',727,0,getdate() from ##salesImportBatchDataTemp   
--where invoicetype like 'Sales Invoice%' and BuyerCountryCode like 'SA%' and (BuyerVatCode is null or BuyerVatCode ='') 
--and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'Standard'  
--and batchid = @batchno     --15-12-2023
end
GO
