SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
create      procedure [dbo].[VendorMasterDocumentLineIdentifierValidations]  -- exec VendorMasterDocumentLineIdentifierValidations 155123      
(      
@BatchNo numeric      
)      
as      
begin      
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype = 373     
end      
      
begin      
      
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)       
select tenantid,@batchno,uniqueidentifier,'0','Duplicate Document Line Item',373,0,getdate() from ImportMasterBatchData       
where cast(DocumentLineIdentifier as nvarchar(3)) in      
(select cast(DocumentLineIdentifier as nvarchar(3))  from ImportMasterBatchData where batchid = @batchno       
group by cast(DocumentLineIdentifier as nvarchar(3)) having count(*) > 1) and batchid = @batchno        
      
end
GO
