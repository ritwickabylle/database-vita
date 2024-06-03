SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--   USE [vitaqa1504]

create     PROCEDURE [dbo].[upadateTenantAdditionalMastersInfo]  
( @json NVARCHAR(MAX) = N'{
  "AdditionalMasterInfo": {
    "zatcaBranch": "qq11",
    "commercialName": "qq11",
    "buildingno": "qq",
    "street": "qq",
    "area": "qq",
    "city": "qq",
    "poBox": "qq",
    "ziPcode": "qq",
    "telephone": "qq",
    "fax": "qq",
    "email": "qq",
    "financialNo": "11",
    "mainActivity": "qq",
    "descriptionofMainActivity": "qq"
  },
  "AdditionalMasterInfoAr": {
    "zatcaBranch": "aa11",
    "commercialName": "aa11",
    "buildingno": "aa",
    "street": "aa",
    "area": "aa",
    "city": "aa",
    "poBox": "qq",
    "ziPcode": "qq",
    "telephone": "qq",
    "fax": "qq",
    "email": "qq",
    "financialNo": "11",
    "mainActivity": "qq",
    "descriptionofMainActivity": "qq"
  }
}',

@userId INT = 191,
@id INT = 159
) 

AS          
BEGIN
  
  DECLARE @count INT;
  SET @count = (SELECT COUNT(*) FROM CIT_TenantAdditionalMastersInformation WHERE TenantId = @id)
  --PRINT @count
  IF(@count>0)
  -- update the tenantmaster information
	BEGIN 
	 With Json_data as         
(   Select      
[TenantId]=@id,    
     [ZatcaBranch]        
           ,[CommercialName]      
     , [Buildingno]    
     , [Street]    
           ,[Area]      
           ,[City]        
           ,[POBox]        
           ,[ZIPcode]        
           ,[Telephone]        
           ,[Fax]     
     ,[Email]    
     ,[FinancialNo]    
     ,[MainActivity]    
    , [DescriptionofMainActivity]    
    
     from        
     OPENJSON(@json,'$.AdditionalMasterInfo')         
        with (        
        [ZatcaBranch] nvarchar(max) '$."zatcaBranch"',         
        [CommercialName] nvarchar(max) '$."commercialName"',         
        [Buildingno] nvarchar(max) '$."buildingno"',      
        [Street] nvarchar(max) '$."street"',         
        [Area] nvarchar(max) '$."area"',         
        [City] nvarchar(max) '$."city"',         
        [POBox] nvarchar(max) '$."poBox"',                  
        [ZIPcode] nvarchar(max) '$."ziPcode"',         
        [Telephone] nvarchar(max) '$."telephone"' ,    
       [Fax] nvarchar(max) '$."fax"' ,    
	   [Email] nvarchar(max) '$."email"',
	   [FinancialNo] nvarchar(max) '$."financialNo"',
  [MainActivity] nvarchar(max) '$."mainActivity"',    
  [DescriptionofMainActivity] nvarchar(max) '$."descriptionofMainActivity"'  
       
        )  )        
Update CS        
set         
cs.ZatcaBranch=jd.zatcaBranch,        
cs.CommercialName=jd.commercialName,    
cs.Buildingno=jd.buildingno,        
cs.Street=jd.street,    
cs.Area=jd.area,    
cs.City=jd.city,    
cs.POBox=jd.poBox,    
cs.ZIPcode=jd.ziPcode,    
cs.Telephone=jd.telephone,    
cs.Fax=jd.fax,    
cs.Email=jd.email,    
cs.FinancialNo=jd.financialNo,        
cs.MainActivity=jd.mainActivity,        
cs.DescriptionofMainActivity=jd.descriptionofMainActivity,          
cs.LastModificationTime=GETDATE(),
cs.LastModifierUserId = @userId
--cs.LastModificationTime=getdate()        
FROM [dbo].[CIT_TenantAdditionalMastersInformation]  as CS        
inner join Json_data as JD on @id=CS.tenantid        
where cs.tenantid=@id AND cs.Language = 'en';



