SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[TenantMasterDocumentLineIdentifierValidations]  -- exec TenantMasterDocumentLineIdentifierValidations 155123    
(    
@BatchNo numeric    
)    
as  
set nocount on 
begin    
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype = 283    
end    
    
begin    
    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)     
select tenantid,@batchno,uniqueidentifier,'0','Please change the document line identifier number for every additional document updated',283,0,getdate() from ImportMasterBatchData  with(nolock)   
where cast(DocumentLineIdentifier as nvarchar(3)) in    
(select cast(DocumentLineIdentifier as nvarchar(3))  from ImportMasterBatchData where batchid = @batchno     
group by cast(DocumentLineIdentifier as nvarchar(3)) having count(*) > 1) and batchid = @batchno      
    
end
GO
