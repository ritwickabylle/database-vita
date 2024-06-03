SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
CREATE          PROCEDURE [dbo].[InsertTenantDetails]         
( @json NVARCHAR(max)         
 )        
AS        
  BEGIN        
  DECLARE @tenantId INT = NULL    
  set @tenantId=(SELECT top 1 id FROM AbpTenants ORDER  BY id desc)    
  Declare @id int;        
  Select @id= SCOPE_IDENTITY()    

  INSERT INTO [dbo].[tenantbasicdetails]        
           ([TenantId]        
           ,[UniqueIdentifier]        
           ,[TenantType]        
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
    [VATReturnFillingFrequency],
		[Website],[FaxNo]
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
     Select @tenantId,        
     NEWID(),        
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
    [VATReturnFillingFrequency] ,
		[Website],[FaxNo]
           ,getdate()        
           ,1        
           ,0        
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
   [VATReturnFillingFrequency] nvarchar(max) '$."VATReturnFillingFrequency"' ,       
    	   [Website] nvarchar(max) '$."Website"',
	   [FaxNo] nvarchar(max) '$."FaxNo"'
        )     
    Select @id= SCOPE_IDENTITY()        
        INSERT INTO [dbo].[TenantAddress]        
           ([TenantId]        
           ,[UniqueIdentifier]            
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
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID()         
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
           ,GETDATE()        
           ,1        
           ,0        
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
  [Country] nvarchar(max) '$.Address."Country"')    
        
          Select @id= SCOPE_IDENTITY()        
        INSERT INTO [dbo].[TenantDocuments]        
           ([TenantId]        
           ,[UniqueIdentifier],
		   [DocumentId]
     ,[DocumentType]    
     ,[DocumentNumber],
	 [RegistrationDate]
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID() ,
		   [DocumentId]
     ,[DocumentType] 
     ,[DocumentNumber] ,
	 [RegistrationDate]
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json, '$.Documents')         
        with (     
		      [DocumentId] nvarchar(max) '$."DocumentId"',
      [DocumentType] nvarchar(max) '$."DocumentType"',
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',
		      [RegistrationDate] nvarchar(max) '$."RegistrationDate"'
  )    
  

            Select @id= SCOPE_IDENTITY()        
        INSERT INTO [dbo].[TenantBusinessPurchase]        
           ([TenantId]        
           ,[UniqueIdentifier],
		   [BusinessPurchase],
		   [IsActive]
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID() ,
		   [BusinessPurchase],
		   1
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json)         
        with (     
		      [BusinessPurchase] nvarchar(max) '$.BusinessPurchase."BusinessPurchase"'
  )    

             Select @id= SCOPE_IDENTITY()        
        INSERT INTO [dbo].[TenantBusinessSupplies]        
           ([TenantId]        
           ,[UniqueIdentifier],
		   [BusinessSupplies],
		   [IsActive]
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID() ,
		   [BusinessSupplies],
		   1
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json)         
        with (     
		      [BusinessSupplies] nvarchar(max) '$.businessSupplies."BusinessSupplies"'
			  )

			   Select @id= SCOPE_IDENTITY()        
        INSERT INTO [dbo].[TenantPurchaseVatCateory]        
           ([TenantId]        
           ,[UniqueIdentifier],
		   [VATCategoryName],
		   [IsActive]
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID() ,
		   [VATCategoryName],
		   1
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json)         
        with (     
		      [VATCategoryName] nvarchar(max) '$.purchaseVatCateory."VATCategoryName"'
  )    


  			   Select @id= SCOPE_IDENTITY()        
        INSERT INTO [dbo].[TenantSupplyVATCategory]        
           ([TenantId]        
           ,[UniqueIdentifier],
		   [VATCategoryName],
		   [IsActive]
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID() ,
		   [VATCategoryName],
		   1
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json)         
        with (     
		      [VATCategoryName] nvarchar(max) '$.supplyVATCategory."VATCategoryName"'
  )  


            Select @id= SCOPE_IDENTITY()        
        INSERT INTO [dbo].[TenantShareHolders]        
           ([TenantId]        
           ,[UniqueIdentifier],
		   [PartnerName]
     ,[Designation]    
     ,	[DomesticName],
	 [CapitalAmount],
	 [CapitalShare],
	 [ConstitutionName],
	 [Nationality],
	 [RepresentativeName],
	 [ProfitShare],
           [CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID() ,
		   [PartnerName]
     ,[Designation]    
     ,[DomesticName],
	 [CapitalAmount],
	 [CapitalShare],
	 [ConstitutionName],
	 [Nationality],
	 [RepresentativeName],
	 [ProfitShare]
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json, '$.partnerShareHolders')         
        with (     
		      [PartnerName] nvarchar(max) '$."PartnerName"',
      [Designation] nvarchar(max) '$."Designation"',
	  [DomesticName]  nvarchar(max) '$."DomesticName"',
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',
		      [CapitalShare] nvarchar(max) '$."CapitalShare"',
			  		      [ProfitShare] nvarchar(max) '$."ProfitShare"',
		      [ConstitutionName] nvarchar(max) '$."ConstitutionName"',
		      [Nationality] nvarchar(max) '$."Nationality"',
			  		      [RepresentativeName] nvarchar(max) '$."RepresentativeName"'



  )    



  exec SP_SeedTenantData @tenantId  
     
End
GO
