SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[UpdateCustomerMasterData]   -- exec updatecustomermasterdata 48,2            
(                
 @batchno numeric,                
 @tenantid numeric                
)                
as                
begin                
--select * from customers          
--select * from CustomerAddress              
--select * from CustomerContactPerson              
--select * from CustomerDocuments              
--select * from CustomerForeignEntity               
--select * from CustomerRegDetail              
--select * from CustomerTaxDetails              
update Customers             
set                      
            [TenantType]   =i.TenantType                         
           ,[ConstitutionType]   = i.ConstitutionType                         
           ,[Name] = i.Name                       
           ,[LegalName] = i.LegalName                           
           ,[ContactPerson]   =i.ContactPerson                         
           ,[ContactNumber] = i.ContactNumber                       
           ,[EmailID] = i.EmailID                      
           ,[Nationality] = SUBSTRING(i.Nationality, CHARINDEX('-', i.Nationality) + 1, LEN(i.Nationality))                     
           ,[Designation] = i.Designation                      
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where customers.TenantId=@tenantid and i.batchid=@batchno              
and i.MasterType like 'Customer%' and cast(customers.id as int) = cast(i.masterid   as int)           
                
delete from customers where tenantid = @tenantid and id in (select masterid from VI_importMasterfiles_Processed where batchid = @batchno)                
--select id,Name,LegalName,ConstitutionType from customers              
--select Name,LegalName,ConstitutionType,MasterId,batchid from ImportMasterBatchData              
               
begin              
insert into customers(UniqueIdentifier,TenantId,TenantType,ConstitutionType,name,LegalName,ContactPerson,ContactNumber,EmailID,Nationality,                
Designation,CreationTime,CreatorUserId,LastModificationTime,LastModifierUserId,IsDeleted,DeleterUserId,DeletionTime)                
                
select  distinct              
--i.masterid,                       
          newid()                             
          ,@tenantid
			,i.TenantType
           ,i.ConstitutionType                         
           ,(i.name)                          
           ,(i.LegalName)                       
           ,i.ContactPerson                         
           ,i.ContactNumber                       
           ,i.EmailID                      
           --,i.Nationality  
			,SUBSTRING(i.Nationality, CHARINDEX('-', i.Nationality) + 1, LEN(i.Nationality))
           ,i.Designation                      
           ,i.CreationTime                      
           ,i.CreatorUserId                      
           ,i.LastModificationTime                      
           ,i.LastModifierUserId                      
           ,i.IsDeleted                      
           ,i.DeleterUserId                      
           ,i.DeletionTime                      
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno  and                
cast(isnull(i.masterid,0) as bigint) not in (select id from customers where tenantid = @tenantid) --and concat()              
--group by i.ConstitutionType,i.Name,i.LegalName,i.ContactNumber,i.ContactPerson,i.EmailID,i.Nationality,i.Designation,i.CreationTime,i.CreatorUserId,i.LastModificationTime,i.LastModifierUserId,i.IsDeleted,i.DeleterUserId,i.DeletionTime              
              
update VI_ImportMasterFiles_Processed set MasterId=(select top 1 c.id  from Customers c               
where c.Name=VI_ImportMasterFiles_Processed.Name and c.LegalName=VI_ImportMasterFiles_Processed.LegalName              
and c.ConstitutionType=VI_ImportMasterFiles_Processed.ConstitutionType and c.TenantId=VI_ImportMasterFiles_Processed.TenantId and c.TenantId=@tenantid order by c.id desc) where VI_ImportMasterFiles_Processed.batchid=@batchno              
            
------------------------------------------------------------------------            
            
--Select * from VI_ImportMasterFiles_Processed  where VI_ImportMasterFiles_Processed.batchid=266              
--Select * from ImportMasterBatchData  where batchid=266             
--select * from Customers            
            
------------------------------------------------------------------------            
              
              
update ImportMasterBatchData set MasterId=(select top 1 c.id  from Customers c              
where c.Name=ImportMasterBatchData.Name and c.LegalName=ImportMasterBatchData.LegalName               
and c.ConstitutionType=ImportMasterBatchData.ConstitutionType and c.TenantId=ImportMasterBatchData.TenantId and c.TenantId=@tenantid order by c.id desc) where ImportMasterBatchData.batchid=@batchno              
end              
              
--select c.id,i.masterid from  customers c inner join ImportMasterBatchData i on c.legalname=i.LegalName and c.Name=i.Name and c.ConstitutionType=i.ConstitutionType and c.TenantId=i.TenantId --and i.batchid=131              
--select * from ImportMasterBatchData where batchid=131              
--select * from CustomerTaxDetails              
end                
--------                
                
begin               
              
--select * from [dbo].[CustomerAddress]              
--select * from VI_ImportMasterFiles_Processed              
              
update CustomerAddress                
set                      
            [CountryCode]   = i.Nationality                    
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where CustomerAddress.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Customer%' and CustomerAddress.CustomerID = i.masterid and CustomerAddress.TenantId=@tenantid              
                
end                
               
--else                
begin                 
 insert into CustomerAddress (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,CountryCode,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,newid(),Nationality,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(CustomerID ,'') from CustomerAddress)              
