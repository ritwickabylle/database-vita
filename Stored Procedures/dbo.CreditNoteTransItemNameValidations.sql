SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNoteTransItemNameValidations]-- exec CreditNoteTransItemNameValidations 657237            
(            
@BatchNo numeric,    
@validstat int     
)            
as       
    
begin            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 42            
end            
            
            
begin            
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Item Name Cannot be blank',42,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where invoicetype like 'Credit%' and (Itemname is null or len(itemname) = 0) and batchid = @batchno             
            
            
end
GO
