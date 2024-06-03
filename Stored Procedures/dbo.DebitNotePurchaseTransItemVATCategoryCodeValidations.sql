SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[DebitNotePurchaseTransItemVATCategoryCodeValidations]  -- exec DebitNotePurchaseTransItemVATCategoryCodeValidations 657237                 
(                 
@BatchNo numeric,      
@validStat int      
)                 
as                 
begin      
  
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 231          
  
if @validStat=1        
begin                 
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Invalid VAT Category Code',231,0,getdate() from ##salesImportBatchDataTemp                  
where invoicetype like 'DN Purchase%' and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) not like 'IMPORT%' and VatCategoryCode not in                  
(select code from  taxcategory)                 
and batchid = @batchno              
        
end          
end
GO
