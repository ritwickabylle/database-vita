SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE      procedure [dbo].[UpdateTenantMasterData]    ---exec UpdateTenantMasterData 864,148 
(      
 @batchno numeric,      
 @tenantid numeric      
)      
as      
begin        
--declare @tenantid int      
if (@tenantid in (select distinct tenantid from TenantBasicDetails))     --only update       
begin            
            
update TenantBasicDetails      
set            
   [TenantId] = i.TenantId             
           ,[UniqueIdentifier]   = newid()                   
           ,[TenantType]   =i.TenantType               
           ,[ConstitutionType]   = i.ConstitutionType               
           ,[BusinessCategory]   =i.BusinessCategory                
           ,[OperationalModel]    = i.OperationalModel              
           ,[TurnoverSlab]     = i.TurnoverSlab             
           ,[ContactPerson]   =i.ContactPerson               
           ,[ContactNumber] = i.ContactNumber             
           ,[EmailID] = i.EmailID            
           ,[Nationality] = i.Nationality            
           ,[Designation] = i.Designation            
           ,[VATID] = i.VATID            
           --,[Name] = i.Name             
           --,[LegalName] = i.LegalName            
           ,[ParentEntityName] = i.ParentEntityName            
           ,[LegalRepresentative] = i.LegalRepresentative            
           ,[ParententityCountryCode] = i.ParententityCountryCode            
           ,[LastReturnFiled] = i.LastReturnFiled            
           ,[VATReturnFillingFrequency] = i.VATReturnFillingFrequency            
           --,[DocumentLineIdentifier] = i.DocumentLineIdentifier            
           --,[DocumentType] = i.DocumentType            
           --,[DocumentNumber] = i.DocumentNumber            
           --,[RegistrationDate] = i.RegistrationDate            
           --,[BusinessPurchase] = i.BusinessPurchase            
           --,[BusinessSupplies] = i.BusinessSupplies            
           --,[SalesVATCategory] = i.SalesVATCategory            
           --,[PurchaseVATCategory] = i.PurchaseVATCategory            
           ,[CreationTime] = i.CreationTime            
           ,[CreatorUserId] = i.CreatorUserId            
           ,[LastModificationTime] = i.LastModificationTime            
           --,[InvoiceType] = i.InvoiceType            
           ,[LastModifierUserId] = i.LastModifierUserId            
           ,[IsDeleted] = i.IsDeleted            
           ,[DeleterUserId] = i.DeleterUserId            
           ,[DeletionTime] = i.DeletionTime            
           --,[MasterType] = i.MasterType            
            
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantBasicDetails.TenantId=@tenantid      
end      
end      
    
--select * from TenantBasicDetails where TenantId=2    
--select * from VI_ImportMasterFiles_Processed where TenantId=2 and batchid=229    
--select * from ImportMasterBatchData where TenantId=2 and batchid=229    
    
--update ImportMasterBatchData set BusinessCategory='Goods' where batchid=229 and TenantId=2    
--------      
--------    
      
begin      
if (@tenantid in (select distinct tenantid from TenantDocuments))     --only update       
begin       
      
update [dbo].[TenantDocuments]        
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()             
,[DocumentType]  = i.DocumentType      
,[DocumentNumber]  = i.DocumentNumber      
,[RegistrationDate]  = i.RegistrationDate      
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted      
              
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantDocuments.TenantId=@tenantid      
      
end      
      
else      
begin       
 insert into TenantDocuments (TenantId,UniqueIdentifier,DocumentType,DocumentNumber,RegistrationDate,CreationTime,CreatorUserId,IsDeleted)      
 select TenantId,NEWID(),DocumentType,DocumentNumber,RegistrationDate,CreationTime,CreatorUserId,IsDeleted      
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end      
---------      
begin      
if (@tenantid in (select distinct tenantid from TenantAddress))     --only update       
begin       
      
update TenantAddress      
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()             
,CountryCode  = i.Nationality      
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted
,[Country] = c.[Name]
              
from VI_ImportMasterFiles_Processed i 
join [Country] c on c.alphacode =i.Nationality and i.TenantId=@tenantid and i.batchid=@batchno join TenantAddress t on t.tenantid=  @tenantid
      
end      
      
else      
begin       
 insert into TenantAddress (TenantId,UniqueIdentifier,Country,CreationTime,CreatorUserId,IsDeleted)      
 select TenantId,NEWID(),Nationality,CreationTime,CreatorUserId,IsDeleted      
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end      
---------      
      
