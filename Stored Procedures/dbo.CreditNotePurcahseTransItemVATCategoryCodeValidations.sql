SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[CreditNotePurcahseTransItemVATCategoryCodeValidations]  -- exec CreditNotePurcahseTransItemVATCategoryCodeValidations 657237        
(        
@BatchNo numeric        
)    

as   
SET NOCOUNT ON
begin        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 170 
end        
begin        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,        
uniqueidentifier,'0','Invalid VAT Category Code',170,0,getdate() from ImportBatchData  with (nolock)       
where invoicetype like 'Credit%' and trim(substring(InvoiceType,16,len(InvoiceType)-15)) <> 'IMPORT' and VatCategoryCode not in         
(select code from  taxcategory)        
and batchid = @batchno     
end
GO