end                
--end                
--select masterid,* from VI_ImportMasterFiles_Processed where batchid=137              
-----------                
              
begin               
              
--select * from CustomerAddress              
--select * from [dbo].[CustomerContactPerson]              
--select * from VI_ImportMasterFiles_Processed              
              
update CustomerContactPerson                
set                      
            [Name]   = i.ContactPerson              
     ,[ContactNumber]=i.ContactNumber              
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where CustomerContactPerson.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Customer%' and CustomerContactPerson.CustomerID = i.masterid and CustomerContactPerson.TenantId=@tenantid              
                
end                
                
--else                
begin                 
 insert into CustomerContactPerson (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,[Name],ContactNumber,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,NEWID(),Name,ContactNumber,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(CustomerID,'') from CustomerContactPerson)              
end                
--end                
              
-----------                
                
begin       
              
--select * from [dbo].[CustomerDocuments]              
--select * from VI_ImportMasterFiles_Processed              
              
update CustomerDocuments              
set                      
            [DocumentTypeCode]   = i.DocumentType            
           ,[DocumentName] = i.documenttype            
     ,[DocumentNumber]=i.DocumentNumber 
 ,[DoumentDate]=CASE WHEN i.RegistrationDate IS NULL OR i.RegistrationDate = '' THEN getdate() ELSE i.RegistrationDate END
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where CustomerDocuments.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Customer%' and CustomerDocuments.CustomerID = i.masterid               
and CustomerDocuments.TenantId=@tenantid and CustomerDocuments.DocumentTypeCode=i.DocumentType              
                
end       
                
--else                
begin               
 insert into CustomerDocuments (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,DocumentTypeCode,DocumentName,DocumentNumber,doumentdate,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,newid(),DocumentType,DocumentType,DocumentNumber,CASE WHEN RegistrationDate IS NULL OR RegistrationDate = '' THEN getdate() ELSE RegistrationDate END,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(customerid,'') from CustomerDocuments)              
end                
--end                
--select * from CustomerDocuments order by id desc             
----------                
begin               
              
--select * from [dbo].[CustomerForeignEntity]              
--select * from VI_ImportMasterFiles_Processed order by id desc             
              
update CustomerForeignEntity                
set                      
            [Country]   = i.ParententityCountryCode              
     ,[LegalRepresentative]=i.LegalRepresentative              
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where CustomerForeignEntity.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Customer%' and CustomerForeignEntity.CustomerID = i.masterid               
and CustomerForeignEntity.TenantId=@tenantid and i.ConstitutionType like 'Foreign%'              
                
end                
              
                
--else                
begin                 
 insert into CustomerForeignEntity (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,Country,LegalRepresentative,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,newid(),Nationality,LegalRepresentative,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(CustomerID,'') from CustomerForeignEntity)              
end                
--end                
-------------                
----------                
--begin               
              
----select * from [dbo].[CustomerOwnershipDetails]              
----select * from VI_ImportMasterFiles_Processed              
              
--update CustomerOwnershipDetails              
--set                      
--            [LastModificationTime] = getdate()                      
--           ,[LastModifierUserId] = i.LastModifierUserId                      
--from VI_ImportMasterFiles_Processed i               
--where CustomerOwnershipDetails.TenantId=@tenantid and i.batchid=@batchno               
--and i.MasterType like 'Customer%' and CustomerOwnershipDetails.CustomerID = i.masterid               
--and CustomerOwnershipDetails.TenantId=@tenantid              
                
--end                
                
--else                
--begin                 
-- insert into TenantBusinessSupplies (TenantId,UniqueIdentifier,BusinessSupplies,CreationTime,CreatorUserId,IsDeleted)                
-- select TenantId,NEWID(),BusinessSupplies,CreationTime,CreatorUserId,IsDeleted                
-- from VI_ImportMasterFiles_Processed i                
-- where i.TenantId=@tenantid and i.batchid=@batchno                
--end                
--end                
-------------                
----------                
begin               
              
--select * from [dbo].[CustomerRegDetail]              
--select * from VI_ImportMasterFiles_Processed              
              
update CustomerRegDetail              
set                   
   [regno] = i.DocumentNumber              
from VI_ImportMasterFiles_Processed i               
where CustomerRegDetail.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Customer%' and CustomerRegDetail.ID = i.masterid              
and i.DocumentType=CustomerRegDetail.DocumentType              
                
end                
                
--else                
--begin                 
-- insert into CustomerRegDetail (TenantId,UUID,documentid,RegNo)                
-- select TenantId,NEWID(),MasterId,regno,CreatorUserId,IsDeleted                
-- from VI_ImportMasterFiles_Processed i                
-- where i.TenantId=@tenantid and i.batchid=@batchno                
--end                
--end                
              
-------------                
-------------              
              
--begin               
              
----select * from [dbo].[CustomerSectorDetail]              
----select * from VI_ImportMasterFiles_Processed              
              
