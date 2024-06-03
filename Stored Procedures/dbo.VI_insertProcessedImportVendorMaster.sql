SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[VI_insertProcessedImportVendorMaster]        -- exec  [VI_insertProcessedImportVendorMaster] 955,148        
(                  
@batchno numeric,            
@tenantid int            
)    
as                  
begin  

delete from importmaster_ErrorLists where status = '1' and batchid = @batchno    and tenantid=@tenantid              
        
delete from importmaster_ErrorLists where batchid = @batchno and tenantid = @tenantid       
and uniqueIdentifier in (select uniqueIdentifier from Masteroverride where batchid = @batchno and tenantid=@tenantid)        
        
insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)                   
select i.tenantid,@batchno,i.uniqueidentifier,'1',' ',0,0,getdate() from ImportMasterBatchData  i                  
where i.MasterType like 'Vendor%' and i.batchid = @batchno and i.UniqueIdentifier not in                   
(select UniqueIdentifier from importmaster_ErrorLists e where e.batchid = @batchno)                   
        
delete from VI_ImportMasterFiles_Processed where  batchid = @batchno  and TenantId=@tenantid           
          
           
begin            
INSERT INTO [dbo].[VI_ImportMasterFiles_Processed]         --if tenant id exist update else insert            
           (      
[TenantId]                  
       ,[UniqueIdentifier]      
    ,[batchid]      
       ,[TenantType]                  
       ,[ConstitutionType]              
       ,[Name]      
    ,[LegalName]      
    ,[ContactPerson]                  
       ,[ContactNumber]      
    ,[EmailID]                  
       ,[Nationality]      
    ,[DocumentLineIdentifier]      
    ,[DocumentType]              
       ,[DocumentNumber]      
    ,[RegistrationDate]      
    ,[ParentEntityName]              
       ,[LegalRepresentative]      
    ,[Designation]      
    ,[ParentEntityCountryCode]      
    ,[BusinessCategory]      
    ,[OperationalModel]      
    ,[BusinessPurchase]      
    ,[PurchaseVATCategory]      
    ,[InvoiceType]      
    ,[OrgType]      
    ,[AffiliationStatus]      
    ,[MasterType]            
       ,[MasterId]            
       ,[CreationTime]                  
       ,[CreatorUserId]                  
       ,[IsDeleted]      
    ,[DeletionTime]      
                 
)            
                                 
 select               
i.[TenantId]                  
           ,i.[UniqueIdentifier]                  
           ,i.[BatchId]                 
           ,i.[TenantType]                  
       ,i.[ConstitutionType]      
    ,i.[Name]      
    ,i.[LegalName]      
       ,i.[ContactPerson]      
    ,i.[ContactNumber]      
    ,i.[EmailID]      
    ,i.[Nationality]      
    ,i.[DocumentLineIdentifier]      
    ,i.[DocumentType]      
       ,i.[DocumentNumber]      
    ,i.[RegistrationDate]      
    ,i.[ParentEntityName]      
    ,i.[LegalRepresentative]      
    ,i.[Designation]      
    ,i.[ParentEntityCountryCode]      
    ,i.[BusinessCategory]                
       ,i.[OperationalModel]      
    ,i.[BusinessPurchase]      
    ,i.[PurchaseVATCategory]      
    ,i.[InvoiceType]      
    ,[OrgType]      
    ,[AffiliationStatus]      
    ,i.MasterType            
       ,i.[MasterId]         
    ,i.[CreationTime]      
           ,i.[LastModifierUserId]                  
           ,i.[IsDeleted]                 
           ,i.[DeletionTime]        
        
     from ImportMasterBatchData  i inner join importmaster_ErrorLists e on i.UniqueIdentifier = e.uniqueIdentifier and i.Batchid=@batchno and i.TenantId=@tenantid and e.status = '1'                  
  end    


   ;WITH cte AS
(
SELECT ROW_NUMBER() OVER (PARTITION BY ContactNumber ORDER BY Id DESC)  AS row_num, ContactNumber,TenantId,MasterType FROM VI_ImportMasterFiles_Processed  WHERE MasterType LIKE 'Vendor%'
)
DELETE FROM cte WHERE row_num>1;
          
  begin                    
                    
declare @failedRecords numeric =0                    
                    
set @failedRecords = (select count(distinct uniqueIdentifier) from importmaster_ErrorLists where Batchid = @batchno and status = 0)                    
                    
update BatchMasterData set  SuccessRecords = totalRecords- @failedRecords ,FailedRecords=@failedRecords , status='Processed' where batchid=@batchno                       
                    
end                  
end
GO
