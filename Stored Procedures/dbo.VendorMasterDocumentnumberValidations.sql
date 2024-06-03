SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
              
CREATE            procedure [dbo].[VendorMasterDocumentnumberValidations]  -- exec CustomerMasterDocumentnumberValidations 172              
(                
@BatchNo numeric ,        
@validstat int        
)                
as                 
begin                
delete from importmaster_ErrorLists where batchid = @BatchNo and errortype in (375,376)                
end                
              
begin                
                
--insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                 
--select tenantid,@batchno,uniqueidentifier,'0','VAT ID cannot be blank',375,0,getdate()                
--from ImportMasterBatchData where len(Documentnumber) = 0 and len(DocumentType) > 0              
--and batchid = @batchno                 
          
insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,creationtime)                 
select tenantid,@batchno,uniqueidentifier,'0','VAT ID is mandatory for Domestic Vendors',376,0,getdate()                
from ImportMasterBatchData where           
(len(Documentnumber) = 0 or DocumentNumber is null) and UPPER(Nationality) like 'SA%'  and  BusinessPurchase like 'Domestic%'  and DocumentType='VAT'     
--len(DocumentType) > 0              
and batchid = @batchno            
          
end     
    
    
--select * from ImportMasterBatchData where batchid=29
GO
