SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create    procedure [dbo].[PaymentGLHeadValidations]-- exec PaymentGLHeadValidations 657237    
(    
@BatchNo numeric    
)    
as    
begin    
    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 113   
end    
    
begin    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','GL Head cannot be blank',113,0,getdate() from ImportBatchData     
where invoicetype like 'WHT%' and (LedgerHeader is null or LedgerHeader='') and batchid = @batchno     
    
end
GO
