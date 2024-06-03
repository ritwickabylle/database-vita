SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    procedure [dbo].[UpdateVendorMasterData]   -- exec UpdateVendorMasterData 562,22          
(                
 @batchno numeric,                
 @tenantid numeric                
)                
as                
begin     
           
update Vendors            
set                      
            [TenantType]  = i.TenantType                         
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
where vendors.TenantId=@tenantid and i.batchid=@batchno              
and i.MasterType like 'Vendor%' and cast(vendors.id as int) = cast(i.masterid   as int)           
                
delete from vendors where tenantid = @tenantid and id in (select masterid from VI_importMasterfiles_Processed where batchid = @batchno)                
--select id,Name,LegalName,ConstitutionType from customers              
--select Name,LegalName,ConstitutionType,MasterId,batchid from ImportMasterBatchData              
               
begin              
insert into Vendors(UniqueIdentifier,TenantId,ConstitutionType,name,LegalName,ContactPerson,ContactNumber,EmailID,Nationality,                
Designation,CreationTime,CreatorUserId,LastModificationTime,LastModifierUserId,IsDeleted,DeleterUserId,DeletionTime,tenantType)                
                
select  distinct              
--i.masterid,                       
          newid()                             
          ,@tenantid                
           ,i.ConstitutionType                         
           ,(i.name)                          
           ,(i.LegalName)                       
           ,i.ContactPerson                         
           ,i.ContactNumber                       
           ,i.EmailID                      
          -- ,i.Nationality  
			,SUBSTRING(i.Nationality, CHARINDEX('-', i.Nationality) + 1, LEN(i.Nationality))
           ,i.Designation                      
           ,i.CreationTime                      
           ,i.CreatorUserId                      
           ,i.LastModificationTime                      
           ,i.LastModifierUserId                      
           ,i.IsDeleted                      
           ,i.DeleterUserId                     
           ,i.DeletionTime
		   ,i.tenanttype
from VI_ImportMasterFiles_Processed i where i.TenantId=@tenantid and i.batchid=@batchno and MasterType like 'Vendor%'  and                
cast(isnull(i.masterid,0) as bigint) not in (select id from Vendors where tenantid = @tenantid) --and concat()              
--group by i.ConstitutionType,i.Name,i.LegalName,i.ContactNumber,i.ContactPerson,i.EmailID,i.Nationality,i.Designation,i.CreationTime,i.CreatorUserId,i.LastModificationTime,i.LastModifierUserId,i.IsDeleted,i.DeleterUserId,i.DeletionTime              
              
update VI_ImportMasterFiles_Processed set MasterId=(select top 1 c.id  from Vendors c               
where c.Name=VI_ImportMasterFiles_Processed.Name and c.LegalName=VI_ImportMasterFiles_Processed.LegalName              
and c.ConstitutionType=VI_ImportMasterFiles_Processed.ConstitutionType and c.TenantId=VI_ImportMasterFiles_Processed.TenantId and c.TenantId=@tenantid order by c.id desc) where VI_ImportMasterFiles_Processed.batchid=@batchno and VI_ImportMasterFiles_Processed.MasterType like 'Vendor'             
            
------------------------------------------------------------------------            
            
--Select * from VI_ImportMasterFiles_Processed  where VI_ImportMasterFiles_Processed.batchid=266              
--Select * from ImportMasterBatchData  where batchid=266             
--select * from Customers            
            
------------------------------------------------------------------------            
              
              
update ImportMasterBatchData set MasterId=(select top 1 c.id  from Vendors c              
where c.Name=ImportMasterBatchData.Name and c.LegalName=ImportMasterBatchData.LegalName               
and c.ConstitutionType=ImportMasterBatchData.ConstitutionType and c.TenantId=ImportMasterBatchData.TenantId and c.TenantId=@tenantid order by c.id desc) 
where ImportMasterBatchData.batchid=@batchno and ImportMasterBatchData.mastertype like 'Vendor%' and ImportMasterBatchData.tenantid= @tenantid          
end              

--select * from ImportMasterBatchData              
--select c.id,i.masterid from  customers c inner join ImportMasterBatchData i on c.legalname=i.LegalName and c.Name=i.Name and c.ConstitutionType=i.ConstitutionType and c.TenantId=i.TenantId --and i.batchid=131              
--select * from ImportMasterBatchData where batchid=131              
--select * from CustomerTaxDetails              
end                
--------                
                
begin               
              
--select * from [dbo].[CustomerAddress]              
--select * from VI_ImportMasterFiles_Processed order by id desc           
              
update VendorAddress         --   delete from vendors where tenantid=148       
set                      
            [CountryCode]   = i.Nationality                    
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where VendorAddress.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Vendor%' and VendorAddress.VendorID = i.masterid and VendorAddress.TenantId=@tenantid              
                
end                
               
--else                
begin                 
 insert into VendorAddress (TenantId,UniqueIdentifier,VendorID,VendorUniqueIdentifier,CountryCode,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,newid(),Nationality,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(VendorID ,'') from VendorAddress)              
end                
--end                
--select masterid,* from VI_ImportMasterFiles_Processed where batchid=137              
-----------                
              
begin               
              
--select * from CustomerAddress              
--select * from [dbo].[CustomerContactPerson]              
--select * from VI_ImportMasterFiles_Processed              
              
