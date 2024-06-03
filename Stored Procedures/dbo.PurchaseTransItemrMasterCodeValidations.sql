SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[PurchaseTransItemrMasterCodeValidations]  -- exec PurchaseTransItemrMasterCodeValidations 657237    
(    
@BatchNo numeric,
@validstat int
)    
as    
begin    
    
    
begin    
delete from importstandardfiles_errorlists where batchid = @BatchNo and errortype = 175    
end    
begin    
insert into importstandardfiles_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Invalid Item Master Code',175,0,getdate() from ##salesImportBatchDataTemp     
where invoicetype like 'Purchase%' and BuyerMasterCode is null and BuyerMasterCode= '' and batchid = @batchno      
end    
    
    
end
GO