With Json_data as         
(   Select      
[TenantId]=@id,    
     [ZatcaBranch]        
           ,[CommercialName]      
     , [Buildingno]    
     , [Street]    
           ,[Area]      
           ,[City]        
           ,[POBox]        
           ,[ZIPcode]        
           ,[Telephone]        
           ,[Fax]     
     ,[Email]    
     ,[FinancialNo]    
     ,[MainActivity]    
    , [DescriptionofMainActivity]    
    
     from        
     OPENJSON(@json,'$.AdditionalMasterInfoAr')         
        with (        
        [ZatcaBranch] nvarchar(max) '$."zatcaBranch"',         
        [CommercialName] nvarchar(max) '$."commercialName"',         
        [Buildingno] nvarchar(max) '$."buildingno"',      
        [Street] nvarchar(max) '$."street"',         
        [Area] nvarchar(max) '$."area"',         
        [City] nvarchar(max) '$."city"',         
        [POBox] nvarchar(max) '$."poBox"',                  
        [ZIPcode] nvarchar(max) '$."ziPcode"',         
        [Telephone] nvarchar(max) '$."telephone"' ,    
       [Fax] nvarchar(max) '$."fax"' ,    
	   [Email] nvarchar(max) '$."email"',
	   [FinancialNo] nvarchar(max) '$."financialNo"',
  [MainActivity] nvarchar(max) '$."mainActivity"',    
  [DescriptionofMainActivity] nvarchar(max) '$."descriptionofMainActivity"'  
       
        )  )        
Update CS        
set         
cs.ZatcaBranch=jd.zatcaBranch,        
cs.CommercialName=jd.commercialName,    
cs.Buildingno=jd.buildingno,        
cs.Street=jd.street,    
cs.Area=jd.area,    
cs.City=jd.city,    
cs.POBox=jd.poBox,    
cs.ZIPcode=jd.ziPcode,    
cs.Telephone=jd.telephone,    
cs.Fax=jd.fax,    
cs.Email=jd.email,    
cs.FinancialNo=jd.financialNo,        
cs.MainActivity=jd.mainActivity,        
cs.DescriptionofMainActivity=jd.descriptionofMainActivity,          
cs.LastModificationTime=GETDATE(),
cs.LastModifierUserId = @userId
--cs.LastModificationTime=getdate()        
FROM [dbo].[CIT_TenantAdditionalMastersInformation]  as CS        
inner join Json_data as JD on @id=CS.tenantid        
where cs.tenantid=@id AND cs.Language = 'ar';

	END


  ELSE
  -- insert the tenant master additional infromation
	BEGIN

	With Json_data as       
	(        
		   SELECT   
		    [TenantId]=@id,    
			[ZatcaBranch]        
           ,[CommercialName]      
		   ,[Buildingno]    
		   ,[Street]    
           ,[Area]      
           ,[City]        
           ,[POBox]        
           ,[ZIPcode]        
           ,[Telephone]        
           ,[Fax]     
		  ,[Email]    
		  ,[FinancialNo]    
          ,[MainActivity]    
          ,[DescriptionofMainActivity] 
		 
            from        
     OPENJSON(@json,'$.AdditionalMasterInfo')         
        with (      
			[ZatcaBranch] nvarchar(max) '$."zatcaBranch"',         
        [CommercialName] nvarchar(max) '$."commercialName"',         
        [Buildingno] nvarchar(max) '$."buildingno"',      
        [Street] nvarchar(max) '$."street"',         
        [Area] nvarchar(max) '$."area"',         
        [City] nvarchar(max) '$."city"',         
        [POBox] nvarchar(max) '$."poBox"',                  
        [ZIPcode] nvarchar(max) '$."ziPcode"',         
        [Telephone] nvarchar(max) '$."telephone"' ,    
       [Fax] nvarchar(max) '$."fax"' ,    
	   [Email] nvarchar(max) '$."email"',
	   [FinancialNo] nvarchar(max) '$."financialNo"',
		[MainActivity] nvarchar(max) '$."mainActivity"',    
		[DescriptionofMainActivity] nvarchar(max) '$."descriptionofMainActivity"'))   
  
INSERT INTO [dbo].[CIT_TenantAdditionalMastersInformation]      
       (
[TenantId],
[UniqueIdentifier],
[ZatcaBranch],
[CommercialName],
[Buildingno],
[Street],
[Area],
[City],
[POBox],
[ZIPcode],
[Telephone],
[Fax],
[Email],
[FinancialNo],
[MainActivity],
[DescriptionofMainActivity],
[Language],
[CreationTime],
[CreatorUserId],
[IsActive]
		)     
               
