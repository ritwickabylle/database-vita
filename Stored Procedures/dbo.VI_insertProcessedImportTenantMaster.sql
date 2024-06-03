SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE   procedure [dbo].[VI_insertProcessedImportTenantMaster]            
(              
@batchno numeric ,        
@tenantid int       
)              
as              
begin              
--select * from Masteroverride   
delete from importmaster_ErrorLists where status = '1' and batchid = @batchno    and tenantid=@tenantid  
  
delete from importmaster_ErrorLists where batchid = @batchno and tenantid = @tenantid and uniqueIdentifier in (select uniqueIdentifier from Masteroverride where batchid = @batchno and tenantid=@tenantid)  
  
insert into importmaster_ErrorLists(tenantid,BatchId,uniqueidentifier,Status,ErrorMessage,Errortype,isdeleted,CreationTime)               
select i.tenantid,@batchno,i.uniqueidentifier,'1',' ',0,0,getdate() from ImportMasterBatchData  i              
where i.MasterType like 'Tenant%' and i.batchid = @batchno and i.UniqueIdentifier not in               
(select UniqueIdentifier from importmaster_ErrorLists e where e.batchid = @batchno and TenantId=@tenantid)               
delete from VI_ImportMasterFiles_Processed where  batchid = @batchno  and TenantId=@tenantid       
    
        
begin 
  

  if((select count(*) from [VI_ImportMasterFiles_Processed] where mastertype like 'tenant' and tenantid=@tenantid)=1)
  begin
  update [VI_ImportMasterFiles_Processed]
  set [TenantId]  =i.tenantid            
           ,[UniqueIdentifier]  =i.[UniqueIdentifier]            
           ,[BatchId]   =i.  [BatchId]     
           --,[Filename]              
           ,[TenantType] =i.tenanttype             
           ,[ConstitutionType]=i.constitutiontype              
           ,[BusinessCategory]  =i.[BusinessCategory]            
           ,[OperationalModel] =i.  [OperationalModel]           
           ,[TurnoverSlab]   =i. [TurnoverSlab]          
           ,[ContactPerson]   =i.   [ContactPerson]        
           ,[ContactNumber] =i. [ContactNumber]            
           ,[EmailID]  =i.  [EmailID]         
           ,[Nationality]   = left(i.[Nationality],2)           
           ,[Designation]  = i.[Designation]            
           ,[VATID]  =i.[VATID]            
           ,[Name]  =i.[Name]            
           ,[LegalName]   = i.[LegalName]           
           ,[ParentEntityName]  =i.[ParentEntityName]            
           ,[LegalRepresentative]  = i.[LegalRepresentative]            
           ,[ParententityCountryCode] = i.[ParententityCountryCode]             
           ,[LastReturnFiled] = i. [LastReturnFiled]             
           ,[VATReturnFillingFrequency]    =i.[VATReturnFillingFrequency]           
           ,[DocumentLineIdentifier]  = i. [DocumentLineIdentifier]            
           ,[DocumentType]    =i.[DocumentType]          
           ,[DocumentNumber]  = i.[DocumentNumber]            
           ,[RegistrationDate]   = i .[RegistrationDate]           
           ,[BusinessPurchase]   = i.[BusinessPurchase]           
           ,[BusinessSupplies]  = i. [BusinessSupplies]            
           ,[SalesVATCategory]  = i.[SalesVATCategory]            
           ,[PurchaseVATCategory]  =i.[PurchaseVATCategory]            
           ,[CreationTime]   = i.[CreationTime]           
           ,[CreatorUserId]  = i.[CreatorUserId]                       
           ,[InvoiceType]  = i.[InvoiceType]            
           ,[LastModifierUserId] =i.[LastModifierUserId]             
           ,[IsDeleted] = i.[IsDeleted]             
           ,[DeleterUserId]   = i.[DeleterUserId]           
           ,[DeletionTime]    = i.[DeletionTime]    
,[MasterType] = i.[MasterType]
from ImportMasterBatchData  i inner join importmaster_ErrorLists e on i.UniqueIdentifier = e.uniqueIdentifier and i.Batchid=@batchno and i.TenantId=@tenantid and e.status = '1'
  end 
  
  else if((select count(*) from [VI_ImportMasterFiles_Processed] where mastertype like 'tenant' and tenantid=@tenantid)=0)
