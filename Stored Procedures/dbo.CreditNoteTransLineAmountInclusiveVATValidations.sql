SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[CreditNoteTransLineAmountInclusiveVATValidations]  -- exec CreditNoteTransLineAmountInclusiveVATValidations 657237    
(    
@BatchNo numeric,  
@validstat int   
)    
as    
  
begin    
    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (53,189)    
end    
    
begin    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Invalid Line Amount Inclusive VAT',53,0,getdate() from ##salesImportBatchDataTemp with(nolock)    
where invoicetype like 'Credit Note%' and LineAmountInclusiveVAT <> (NetPrice * Quantity) + VATLineAmount and batchid = @batchno     
    
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
--select tenantid,@batchno,uniqueidentifier,'0','Simplified Invoice should be less than 1000SAR',189,0,getdate() from ##salesImportBatchDataTemp  with(nolock)   
--where invoicetype like 'Credit Note%' and LineAmountInclusiveVAT > 1000 and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'Simplified'    
--and batchid = @batchno     
    
end
GO