Select   
           @id,  
           NEWID(),        
           [ZatcaBranch],        
           [CommercialName],       
           [Buildingno],
		   [Street],
		   [Area],
		   [City],
		   [POBox],
		   [ZIPcode],
		   [Telephone],
		   [Fax],
		   [Email],
		   [FinancialNo],
		   [MainActivity],
		   [DescriptionofMainActivity],
		   'en',
			GETDATE(),
			@userId,
			1
	FROM
		OPENJSON(@json,'$.AdditionalMasterInfo')         
        with (        
        [ZatcaBranch] nvarchar(max) '$."zatcaBranch"',         
        [CommercialName] nvarchar(max) '$."commercialName"',         
        [Buildingno] nvarchar(max) '$."buildingno"',      
        [Street] nvarchar(max) '$."street"',         
        [Area] nvarchar(max) '$."area"',         
        [City] nvarchar(max) '$."city"',         
        [POBox] nvarchar(max) '$."poBox"',                  
        [ZIPcode] nvarchar(max) '$."ziPcode"',         
        [Telephone] nvarchar(max) '$."telephone"' ,    
       [Fax] nvarchar(max) '$."fax"' ,    
	   [Email] nvarchar(max) '$."email"',
	   [FinancialNo] nvarchar(max) '$."financialNo"',
	   [MainActivity] nvarchar(max) '$."mainActivity"',    
	   [DescriptionofMainActivity] nvarchar(max) '$."descriptionofMainActivity"'  
       
        ) ; 
		
		------------------------- Arabic data insertion

		With Json_data as       
	(        
		   SELECT   
		    [TenantId]=@id,    
			[ZatcaBranch]        
           ,[CommercialName]      
		   ,[Buildingno]    
		   ,[Street]    
           ,[Area]      
           ,[City]        
           ,[POBox]        
           ,[ZIPcode]        
           ,[Telephone]        
           ,[Fax]     
		  ,[Email]    
		  ,[FinancialNo]    
          ,[MainActivity]    
          ,[DescriptionofMainActivity] 
		 
            from        
     OPENJSON(@json,'$.AdditionalMasterInfoAr')         
        with (      
			[ZatcaBranch] nvarchar(max) '$."zatcaBranch"',         
        [CommercialName] nvarchar(max) '$."commercialName"',         
        [Buildingno] nvarchar(max) '$."buildingno"',      
        [Street] nvarchar(max) '$."street"',         
        [Area] nvarchar(max) '$."area"',         
        [City] nvarchar(max) '$."city"',         
        [POBox] nvarchar(max) '$."poBox"',                  
        [ZIPcode] nvarchar(max) '$."ziPcode"',         
        [Telephone] nvarchar(max) '$."telephone"' ,    
       [Fax] nvarchar(max) '$."fax"' ,    
	   [Email] nvarchar(max) '$."email"',
	   [FinancialNo] nvarchar(max) '$."financialNo"',
		[MainActivity] nvarchar(max) '$."mainActivity"',    
		[DescriptionofMainActivity] nvarchar(max) '$."descriptionofMainActivity"'))   
  
INSERT INTO [dbo].[CIT_TenantAdditionalMastersInformation]      
       (
[TenantId],
[UniqueIdentifier],
[ZatcaBranch],
[CommercialName],
[Buildingno],
[Street],
[Area],
[City],
[POBox],
[ZIPcode],
[Telephone],
[Fax],
[Email],
[FinancialNo],
[MainActivity],
[DescriptionofMainActivity],
[Language],
[CreationTime],
[CreatorUserId],
[IsActive]
		)     
               
Select   
           @id,  
           NEWID(),        
           [ZatcaBranch],        
           [CommercialName],       
           [Buildingno],
		   [Street],
		   [Area],
		   [City],
		   [POBox],
		   [ZIPcode],
		   [Telephone],
		   [Fax],
		   [Email],
		   [FinancialNo],
		   [MainActivity],
		   [DescriptionofMainActivity],
		   'ar',
			GETDATE(),
			@userId,
			1
	FROM
		OPENJSON(@json,'$.AdditionalMasterInfoAr')         
        with (        
        [ZatcaBranch] nvarchar(max) '$."zatcaBranch"',         
        [CommercialName] nvarchar(max) '$."commercialName"',         
        [Buildingno] nvarchar(max) '$."buildingno"',      
        [Street] nvarchar(max) '$."street"',         
        [Area] nvarchar(max) '$."area"',         
        [City] nvarchar(max) '$."city"',         
        [POBox] nvarchar(max) '$."poBox"',                  
        [ZIPcode] nvarchar(max) '$."ziPcode"',         
        [Telephone] nvarchar(max) '$."telephone"' ,    
       [Fax] nvarchar(max) '$."fax"' ,    
	   [Email] nvarchar(max) '$."email"',
	   [FinancialNo] nvarchar(max) '$."financialNo"',
	   [MainActivity] nvarchar(max) '$."mainActivity"',    
	   [DescriptionofMainActivity] nvarchar(max) '$."descriptionofMainActivity"'  
       
        )        
  



	END
 

END
GO