--update CustomerSectorDetail              
--set                   
--   [LastModificationTime] = getdate()                      
--           ,[LastModifierUserId] = i.LastModifierUserId              
--from VI_ImportMasterFiles_Processed i               
--where CustomerSectorDetail.TenantId=@tenantid and i.batchid=@batchno               
--and i.MasterType like 'Customer%' and CustomerSectorDetail.id = i.masterid              
                
--end                
                
--else                
--begin                 
-- insert into TenantSectors (TenantId,UniqueIdentifier,CreationTime,CreatorUserId,IsDeleted)                
-- select TenantId,NEWID(),CreationTime,CreatorUserId,IsDeleted                
-- from VI_ImportMasterFiles_Processed i                
-- where i.TenantId=@tenantid and i.batchid=@batchno                
--end                
--end                
-------------              
              
-------------              
              
--begin               
              
----select * from [dbo].[CustomerTaxDetails]              
----select * from VI_ImportMasterFiles_Processed              
              
--update CustomerTaxDetails              
--set                   
--   [BusinessCategory]=i.BusinessCategory              
--   ,[OperatingModel]=i.OperationalModel              
--   ,[BusinessSupplies]=i.BusinessSupplies              
--   ,[InvoiceType]=i.InvoiceType              
--   ,[LastModificationTime] = getdate()                      
--           ,[LastModifierUserId] = i.LastModifierUserId              
--from VI_ImportMasterFiles_Processed i               
--where CustomerTaxDetails.TenantId=@tenantid and i.batchid=@batchno               
--and i.MasterType like 'Customer%' and CustomerTaxDetails.CustomerID = i.masterid              
                
--end                
                
--else                
begin                 
 insert into CustomerTaxDetails (
 TenantId,
 UniqueIdentifier,
 CustomerID,
 CustomerUniqueIdentifier,
 SalesVATCategory,
 BusinessCategory,
 BusinessSupplies,
 OperatingModel,
 InvoiceType,
 CreationTime,
 CreatorUserId,
 IsDeleted)  --SalesVATCategory              
 select TenantId,NEWID(),masterid,newid(), SalesVATCategory,
 BusinessCategory,
 BusinessSupplies,
 OperationalModel,
 InvoiceType,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno               
 and SalesVATCategory not in (select isnull(salesvatcategory,'') from CustomerTaxDetails where CustomerID=i.masterid and TenantId=@tenantid)              
end                
              
              
              
--begin                 
-- insert into CustomerTaxDetails (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,BusinessCategory,CreationTime,CreatorUserId,IsDeleted)  --BusinessCategory              
-- select TenantId,NEWID(),masterid,newid(),BusinessCategory,CreationTime,CreatorUserId,IsDeleted                
-- from VI_ImportMasterFiles_Processed i                
-- where i.TenantId=@tenantid and i.batchid=@batchno               
-- and BusinessCategory not in (select isnull(BusinessCategory,'') from CustomerTaxDetails where CustomerID=i.masterid and TenantId=@tenantid)              
--end                
              
----select * from VI_ImportMasterFiles_Processed i where i.TenantId=2 and i.batchid=137               
---- and i.BusinessCategory not in (select isnull(BusinessCategory,'') from CustomerTaxDetails where CustomerID=91 and TenantId=2)              
----select * from ImportMasterBatchData              
              
--begin                 
-- insert into CustomerTaxDetails (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,OperatingModel,CreationTime,CreatorUserId,IsDeleted)  --BusinessCategory              
-- select TenantId,NEWID(),masterid,newid(),OperationalModel,CreationTime,CreatorUserId,IsDeleted                
-- from VI_ImportMasterFiles_Processed i                
-- where i.TenantId=@tenantid and i.batchid=@batchno               
-- and OperationalModel not in (select isnull(OperatingModel,'') from CustomerTaxDetails where CustomerID=i.masterid and TenantId=@tenantid)              
--end                
              
--begin                 
-- insert into CustomerTaxDetails (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,BusinessSupplies,CreationTime,CreatorUserId,IsDeleted)  --BusinessCategory              
-- select TenantId,NEWID(),masterid,newid(),BusinessSupplies,CreationTime,CreatorUserId,IsDeleted                
-- from VI_ImportMasterFiles_Processed i                
-- where i.TenantId=@tenantid and i.batchid=@batchno               
-- and BusinessSupplies not in (select isnull(BusinessSupplies,'') from CustomerTaxDetails where CustomerID=i.masterid and TenantId=@tenantid)              
--end              
              
--begin                 
-- insert into CustomerTaxDetails (TenantId,UniqueIdentifier,CustomerID,CustomerUniqueIdentifier,InvoiceType,CreationTime,CreatorUserId,IsDeleted)  --BusinessCategory              
-- select TenantId,NEWID(),masterid,NEWID(),InvoiceType,CreationTime,CreatorUserId,IsDeleted                
-- from VI_ImportMasterFiles_Processed i                
-- where i.TenantId=@tenantid and i.batchid=@batchno               
-- and InvoiceType not in (select isnull(InvoiceType,'') from CustomerTaxDetails where CustomerID=i.masterid and TenantId=@tenantid)              
--end              
--end                
              
-------------                
------------- 
GO
