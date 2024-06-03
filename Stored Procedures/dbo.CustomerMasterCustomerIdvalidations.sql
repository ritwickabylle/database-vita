SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create           procedure [dbo].[CustomerMasterCustomerIdvalidations]  -- exec CustomerMasterCustomerIdvalidations 114,2,1        
(                 
@BatchNo numeric,        
@tenantid numeric,      
@validstat int      
)          
as        
set nocount on     
begin       
      
if @validstat=1      
begin          
delete from importmaster_ErrorLists where tenantid=@tenantid  and batchid=@BatchNo and errortype = 288         
end        
      
--if @validstat=1      
--begin          
--insert into importmaster_ErrorLists(tenantid,Batchid,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)          
--select tenantid,@BatchNo,uniqueidentifier,'0','Customer Id cannot be blank',288,0,getdate() from ImportMasterBatchData   with(nolock)        
----where tenantid = '' or tenantid is null  and batchid=@BatchNo           
-- where MasterId not in (select id from Customers with(nolock)  ) and batchid=@BatchNo        
                  
          
--end                 
          
end
GO
