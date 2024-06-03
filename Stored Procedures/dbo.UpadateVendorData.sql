SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE        PROCEDURE [dbo].[UpadateVendorData]       
( @json NVARCHAR(max) ,      
@tenantId INT = NULL,    
@id int    
)    
AS      
  BEGIN    
    declare  @vendUniqueId  nvarchar(max)
set @vendUniqueId = (
select UniqueIdentifier from Vendors where id=@id);

  With Json_data as     
(  Select    
 [id]=@id,    
     [TenantType]      
           ,[ConstitutionType]      
           ,[Name]      
           ,[LegalName]      
           ,[ContactPerson]      
           ,[ContactNumber]      
           ,[EmailID]      
           ,[Nationality]      
           ,[Designation]      
     from     
     OPENJSON(@json)       
        with (      
      
        [TenantType] nvarchar(max) '$."TenantType"',       
        [ConstitutionType] nvarchar(max) '$."ConstitutionType"',       
        [Name] nvarchar(max) '$."Name"',       
        [LegalName] nvarchar(max) '$."LegalName"',       
        [ContactPerson] nvarchar(max) '$."ContactPerson"',       
        [ContactNumber] nvarchar(max) '$."ContactNumber"',       
        [EmailID] nvarchar(max) '$."EmailID"',       
        [Nationality] nvarchar(max) '$."Nationality"',       
        [Designation] nvarchar(max) '$."Designation"'      
        ) )    
Update CS    
set     
cs.Name=jd.name,    
cs.ConstitutionType=jd.ConstitutionType,    
cs.ContactNumber=jd.ContactNumber,    
cs.ContactPerson=jd.ContactPerson,    
cs.LegalName=jd.LegalName,    
cs.EmailID=jd.EmailID,    
cs.Nationality=jd.Nationality,    
cs.Designation=jd.Designation,    
cs.TenantType=jd.TenantType,    
cs.LastModificationTime=getdate()    
from Vendors as CS    
inner join Json_data as JD on JD.id=CS.Id    
where cs.id=jd.id;    
    
With Json_data as     
(   Select        
           [id]=@id,      
           [Street]      
           ,[AdditionalStreet]      
           ,[BuildingNo]      
           ,[AdditionalNo]      
           ,[City]      
           ,[PostalCode]      
           ,[State]      
           ,[Neighbourhood]      
           ,[CountryCode]      
           ,[Type]       
            from      
     OPENJSON(@json)       
        with (    
        [Street] nvarchar(max) '$.Address."Street"',       
        [AdditionalStreet] nvarchar(max) '$.Address."AdditionalStreet"',       
        [BuildingNo] nvarchar(max) '$.Address."BuildingNo"',       
        [AdditionalNo] nvarchar(max) '$.Address."AdditionalNo"',       
        [City] nvarchar(max) '$.Address."City"',       
        [PostalCode] nvarchar(max) '$.Address."PostalCode"',       
        [Neighbourhood] nvarchar(max) '$.Address."Neighbourhood"',       
        [State] nvarchar(max) '$.Address."State"',       
        [CountryCode] nvarchar(max) '$.Address."CountryCode"',       
        [Type] nvarchar(max) '$.Address."Type"') )    

Update CA    
set     
ca.Street=jd.Street,    
ca.AdditionalStreet=jd.AdditionalStreet,    
ca.BuildingNo=jd.BuildingNo,    
ca.AdditionalNo=jd.AdditionalNo,    
ca.city=jd.city,    
ca.PostalCode=jd.PostalCode,    
ca.Neighbourhood=jd.Neighbourhood,    
ca.State=jd.State,    
ca.CountryCode=jd.CountryCode,    
ca.Type=jd.Type,    
ca.LastModificationTime=getdate()    
from VendorAddress as ca    
inner join Json_data as JD on JD.id=ca.VendorID    
where ca.VendorID=jd.id; 
  
    
With Json_data as     
(   Select 
		[UniqueId],
           [id]=@id,      
           [DocumentTypeCode]      
           ,[DocumentName]      
           ,[DocumentNumber]      
           ,[DoumentDate]      
           ,[Status] 
            from      
     OPENJSON(@json,'$.Documents')       
        with (    
		[UniqueId] nvarchar(max) '$."UniqueId"',
       [DocumentTypeCode]  nvarchar(max) '$."DocumentTypeCode"',       
        [DocumentName] nvarchar(max) '$."DocumentName"',       
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',       
        [DoumentDate] nvarchar(max) '$."DoumentDate"',       
        [Status] nvarchar(max) '$."Status"') where [UniqueId]<>'00000000-0000-0000-0000-000000000000' )     
 

Update cd    
set     
cd.DocumentNumber=jd.DocumentNumber,    
cd.DocumentName=jd.DocumentName,
cd.DocumentTypeCode=jd.DocumentTypeCode,
cd.DoumentDate=jd.DoumentDate,
cd.LastModificationTime=getdate()    
from VendorDocuments as cd   
inner join Json_data as JD on JD.id=cd.VendorID and jd.UniqueId=cd.UniqueIdentifier   
where cd.VendorID=jd.id;  

    
   With Json_data as     
