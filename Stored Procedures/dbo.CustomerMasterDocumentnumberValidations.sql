SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                      
CREATE   procedure [dbo].[CustomerMasterDocumentnumberValidations]  -- exec CustomerMasterDocumentnumberValidations 246,40,1                     
(                        
@BatchNo numeric ,           
@validstat int,    
@tenantid numeric          
                    
)                        
as                  
--set nocount on                 
begin                        
delete from importmaster_ErrorLists where batchid = @BatchNo and TenantId=@tenantid and errortype in (296,466)        
end                               
                      
begin                        
  
;WITH CTE AS      
(       
select ROW_NUMBER() over (partition by DocumentNumber order by DocumentNumber) as slno,ROW_NUMBER() over (partition by name order by name) as slno1,name,DocumentNumber, TenantId,UniqueIdentifier,batchid,DocumentType 
from ImportMasterBatchData where batchid=@BatchNo and TenantId=@tenantid and mastertype like 'Customer%' and   
   
 (VATID is not null or len(vatid)>0) )       
 insert into importmaster_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)       
 SELECT tenantid,@batchno,uniqueidentifier,'0','VAT number already exists for different Buyer'            
,466,0,getdate() FROM CTE WHERE slno >1 and slno1=1 and batchid = @batchno  and TenantId=@TenantId  and DocumentType = 'VAT'  
  
  
--************************************************************************  
--(select top 1 name from ImportmasterBatchData where batchid=@BatchNo and len(DocumentNumber)>0 and DocumentNumber  in (select documentnumber from ImportmasterBatchData with(nolock) where batchid = @BatchNo   group by DocumentNumber having count(*) > 1))
  
--The above statement is not working because of Arabic name,value is coming null  
--************************************************************************   
   
-- insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                         
--  select tenantid,@batchno,uniqueidentifier,'0','Document Number cannot be blank',296,0,getdate()                        
--from ImportMasterBatchData with(nolock) where len(Documentnumber) = 0 and len(DocumentType) > 0                      
--  and batchid = @batchno                         
        
        
--insert into importmaster_errorlists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                         
--select tenantid,@batchno,uniqueidentifier,'0','VAT number already exists for Buyer ' + (select top 1 name from ImportmasterBatchData where batchid=@BatchNo and len(DocumentNumber)>0 and DocumentNumber  in                     
--  (select documentnumber from ImportmasterBatchData with(nolock) where batchid = @BatchNo   group by DocumentNumber having count(*) > 1))            
--,466,0,getdate()                        
--from ImportmasterBatchData with(nolock) where len(Documentnumber) > 0 and DocumentType = 'VAT' and left(Nationality,2) = 'SA'                      
--and DocumentNumber in                         
--  (select DocumentNumber from importmasterbatchdata with(nolock) where documenttype = 'VAT' and DocumentNumber  in         
        
--   (select DocumentNumber from ImportBatchData with(nolock) group by DocumentNumber,BuyerName having count(*) > 1)            
--    and len(DocumentNumber)>0)            
        
  --(select documentnumber from ImportmasterBatchData with(nolock) where batchid = @BatchNo  group by DocumentNumber ,Name)                     
  --and batchid = @BatchNo  group by documentnumber having count(*) > 1)                     
  --and batchid = @batchno          
                        
end
GO
