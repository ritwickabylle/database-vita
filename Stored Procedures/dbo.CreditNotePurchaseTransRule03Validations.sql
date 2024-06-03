SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create         procedure [dbo].[CreditNotePurchaseTransRule03Validations]  -- exec CreditNotePurchaseTransRule03Validations 657237      
(      
@BatchNo numeric,
@validstat int
)      
as  
set nocount on
begin      
 delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 534    
 end      
 begin      
 insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,      
 uniqueidentifier,'0','Net Price for nominal cannot be greater than 200.00',534,0,getdate() from ##salesImportBatchDataTemp  with(nolock)      
where invoicetype like 'Credit%' and transtype = 'Purchase' and upper(trim(substring(InvoiceType,16,len(InvoiceType)-15))) = 'NOMINAL' and     
upper(trim(Vatcategorycode)) = 'O'   and NetPrice > 200.00  
and batchid = @batchno        
 end
GO
