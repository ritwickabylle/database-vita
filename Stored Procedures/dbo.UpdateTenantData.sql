SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[UpdateTenantData]           
( @json NVARCHAR(max) ,              
@id int        
)        
AS          
  BEGIN        
  With Json_data as         
(   Select      
[id]=@id,    
     [TenantType]        
           ,[ConstitutionType]      
     , [BusinessCategory]    
     , [OperationalModel]    
           ,[TurnoverSlab]      
           ,[ContactPerson]        
           ,[ContactNumber]        
           ,[EmailID]        
           ,[Nationality]        
           ,[Designation]     
     ,[VATID]    
     ,[ParentEntityName]    
     ,[LegalRepresentative]    
    , [ParentEntityCountryCode]    
    ,[LastReturnFiled],    
    [VATReturnFillingFrequency]      
     from        
     OPENJSON(@json)         
        with (        
        [TenantType] nvarchar(max) '$."TenantType"',         
        [ConstitutionType] nvarchar(max) '$."ConstitutionType"',         
        [BusinessCategory] nvarchar(max) '$."BusinessCategory"',      
        [OperationalModel] nvarchar(max) '$."OperationalModel"',         
        [TurnoverSlab] nvarchar(max) '$."TurnoverSlab"',         
        [ContactPerson] nvarchar(max) '$."ContactPerson"',         
        [ContactNumber] nvarchar(max) '$."ContactNumber"',         
        [EmailID] nvarchar(max) '$."EmailID"',         
        [Nationality] nvarchar(max) '$."Nationality"',         
        [Designation] nvarchar(max) '$."Designation"' ,    
       [VATID] nvarchar(max) '$."VATID"' ,    
  [ParentEntityName] nvarchar(max) '$."ParentEntityName"',    
  [LegalRepresentative] nvarchar(max) '$."LegalRepresentative"',    
   [ParentEntityCountryCode] nvarchar(max) '$."ParentEntityCountryCode"' ,    
        [LastReturnFiled] nvarchar(max) '$."LastReturnFiled"',    
   [VATReturnFillingFrequency] nvarchar(max) '$."VATReturnFillingFrequency"'        
        )  )        
Update CS        
set         
cs.TenantType=jd.TenantType,        
cs.ConstitutionType=jd.ConstitutionType,    
cs.BusinessCategory=jd.BusinessCategory,        
cs.OperationalModel=jd.OperationalModel,    
cs.TurnoverSlab=jd.TurnoverSlab,    
cs.VATID=jd.VATID,    
cs.ParentEntityName=jd.ParentEntityName,    
cs.LegalRepresentative=jd.LegalRepresentative,    
cs.ParentEntityCountryCode=jd.ParentEntityCountryCode,    
cs.LastReturnFiled=jd.LastReturnFiled,    
cs.VATReturnFillingFrequency=jd.VATReturnFillingFrequency,    
cs.ContactNumber=jd.ContactNumber,        
cs.ContactPerson=jd.ContactPerson,           
cs.EmailID=jd.EmailID,        
cs.Nationality=jd.Nationality,        
cs.Designation=jd.Designation,        
cs.LastModificationTime=getdate()        
from tenantbasicdetails as CS        
inner join Json_data as JD on JD.id=CS.tenantid        
where cs.tenantid=jd.id;        
        
With Json_data as         
(   Select            
           [id]=@id       
           ,[Street]        
           ,[AdditionalStreet]        
           ,[BuildingNo]        
           ,[AdditionalBuildingNumber]        
           ,[City]        
           ,[PostalCode]        
           ,[State]        
           ,[Neighbourhood]        
           ,[CountryCode]     
     ,[Country]        
            from          
     OPENJSON(@json)           
        with (        
        [Street] nvarchar(max) '$.Address."Street"',         
        [AdditionalStreet] nvarchar(max) '$.Address."AdditionalStreet"',         
        [BuildingNo] nvarchar(max) '$.Address."BuildingNo"',         
        [AdditionalBuildingNumber] nvarchar(max) '$.Address."AdditionalBuildingNumber"',         
        [City] nvarchar(max) '$.Address."City"',         
        [PostalCode] nvarchar(max) '$.Address."PostalCode"',         
        [Neighbourhood] nvarchar(max) '$.Address."Neighbourhood"',         
        [State] nvarchar(max) '$.Address."State"',         
        [CountryCode] nvarchar(max) '$.Address."CountryCode"',      
  [Country] nvarchar(max) '$.Address."Country"') )        
Update CA        
set         
ca.Street=jd.Street,        
ca.AdditionalStreet=jd.AdditionalStreet,        
ca.BuildingNo=jd.BuildingNo,        
ca.AdditionalBuildingNumber=jd.AdditionalBuildingNumber,        
ca.city=jd.city,        
ca.PostalCode=jd.PostalCode,        
ca.Neighbourhood=jd.Neighbourhood,        
ca.State=jd.State,        
ca.CountryCode=jd.CountryCode,      
ca.country=jd.country,    
ca.LastModificationTime=getdate()        
from tenantaddress as ca        
inner join Json_data as JD on JD.id=ca.tenantid        
where ca.tenantid=jd.id;        
        
        
        
end
GO
