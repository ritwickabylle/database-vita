SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[CustomerMasterDocumentTypeValidations]  -- exec CustomerMasterDocumentTypeValidations 462453                      
(               
@batchno numeric,            
@tenantid numeric,          
@validstat int          
              
)                     
              
as         
set nocount on       
begin          
          
         
begin                     
              
delete from importmaster_ErrorLists where tenantid=@tenantid and errortype in (295,581)               
end           
          
          
begin               
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)              
select tenantid,@batchno,uniqueidentifier,'0','Please update Valid Document Type',295,0,getdate() from ImportMasterBatchData  with(nolock)             
 where DocumentType not in (select DocumentTypeCode from CustomerDocuments) and batchid=@batchno and tenantid=@tenantid            
            
end  
begin               
insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)              
select tenantid,@batchno,uniqueidentifier,'0','Document Type cannot be blank',581,0,getdate() from ImportMasterBatchData  with(nolock)             
 where (DocumentType is null or len(DocumentType)=0) and (DocumentNumber is not null or len(DocumentNumber)>0) and batchid=@batchno and tenantid=@tenantid            
            
end      
              
end
GO
