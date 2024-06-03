SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create               procedure [dbo].[CustomerMasterCountryCodeValidations]  -- exec CustomerMasterCountryCodeValidations 101                          
(                          
@BatchNo numeric,                      
@tenantid numeric,            
@validstat int            
)                          
as            
set nocount on         
begin                          
                          
                          
begin                          
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in (337)                          
end            
            
if @validstat=1            
begin                          
delete from importmaster_ErrorLists  where batchid = @BatchNo and errortype in (293)                          
end            
            
if @validstat=1            
begin                           
                          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','Enter Valid Country Code',293,0,getdate() from ImportMasterBatchData with(nolock)                          
where concat(@tenantid,cast(left(Nationality,2)  as nvarchar)) not in (select concat(@tenantid,Alphacode) from Country) and batchid = @batchno and TenantId =@tenantid                          
                      
end                      
                
begin                           
                          
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                           
select tenantid,@batchno,uniqueidentifier,'0','For Domestic Supply Country Code should be SA',337,0,getdate() from ImportMasterBatchData with(nolock)                           
where upper(trim(Nationality)) not like '%SA%' and upper(trim(BusinessSupplies)) like '%DOMESTIC%' and batchid = @batchno  and TenantId =@tenantid                           
                    
end                    
                          
end
GO