(   Select        
           [id]=@id,      
           [BusinessCategory]
           ,[OperatingModel]
           ,[BusinessSupplies]
           ,[SalesVATCategory]
           ,[InvoiceType]
            from      
     OPENJSON(@json)       
        with (    
        [BusinessCategory]  nvarchar(max) '$.Taxdetails."BusinessCategory"',   
  [OperatingModel]  nvarchar(max) '$.Taxdetails."OperatingModel"',  
  [BusinessSupplies]  nvarchar(max) '$.Taxdetails."BusinessSupplies"',  
  [SalesVATCategory]  nvarchar(max) '$.Taxdetails."SalesVATCategory"',  
  [InvoiceType]  nvarchar(max) '$.Taxdetails."InvoiceType"') )    

Update ct    
set     
ct.BusinessCategory=jd.BusinessCategory,    
ct.OperatingModel=jd.OperatingModel,    
ct.BusinessSupplies=jd.BusinessSupplies,    
ct.SalesVATCategory=jd.SalesVATCategory,    
ct.InvoiceType=jd.InvoiceType,     
ct.LastModificationTime=getdate()    
from VendorTaxDetails as ct    
inner join Json_data as JD on JD.id=ct.VendorID    
where ct.VendorID=jd.id;    

---delete documents
With Json_data as     
(   Select 
		[UniqueId] as UniqueIdentifier,
           [id]=@id,      
           [DocumentTypeCode]      
           ,[DocumentName]      
           ,[DocumentNumber]      
           ,[DoumentDate]      
           ,[Status] 
            from      
     OPENJSON(@json,'$.Documents')       
        with (    
		[UniqueId] nvarchar(max) '$."UniqueId"',
       [DocumentTypeCode]  nvarchar(max) '$."DocumentTypeCode"',       
        [DocumentName] nvarchar(max) '$."DocumentName"',       
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',       
        [DoumentDate] nvarchar(max) '$."DoumentDate"',       
        [Status] nvarchar(max) '$."Status"') where [UniqueId]<>'00000000-0000-0000-0000-000000000000' )
		
update  cd
set isdeleted=1
from
VendorDocuments cd 
where cd.UniqueIdentifier not in (select UniqueIdentifier from Json_data) and cd.VendorID=@id and TenantId=@tenantId;
--Insert new into documents

With Json_data as     
(   Select 
		[UniqueId],
           [id]=@id,      
           [DocumentTypeCode]      
           ,[DocumentName]      
           ,[DocumentNumber]      
           ,[DoumentDate]      
           ,[Status] 
            from      
     OPENJSON(@json,'$.Documents')       
        with (    
		[UniqueId] nvarchar(max) '$."UniqueId"',
       [DocumentTypeCode]  nvarchar(max) '$."DocumentTypeCode"',       
        [DocumentName] nvarchar(max) '$."DocumentName"',       
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',       
        [DoumentDate] nvarchar(max) '$."DoumentDate"',       
        [Status] nvarchar(max) '$."Status"') where [UniqueId]='00000000-0000-0000-0000-000000000000' )     

INSERT INTO [dbo].VendorDocuments        
           ([TenantId]        
           ,[UniqueIdentifier]        
           ,[VendorID]        
           ,[VendorUniqueIdentifier]        
           ,[DocumentTypeCode]        
           ,[DocumentName]        
          ,[DocumentNumber]        
           ,[DoumentDate]        
           ,[Status]          
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
             
    Select 
		@tenantId,
		newid(),
           @id,
		   @vendUniqueId,
           [DocumentTypeCode]      
           ,[DocumentName]      
           ,[DocumentNumber]      
           ,[DoumentDate]      
           ,[Status] ,
		   GETDATE(),
		   1,
		   0
            from      
     OPENJSON(@json,'$.Documents')       
        with (    
		[UniqueId] nvarchar(max) '$."UniqueId"',
       [DocumentTypeCode]  nvarchar(max) '$."DocumentTypeCode"',       
        [DocumentName] nvarchar(max) '$."DocumentName"',       
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',       
        [DoumentDate] nvarchar(max) '$."DoumentDate"',       
        [Status] nvarchar(max) '$."Status"') where [UniqueId]='00000000-0000-0000-0000-000000000000' ;
    
   With Json_data as     
(   Select        
           [id]=@id,      
           [LegalRepresentative]
            from      
     OPENJSON(@json)       
        with (    
        [LegalRepresentative]  nvarchar(max) '$.foriegn."LegalRepresentative"') )    

Update vf    
set     
vf.LegalRepresentative=jd.LegalRepresentative,    
vf.LastModificationTime=getdate()    
from VendorForeignEntity as vf    
inner join Json_data as JD on JD.id=vf.VendorID    
where vf.VendorID=jd.id;  


end
GO
