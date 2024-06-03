SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[SaleTransPaymentMeansValidations]  -- exec SaleTransPaymentMeansValidations 2    
(    
@BatchNo numeric,
@validstat int
)    
as    
begin    
    
-- Invalid Invoice Type    
--insert into      
    
--update ImportStandardFiles set InvoiceType = 'Sales Invoice - Standard' where batchid = @batchno and Invoicetype = 'Sales Invoice - '    
    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 26    
end    
begin    
update ##salesImportBatchDataTemp set PaymentMeans = 'In Cash' where batchid = @BatchNo and PaymentMeans='' or PaymentMeans is null    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Invalid Payment Means',26,0,getdate() from ##salesImportBatchDataTemp     
where InvoiceType  like 'Sales%' and upper(trim(PaymentMeans )) not in (select upper(trim(name)) from paymentmeans)     
and batchid = @batchno      
end    
    
end
GO
