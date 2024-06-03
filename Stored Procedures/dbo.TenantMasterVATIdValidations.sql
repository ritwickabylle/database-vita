SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             procedure [dbo].[TenantMasterVATIdValidations]  -- exec TenantMasterVATIdValidations 20,1              
(                
@BatchNo numeric,
@tenantid numeric,
@validstat int        
)                
as        
set nocount on       
declare @Validformat nvarchar(100) = null            
          
begin             
set @Validformat = (select top 1 validformat from documentmaster where code='VAT')            
end            
                 
begin                
delete from importmaster_ErrorLists where batchid = @BatchNo and errortype in(305,311)                
end                
                
begin                
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                 
  select tenantid,@batchno,uniqueidentifier,'0','Please check and correct the VAT Id',305,0,getdate()                
from ImportMasterBatchData with(nolock) where  len(vatid)>0 and VATID  not like @Validformat             
  and batchid = @batchno   and tenantid=@tenantid          
        
  insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                 
  select tenantid,@batchno,uniqueidentifier,'0','VAT ID cannot be blank',311,0,getdate()                
from ImportMasterBatchData with(nolock) where (len(vatid)=0 or vatid is null) and (DocumentType='VAT' and len(trim(DocumentNumber))=0) and batchid=@BatchNo   and tenantid=@tenantid         
               
end
GO
