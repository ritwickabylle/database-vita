SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[SalesTransInvoicedItemVATRateValidations]  -- exec SalesTransInvoicedItemVATRateValidations 2  
(  
@BatchNo numeric,
@validstat int,
@tenantid int
)  
as  
begin  
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (17,86)  
 end  
 begin  
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
 select tenantid,@batchno,  
 uniqueidentifier,'0','Invalid VAT Rate',17,0,getdate() from ##salesImportBatchDataTemp   
 where invoicetype like 'Sales%' and upper(trim(InvoiceType)) not like '%EXPORT' and   
 upper(trim(InvoiceType)) not like '%NOMINAL' and upper(trim(InvoiceType)) not like '%OUT of SCOPE'
 and cast(VatCategoryCode as nvarchar)+cast(vatrate as nvarchar) not in   
 (select cast(taxcode as nvarchar)+cast(convert(decimal(5,2),Rate) as nvarchar) from  taxmaster)  
 and batchid = @batchno    and tenantid = @tenantid

 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) 
 select tenantid,@batchno,  
 uniqueidentifier,'0','Nominal Supply should have VAT Rate as Zero',86,0,getdate() from ##salesImportBatchDataTemp   
 where invoicetype like 'Sales%' and upper(trim(InvoiceType)) like '%NOMINAL' and vatrate > 0   
 and batchid = @batchno  and tenantid = @tenantid  

 end
GO