update VendorContactPerson        
set                      
            [Name]   = i.ContactPerson              
     ,[ContactNumber]=i.ContactNumber              
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where VendorContactPerson.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Customer%' and VendorContactPerson.VendorID = i.masterid and VendorContactPerson.TenantId=@tenantid              
                
end                
                
--else                
begin                 
 insert into VendorContactPerson (TenantId,UniqueIdentifier,VendorID,VendorUniqueIdentifier,[Name],ContactNumber,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,NEWID(),Name,ContactNumber,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(VendorID,'') from VendorContactPerson)              
end                
--end                
              
-----------                
                
begin                   
                   
update VendorDocuments 
set                      
            [DocumentTypeCode]   = i.DocumentType            
           ,[DocumentName] = i.documenttype            
     ,[DocumentNumber]=i.DocumentNumber              
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where VendorDocuments.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Vendor%' and VendorDocuments.VendorID = i.masterid               
and VendorDocuments.TenantId=@tenantid and VendorDocuments.DocumentTypeCode=i.DocumentType              
                
end                
                
--else      select * from   VI_ImportMasterFiles_Processed order by id desc        
begin                 
 insert into VendorDocuments (TenantId,UniqueIdentifier,VendorID,VendorUniqueIdentifier,DocumentTypeCode,DocumentName,DocumentNumber,doumentdate,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,newid(),DocumentType,DocumentType,DocumentNumber,CASE WHEN RegistrationDate IS NULL OR RegistrationDate = '' THEN getdate() ELSE RegistrationDate END ,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(VendorID,'') from VendorDocuments)              
end                
--end                
--select * from CustomerDocuments              
----------                
begin               
              
--select * from [dbo].[CustomerForeignEntity]              
--select * from VI_ImportMasterFiles_Processed              
              
update VendorForeignEntity  --  select * from VendorForeignEntity order by id desc
set                      
            [Country]   = i.ParententityCountryCode              
     ,[LegalRepresentative]=i.LegalRepresentative              
           ,[LastModificationTime] = getdate()                      
           ,[LastModifierUserId] = i.LastModifierUserId                      
from VI_ImportMasterFiles_Processed i               
where VendorForeignEntity.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Vendor%' and VendorForeignEntity.VendorID = i.masterid               
and VendorForeignEntity.TenantId=@tenantid and i.ConstitutionType like 'Foreign%'              
                
end                
              
                
--else                
begin                 
 insert into VendorForeignEntity (TenantId,UniqueIdentifier,VendorID,VendorUniqueIdentifier,Country,LegalRepresentative,CreationTime,CreatorUserId,IsDeleted)                
 select TenantId,NEWID(),MasterId,newid(),Nationality,LegalRepresentative,CreationTime,CreatorUserId,IsDeleted                
 from VI_ImportMasterFiles_Processed i                
 where i.TenantId=@tenantid and i.batchid=@batchno  and i.MasterId not in (select isnull(VendorID,'') from VendorForeignEntity)              
end                
            
begin               
              
--select * from [dbo].[CustomerRegDetail]              
--select * from VI_ImportMasterFiles_Processed              
              
update VendorOwnershipDetails
set                   
   PartnerConstitution = i.ConstitutionType,
   PartnerName=i.Name
from VI_ImportMasterFiles_Processed i               
where VendorOwnershipDetails.TenantId=@tenantid and i.batchid=@batchno               
and i.MasterType like 'Customer%' and VendorOwnershipDetails.ID = i.masterid              
--and i.DocumentType=VendorOwnershipDetails.
                
end                
                
            
------------- select * from VI_ImportMasterFiles_Processed          
------------- select * from VendorTaxDetails order by id desc     select * from   CustomerTaxDetails where customerid = 1272

BEGIN
    INSERT INTO VendorTaxDetails (TenantId, UniqueIdentifier, VendorID, VendorUniqueIdentifier,BusinessCategory, OperatingModel, BusinessSupplies,SalesVATCategory, InvoiceType, CreationTime, CreatorUserId, IsDeleted)
    SELECT 
        i.TenantId,
        NEWID(), 
        i.masterid AS VendorID,
        NEWID(), 
		i.BusinessCategory,
        i.OperationalModel,
        i.BusinessPurchase, 
		i.PurchaseVATCategory,
        i.InvoiceType,
        i.CreationTime,
        i.CreatorUserId,
        i.IsDeleted
    FROM 
        VI_ImportMasterFiles_Processed i
    LEFT JOIN 
        CustomerTaxDetails c ON c.CustomerID = i.masterid AND c.TenantId = i.TenantId
    WHERE 
        i.TenantId = @tenantid 
        AND i.batchid = @batchno
        AND (c.BusinessCategory IS NULL OR i.BusinessCategory <> c.BusinessCategory)
        AND (c.OperatingModel IS NULL OR i.OperationalModel <> c.OperatingModel)
        AND (c.BusinessSupplies IS NULL OR i.BusinessPurchase <> c.BusinessSupplies)
        AND (c.SalesVATCategory IS NULL OR i.PurchaseVATCategory <> c.SalesVATCategory)
        AND (c.InvoiceType IS NULL OR i.InvoiceType <> c.InvoiceType);
END
GO
