SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
CREATE     procedure [dbo].[DebitNotePurchaseTransInvoiceItemVATRateValidations]  -- exec DebitNotePurchaseTransInvoiceItemVATRateValidations 657237                           
(                           
@BatchNo numeric ,        
@validstat int        
)                           
          
as                           
begin          
    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in(128,134)                           
  
if @validstat=1         
begin                           
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                           
uniqueidentifier,'0','Invalid VAT Rate',128,0,getdate() from ##salesImportBatchDataTemp                            
where invoicetype like 'DN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not like 'IMPORT'                  
and concat(VatCategoryCode,cast(vatrate as decimal(5,2))) not in    
(select concat(taxcode,cast(rate as decimal(5,2))) from  taxmaster)  
--(select upper(TaxId)+'.00' from  taxmaster)                           
and batchid = @batchno                             
end        
end        
-- begin                           
-- insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                           
-- uniqueidentifier,'0','Invalid VAT Category Code',134,0,getdate() from ImportStandardFiles                            
-- where invoicetype like 'DN Purchase%' and upper(trim(substring(InvoiceType,16,len(InvoiceType)-15))) = 'NOMINAL' and concat(VatCategoryCode,cast(vatrate as decimal(5,2)))                      
-- in (select concat(taxcode,cast(Rate as decimal(5,2))) from taxmaster)                           
-- and batchid = @batchno                             
--end      
GO
