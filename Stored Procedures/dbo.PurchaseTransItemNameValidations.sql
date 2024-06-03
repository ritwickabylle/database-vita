SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create    procedure [dbo].[PurchaseTransItemNameValidations]-- exec PurchaseTransItemNameValidations 657237    
(    
@BatchNo numeric ,
@validstat int
)    
as    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 176    
end    
    
    
begin    
    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Item Name Cannot be blank',176,0,getdate() from ##salesImportBatchDataTemp     
where invoicetype like 'Purchase%' and (Itemname is null or itemname = '') and batchid = @batchno     
    
    
end
GO
