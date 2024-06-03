SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[CreditNoteTransInvoicedItemVATCategoryCodeValidations]  -- exec CreditNoteTransInvoicedItemVATCategoryCodeValidations 657237            
(            
@BatchNo numeric,      
@validstat int      
)            
as        
    
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (48,133,737)            
end            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,            
uniqueidentifier,'0','Invalid VAT Category Code',48,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where invoicetype like 'Credit%'  and transtype = 'Sales' and upper(trim(InvoiceType)) not like '%EXPORT' and VatCategoryCode not in             
(select code from  taxcategory with(nolock))            
and batchid = @batchno              
end            
            
begin            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,            
uniqueidentifier,'0','For Nominal Credit Note  VAT Category Code not matching',133,0,getdate() from ##salesImportBatchDataTemp with(nolock)            
where invoicetype like 'Credit%' and transtype = 'Sales' and upper(trim(InvoiceType)) like '%NOMINAL' and             
Vatcategorycode <> 'O'             
and batchid = @batchno    
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                                      
uniqueidentifier,'0','Please input correct VAT Category Code.',737,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                                     
where invoicetype like 'Credit%' and upper(VatCategoryCode)                  
not in                                        
('E','Z','O') and VatCategoryCode not like 'S'                                   
and batchid = @batchno  
            
end
GO