begin
INSERT INTO [dbo].[VI_ImportMasterFiles_Processed]         --if tenant id exist update else insert        
           ([TenantId]              
           ,[UniqueIdentifier]              
           ,[BatchId]          
           --,[Filename]              
           ,[TenantType]              
           ,[ConstitutionType]              
           ,[BusinessCategory]              
           ,[OperationalModel]              
           ,[TurnoverSlab]              
           ,[ContactPerson]              
           ,[ContactNumber]              
           ,[EmailID]              
           ,[Nationality]              
           ,[Designation]              
           ,[VATID]              
           ,[Name]              
           ,[LegalName]              
           ,[ParentEntityName]              
           ,[LegalRepresentative]              
           ,[ParententityCountryCode]              
           ,[LastReturnFiled]              
           ,[VATReturnFillingFrequency]              
           ,[DocumentLineIdentifier]              
           ,[DocumentType]              
           ,[DocumentNumber]              
           ,[RegistrationDate]              
           ,[BusinessPurchase]              
           ,[BusinessSupplies]              
           ,[SalesVATCategory]              
           ,[PurchaseVATCategory]              
           ,[CreationTime]              
           ,[CreatorUserId]              
           ,[LastModificationTime]              
           ,[InvoiceType]              
           ,[LastModifierUserId]              
           ,[IsDeleted]              
           ,[DeleterUserId]              
           ,[DeletionTime]        
,[MasterType])        
                             
 select           
i.[TenantId]              
           ,i.[UniqueIdentifier]              
           ,i.[BatchId]          
           --,i.[Filename]              
           ,i.[TenantType]              
           ,i.[ConstitutionType]              
           ,i.[BusinessCategory]              
           ,i.[OperationalModel]              
           ,i.[TurnoverSlab]              
           ,i.[ContactPerson]              
           ,i.[ContactNumber]              
           ,i.[EmailID]              
           ,left(i.[Nationality],2)              
           ,i.[Designation]              
           ,i.[VATID]              
           ,i.[Name]              
           ,i.[LegalName]              
           ,i.[ParentEntityName]              
           ,i.[LegalRepresentative]              
           ,i.[ParententityCountryCode]              
           ,i.[LastReturnFiled]              
           ,i.[VATReturnFillingFrequency]              
           ,i.[DocumentLineIdentifier]              
           ,i.[DocumentType]              
           ,i.[DocumentNumber]              
           ,i.[RegistrationDate]              
           ,i.[BusinessPurchase]              
           ,i.[BusinessSupplies]              
           ,i.[SalesVATCategory]              
           ,i.[PurchaseVATCategory]              
           ,i.[CreationTime]              
           ,i.[CreatorUserId]              
           ,i.[LastModificationTime]              
           ,i.[InvoiceType]              
           ,i.[LastModifierUserId]              
           ,i.[IsDeleted]              
           ,i.[DeleterUserId]              
           ,i.[DeletionTime]          
,i.[MasterType]        
          
     from ImportMasterBatchData  i inner join importmaster_ErrorLists e on i.UniqueIdentifier = e.uniqueIdentifier and i.Batchid=@batchno and i.TenantId=@tenantid and e.status = '1'              
  end  

  else if((select count(*) from [VI_ImportMasterFiles_Processed] where mastertype like 'tenant' and tenantid=@tenantid)>1)

  begin
  delete from [VI_ImportMasterFiles_Processed] where tenantid=@tenantid and batchid<@batchno
  end 
  end
      
  begin                
  
declare @failedRecords numeric =0                
                
set @failedRecords = (select count(distinct uniqueIdentifier) from importmaster_ErrorLists where Batchid = @batchno and status = 0 and TenantId=@tenantid)                
                
update BatchMasterData set  SuccessRecords = totalRecords- @failedRecords ,FailedRecords=@failedRecords , status='Processed' where batchid=@batchno  and TenantId=@tenantid                 
                
end              
end



--  select * from importmaster_ErrorLists
GO
