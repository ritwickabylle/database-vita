SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[TenantMasterDocumentnumberValidations]  -- exec TenantMasterDocumentnumberValidations 20,1          
(            
@BatchNo numeric,        
@validstat int ,  
@tenantid numeric  
)            
as        
set nocount on     
            
declare @Validformat nvarchar(100) = null            
          
begin             
set @Validformat = (select top 1 validformat from documentmaster where code='VAT')            
          
end            
           
begin            
delete from importmaster_ErrorLists where batchid = @BatchNo and errortype =306            
end            
            
         
   begin            
            
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)             
  select tenantid,@batchno,uniqueidentifier,'0','Invalid VAT Number',306,0,getdate()            
from ImportMasterBatchData with(nolock) where DocumentType='VAT' and  Documentnumber  not like @validformat        
  and batchid = @batchno   and VATID not like  @validformat and TenantId=@tenantid         
             
end
GO
