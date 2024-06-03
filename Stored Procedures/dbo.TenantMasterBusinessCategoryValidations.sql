SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[TenantMasterBusinessCategoryValidations]  -- exec TenantMasterBusinessCategoryValidations 155123              
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
delete from importmaster_ErrorLists  where batchid = @BatchNo and tenantid=@tenantid and errortype in (301,593)            
end              
      
if @validstat=1              
begin              
              
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Business Category not defined in master',301,0,getdate() from ImportMasterBatchData with(nolock)              
where  upper(BusinessCategory) <> 'MIXED' and          
upper(BusinessCategory)  not in (select upper(name) from TransactionCategory with(nolock))          
 and batchid = @BatchNo           
 and tenantid=@tenantid          
                   
              
end
begin              
              
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Business Category cannot be blank',593,0,getdate() from ImportMasterBatchData with(nolock)              
where  (upper(BusinessCategory) is null or len(BusinessCategory)=0)          
 and batchid = @BatchNo           
 and tenantid=@tenantid          
                   
              
end  
end
GO
