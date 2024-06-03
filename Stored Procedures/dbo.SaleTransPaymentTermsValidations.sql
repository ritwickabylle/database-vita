SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE       procedure [dbo].[SaleTransPaymentTermsValidations]  -- exec SaleTransPaymentTermsValidations 126755    
(    
@BatchNo numeric,    
@validstat int     
)    
as    
  
set nocount on   
begin    
    
    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 27    
end    
begin    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','For Payment means "Transfer, Credit" Payment Terms cannot be blank',27,0,getdate() from ##salesImportBatchDataTemp  with(nolock)   
where InvoiceType  like 'Sales Invoice%' and Paymentmeans <> 'In Cash' and (paymentterms is null or PaymentTerms ='') and batchid = @batchno      
end    
    
end
GO
