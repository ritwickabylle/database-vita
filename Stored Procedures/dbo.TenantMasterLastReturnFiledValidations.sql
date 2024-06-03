SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[TenantMasterLastReturnFiledValidations]  -- exec TenantMasterLastReturnFiledValidations 156         
(            
@BatchNo numeric, 
@tenantid numeric,
@validstat int    
)            
as     
set nocount on   
            
begin            
delete from importmaster_ErrorLists where batchid = @BatchNo and errortype in (287,347)           
end            
          
   begin            
              
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)             
  select tenantid,@batchno,uniqueidentifier,'0','Please check and correct the LastReturnFiled Date',287,0,getdate()            
from ImportMasterBatchData  with(nolock) where LastReturnFiled is not null and format(try_cast(LastReturnFiled as date),'yyyy-MM-dd') <>         
eomonth(format(try_cast(LastReturnFiled as date),'yyyy-MM-dd'))           
and LastReturnFiled <= eomonth(dateadd(month,-1,GETDATE()))            
  and batchid = @batchno   and tenantid=@tenantid          
           
 insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)             
  select tenantid,@batchno,uniqueidentifier,'0','Registration Date cannot be greater than Last Return Filed',347,0,getdate()            
from ImportMasterBatchData  with(nolock) where LastReturnFiled is not null and RegistrationDate is not null and LastReturnFiled < RegistrationDate       
  and batchid = @batchno   and tenantid=@tenantid           
            
end
GO
