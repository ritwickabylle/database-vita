SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             procedure [dbo].[CreditNotePurchaseTransInvoiceItemVATRateValidations]  -- exec CreditNotePurchaseTransInvoiceItemVATRateValidations 953,0             
(                          
@BatchNo numeric,          
@validstat int          
)                          
as         
set nocount on      
begin                          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (171,615)                          
end                          
begin                          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                          
uniqueidentifier,'0','Invalid VAT Rate',171,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                         
where invoicetype like 'CN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not like 'IMPORT%'                 
and concat(VatCategoryCode,cast(vatrate as decimal(5,2))) not in                           
(select concat(taxcode,cast(rate as decimal(5,2))) from  taxmaster)                          
and batchid = @batchno                            
end                          
 begin                          
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                          
 uniqueidentifier,'0','Invalid VAT Category Code',615,0,getdate() from ##salesImportBatchDataTemp   with(nolock)                        
 where invoicetype like 'CN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like 'NOMINAL%' and concat(VatCategoryCode,cast(vatrate as decimal(5,2)))                     
 not in (select concat(taxcode,cast(Rate as decimal(5,2))) from taxmaster)                          
 and batchid = @batchno                            
end
GO
