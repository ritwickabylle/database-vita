SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  CREATE PROCEDURE [dbo].[InsertTenantShareHolderDetails]                 
( @json NVARCHAR(max)                 
 )                
AS                
  BEGIN                
  --DECLARE @tenantId INT = NULL            
  --set @tenantId=(SELECT top 1 id FROM AbpTenants ORDER  BY id desc)            
  Declare @id int;                
  Select @id= SCOPE_IDENTITY()            
        
            Select @id= SCOPE_IDENTITY()                
        INSERT INTO [dbo].[TenantShareHolders]                
           ([TenantId]                
           ,[UniqueIdentifier]      
     ,[PartnerName]        
     ,[Designation]            
           ,[DomesticName]      
     ,[CapitalAmount]      
     ,[CapitalShare]        
     ,[ConstitutionName]        
     ,[Nationality]        
     ,[RepresentativeName]       
     ,[ProfitShare]        
     ,[Mobile]      
     ,[Email]      
     ,[IdType]      
     ,[IdNumber]      
     ,[NoOfSharePercentage]       
        ,[NoOfShares]       
        ,[ShareHolderExitDate]       
        ,[ShareHolderEntryDate]
		,[SharesSubjectTo]
           ,[CreationTime]                
           ,[CreatorUserId]                
           ,[IsDeleted])                
           Select [TenantId],                
           NEWID(),        
         [PartnerName]        
        ,[Designation]            
        ,[DomesticName],        
         [CapitalAmount],        
         [CapitalShare],        
         [ConstitutionName],        
         [Nationality],        
         [RepresentativeName],        
         [ProfitShare],      
   [Mobile],      
   [Email],      
   [IdType],      
   [IdNumber],      
   [NoOfSharePercentage],      
      [NoOfShares],       
      [ShareHolderExitDate],       
      [ShareHolderEntryDate],
	  [SharesSubjectTo],
           GETDATE()                
           ,1                
           ,0                
            from                
     OPENJSON(@json)                 
        with (        
  [TenantId] nvarchar(max) '$."TenantId"',     
        [PartnerName] nvarchar(max) '$."PartnerName"',        
        [Designation] nvarchar(max) '$."Designation"',        
        [DomesticName]  nvarchar(max) '$."DomesticName"',        
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',        
        [CapitalShare] nvarchar(max) '$."CapitalShare"',        
        [ProfitShare] nvarchar(max) '$."ProfitShare"',        
        [ConstitutionName] nvarchar(max) '$."ConstitutionName"',        
        [Nationality] nvarchar(max) '$."Nationality"',        
        [RepresentativeName] nvarchar(max) '$."RepresentativeName"' ,      
  [Mobile] nvarchar(max) '$."Mobile"',      
  [Email] nvarchar(max) '$."Email"',      
  [IdType] nvarchar(max) '$."IdType"',      
  [IdNumber] nvarchar(max) '$."IdNumber"',      
  [NoOfSharePercentage] nvarchar(max) '$."NoOfSharePercentage"',      
  [NoOfShares] nvarchar(max) '$."NoOfShares"',      
  [ShareHolderExitDate] nvarchar(max) '$."ShareHolderExitDate"',      
  [ShareHolderEntryDate] nvarchar(max) '$."ShareHolderEntryDate"' ,
   [SharesSubjectTo] nvarchar(50) '$."SharesSubjectTo"' 
  )       
    
   Select @id= SCOPE_IDENTITY()      
   INSERT INTO [dbo].[TenantShareHolderAddress]                
           ([TenantShareHolderId]    
           ,[Address1]    
           ,[Address2]    
           ,[City]    
           ,[District]    
           ,[PostalCode]    
           ,[Country])               
           Select @id    
           ,[Address1]    
           ,[Address2]    
           ,[City]    
           ,[District]    
           ,[PostalCode]    
           ,[Country]             
            from                
     OPENJSON(@json)                 
        with (        
  [Address1] nvarchar(max) '$."Address1"',     
        [Address2] nvarchar(max) '$."Address2"',        
        [City] nvarchar(max) '$."City"',        
        [District]  nvarchar(max) '$."District"',        
        [PostalCode] nvarchar(max) '$."PostalCode"',        
        [Country] nvarchar(max) '$."Country"'        
  )       
      
    
    
        
             
End
GO
