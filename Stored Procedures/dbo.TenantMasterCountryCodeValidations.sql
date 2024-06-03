SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          procedure [dbo].[TenantMasterCountryCodeValidations]  -- exec TenantMasterCountryCodeValidations 2                    
(                    
@BatchNo numeric ,              
@tenantid numeric,      
@validstat int      
)                    
as          
set nocount on     
begin                    
                    
                    
begin                    
delete from importmaster_ErrorLists  where batchid = @BatchNo and tenantid=@tenantid and errortype in( 304 ,612)                   
end      
      
     
begin                     
                    
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                     
select tenantid,@batchno,uniqueidentifier,'0','Invalid Country Code',304,0,getdate() from ImportMasterBatchData with(nolock)                    
where upper(trim(left(Nationality  , 2))) not in (select (Alphacode) from Country with(nolock))  and batchid = @BatchNo and tenantid=@tenantid                  
                
                    
                
end    

              
begin              
              
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select tenantid,@batchno,uniqueidentifier,'0','Nationality cannot be blank',612,0,getdate() from ImportMasterBatchData with(nolock)              
where (upper(trim(left(Nationality  , 2)))           
is null or len(Nationality) =0)  and batchid=@batchno and TenantId =@tenantid        
   --(select upper(OperationalModel) from tenantbasicdetails)             
              
end 
                    
end
GO
