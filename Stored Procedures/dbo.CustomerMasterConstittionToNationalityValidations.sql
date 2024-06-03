SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
CREATE                procedure [dbo].[CustomerMasterConstittionToNationalityValidations]  -- exec CustomerMasterConstittionToNationalityValidations 131                
(                
            
@BatchNo numeric            
)                
as                
begin                
delete from importmaster_ErrorLists  where batchid = @BatchNo  and errortype in (88)          
end                
                
begin                
                
insert into importmaster_ErrorLists (tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                 
select tenantid,@batchno,uniqueidentifier,'0','For Foreign Branch Nationality cannot be SA',88,0,getdate() from ImportMasterBatchData                 
where  upper(trim(ConstitutionType)) like '%FOREIGN BRANCH%' and upper(Nationality) like 'SA%'              
  and batchid = @BatchNo             
             
           
end
GO
