SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[CreditNoteTransItemGrossPriceValidations]-- exec CreditNoteTransItemGrossPriceValidations 657237            
(            
@BatchNo numeric,    
@validstat int    
)            
as       
   
begin            
            
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 44           
end            
            
begin            
            
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)             
select tenantid,@batchno,uniqueidentifier,'0','Gross Price Cannot be <= Zero',44,0,getdate() from ##salesImportBatchDataTemp  with(nolock)           
where invoicetype like 'Credit%' and Grossprice <=0 and batchid = @batchno             
            
end
GO