begin      
if (@tenantid in (select distinct tenantid from TenantBusinessPurchase))     --only update       
begin       
      
update [dbo].[TenantBusinessPurchase]        
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()             
,[BusinessPurchase]  = i.BusinessPurchase      
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted      
              
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantBusinessPurchase.TenantId=@tenantid      
      
end      
      
else      
begin       
 insert into TenantBusinessPurchase (TenantId,UniqueIdentifier,BusinessPurchase,CreationTime,CreatorUserId,IsDeleted,IsActive)      
 select TenantId,NEWID(),BusinessPurchase,CreationTime,CreatorUserId,IsDeleted,1      
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end      
--------      
begin      
if (@tenantid in (select distinct tenantid from TenantBusinessSupplies))     --only update       
begin       
      
update [dbo].[TenantBusinessSupplies]      
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()             
,[businesssupplies]  = i.businesssupplies      
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted      
              
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantBusinessSupplies.TenantId=@tenantid      
      
end      
      
else      
begin       
 insert into TenantBusinessSupplies (TenantId,UniqueIdentifier,BusinessSupplies,CreationTime,CreatorUserId,IsDeleted,IsActive)      
 select TenantId,NEWID(),BusinessSupplies,CreationTime,CreatorUserId,IsDeleted ,1     
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end     
  
  
--select * from TenantBusinessSupplies  
--select * from TenantBusinessPurchase  
--select * from VI_ImportMasterFiles_Processed   
  
--delete from TenantBusinessSupplies where id in (6,7,8)  
-----------      
--------      
-----------      
--------      
begin      
if (@tenantid in (select distinct tenantid from TenantPurchaseVatCateory))     --only update       
begin       
      
update [dbo].[TenantPurchaseVatCateory]      
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()             
,[VATCategoryID]  = i.VATID      
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted      
              
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantPurchaseVatCateory.TenantId=@tenantid      
      
end      
      
else      
begin       
 insert into TenantPurchaseVatCateory (TenantId,UniqueIdentifier,VATCategoryID,CreationTime,CreatorUserId,IsDeleted,IsActive)      
 select TenantId,NEWID(),VATID,CreationTime,CreatorUserId,IsDeleted,1      
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end      
-----------      
--------      
begin      
if (@tenantid in (select distinct tenantid from TenantSectors))     --only update       
begin       
      
update [dbo].[TenantSectors]      
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()          
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted      
              
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantSectors.TenantId=@tenantid      
      
end      
      
else      
begin       
 insert into TenantSectors (TenantId,UniqueIdentifier,CreationTime,CreatorUserId,IsDeleted)      
 select TenantId,NEWID(),CreationTime,CreatorUserId,IsDeleted      
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end      
-----------      
--------      
begin      
if (@tenantid in (select distinct tenantid from TenantShareHolders))     --only update       
begin       
      
update [dbo].[TenantShareHolders]      
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()             
,[Nationality]  = i.Nationality      
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted      
              
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantShareHolders.TenantId=@tenantid      
      
end      
      
else      
begin       
 insert into TenantShareHolders (TenantId,UniqueIdentifier,Nationality,CreationTime,CreatorUserId,IsDeleted)      
 select TenantId,NEWID(),Nationality,CreationTime,CreatorUserId,IsDeleted      
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end      
-----------      
--------      
begin      
if (@tenantid in (select distinct tenantid from TenantSupplyVATCategory))     --only update       
begin       
      
update [dbo].[TenantSupplyVATCategory]      
set      
[TenantId]   =  i.TenantId       
,[UniqueIdentifier]   = NEWID()             
,[vatcode]  = i.vatid      
,[CreationTime] = i.CreationTime      
,[CreatorUserId] = i.CreatorUserId      
,[IsDeleted] = i.IsDeleted      
              
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and TenantSupplyVATCategory.TenantId=@tenantid      
      
end      
      
else      
begin       
 insert into TenantSupplyVATCategory (TenantId,UniqueIdentifier,vatcode,CreationTime,CreatorUserId,IsDeleted,IsActive)      
 select TenantId,NEWID(),vatid,CreationTime,CreatorUserId,IsDeleted,1      
 from VI_ImportMasterFiles_Processed i      
 where i.TenantId=@tenantid and i.batchid=@batchno      
end      
end      
-----------      
GO
