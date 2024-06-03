SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[DebitNoteTransLineAmountInclusiveVATValidations]  -- exec DebitNoteTransLineAmountInclusiveVATValidations 68        
(        
@BatchNo numeric ,
@validstat int
)        
as     
set nocount on  
begin        
        
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype in (228,229)        
end        
        
begin        
        
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
select tenantid,@batchno,uniqueidentifier,'0','Invalid Line Amount Inclusive VAT',228,0,getdate() from ##salesImportBatchDataTemp    with(nolock)     
where invoicetype like 'Debit Note%' and LineAmountInclusiveVAT <> (NetPrice * Quantity) + VATLineAmount and batchid = @batchno         
        
--insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)         
--select tenantid,@batchno,uniqueidentifier,'0','Simplified DebitNote should be less than 1000SAR',229,0,getdate() from ##salesImportBatchDataTemp  with(nolock)       
--where invoicetype like 'Debit Note%' and LineAmountInclusiveVAT > 1000 and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) like '%Simplified%'        
--and batchid = @batchno         
        
end       
    
--select * from ##salesImportBatchDataTemp  where batchid=68     
--delete from importstandardfiles_ErrorLists where batchid=68     
--where invoicetype like 'Debit Note%' and LineAmountInclusiveVAT > 1000 and upper(trim(RIGHT(invoicetype , LEN(invoicetype) - CHARINDEX('-', invoicetype) ))) = 'Simplified'        
--and batchid = 68     
GO
