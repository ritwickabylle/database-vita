SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[CreditNotePurchaseTransInvoiceQtyUnitOfMeasureValidations]-- exec CreditNotePurchaseTransInvoiceQtyUnitOfMeasureValidations          
(          
@BatchNo numeric,
@validstat int
)          
as  
set nocount on
begin          
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 165   
end          
begin          
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)           
select tenantid,@batchno,uniqueidentifier,'0','Unit of Measurement not defined',165,0,getdate() from ##salesImportBatchDataTemp   with(nolock)        
where  invoicetype like 'CN Purchase%' and (UOM is not null and UOM = '') and UOM not in     
(select code from unitofmeasurement) and batchid = @batchno            
end
GO
