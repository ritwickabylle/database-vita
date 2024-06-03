SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE     procedure [dbo].[PaymentNatureofServiceValidations]  -- exec [PaymentNatureofServiceValidations] 155123    
(    
@BatchNo numeric,  
@validstat int,  
@tenantid int  
)    
as    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 114    
end    
    
    
    
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime) select tenantid,@batchno,    
uniqueidentifier,'0','Nature of Service Does Not exists in Masters',114,0,getdate() from ImportBatchData     
where invoicetype like 'WHT%' and (NatureofServices  is null or NatureofServices  ='')  and batchid = @batchno      
    
    
end    
  
--update ErrorType set ErrorGroupId = 3 where code = 114
GO
