SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create             procedure [dbo].[DebitNoteTransInvoicedItemVATCategoryCodeValidations]  -- exec DebitNoteTransInvoicedItemVATCategoryCodeValidations 657237                
(                
@BatchNo numeric ,    
@validstat int    
)                
as                
begin                
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (220,221,738)                
end                
begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                
uniqueidentifier,'0','Invalid VAT Category Code',220,0,getdate() from ##salesImportBatchDataTemp                 
where invoicetype like 'Debit Note%'  and transtype = 'Sales' and upper(trim(InvoiceType)) not like '%EXPORT' and VatCategoryCode not in                 
(select code from  taxcategory)                
and batchid = @batchno                  
end                
                
begin                
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,                
uniqueidentifier,'0','For Nominal Debit Note  VAT Category Code not matching',221,0,getdate() from ##salesImportBatchDataTemp                 
where invoicetype like 'Debit Note%' and transtype = 'Sales' and upper(trim(InvoiceType)) like '%NOMINAL' and                 
Vatcategorycode <> 'O'                 
and batchid = @batchno     
  
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,                                      
uniqueidentifier,'0','Please input correct VAT Category Code.',738,0,getdate() from ##salesImportBatchDataTemp  with(nolock)                                     
where invoicetype like 'Debit Note%' and upper(VatCategoryCode)                  
not in                                        
('E','Z','O') and VatCategoryCode not like 'S'                                   
and batchid = @batchno  
                
end
GO
