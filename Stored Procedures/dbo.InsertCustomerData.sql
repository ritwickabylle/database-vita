SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE       PROCEDURE [dbo].[InsertCustomerData]         
( @json NVARCHAR(max),        
@tenantId INT=NULL)        
AS        
  BEGIN        
  
  
  
  
  Declare @id int;        
Declare @custUniqueId uniqueIdentifier;  
Set @custUniqueId = NEWID();  
  INSERT INTO [dbo].[Customers]        
           ([TenantId]        
           ,[UniqueIdentifier]        
           ,[TenantType]        
           ,[ConstitutionType]        
           ,[Name]        
           ,[LegalName]        
           ,[ContactPerson]        
           ,[ContactNumber]        
           ,[EmailID]        
           ,[Nationality]        
           ,[Designation]        
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
     Select @tenantId,        
     @custUniqueId,        
     [TenantType]        
           ,[ConstitutionType]        
           ,[Name]        
           ,[LegalName]        
           ,[ContactPerson]        
           ,[ContactNumber]        
           ,[EmailID]        
           ,[Nationality]        
           ,[Designation]        
           ,getdate()        
           ,1        
           ,0        
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
        )        
        Select @id= SCOPE_IDENTITY()  
    
  
  
        INSERT INTO [dbo].[CustomerAddress]        
           ([TenantId]        
           ,[UniqueIdentifier]        
           ,[CustomerID]        
           ,[CustomerUniqueIdentifier]        
           ,[Street]        
           ,[AdditionalStreet]        
           ,[BuildingNo]        
           ,[AdditionalNo]        
           ,[City]        
           ,[PostalCode]        
           ,[State]        
           ,[Neighbourhood]        
           ,[CountryCode]        
           ,[Type]        
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])        
           Select        
           @tenantId,        
           NEWID(),        
           @id,        
           @custUniqueId        
           ,[Street]        
           ,[AdditionalStreet]        
           ,[BuildingNo]        
           ,[AdditionalNo]        
           ,[City]        
           ,[PostalCode]        
           ,[State]        
           ,[Neighbourhood]        
           ,[CountryCode]        
           ,[Type]        
           ,GETDATE()        
           ,1        
           ,0        
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
        [Type] nvarchar(max) '$.Address."Type"')        
        
  
    
  INSERT INTO [dbo].[CustomerDocuments]        
           ([TenantId]        
           ,[UniqueIdentifier]        
           ,[CustomerID]        
           ,[CustomerUniqueIdentifier]        
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
           NEWID(),        
           @id,        
           @custUniqueId         
           ,ISNULL([DocumentTypeCode],'')        
           ,ISNULL([DocumentName],'')        
           ,ISNULL([DocumentNumber],'')        
           ,ISNULL([DoumentDate],'')          
           ,'Processed'         
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json, '$.Documents')         
        with (        
        [DocumentTypeCode]  nvarchar(max) '$."DocumentTypeCode"',               
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',  
  [DocumentName] nvarchar(max) '$."DocumentName"',  
  [DoumentDate] nvarchar(max) '$."DoumentDate"')    
    
  
  INSERT INTO [dbo].[CustomerTaxDetails]  
           ([TenantId]  
           ,[UniqueIdentifier]  
           ,[CustomerID]  
           ,[CustomerUniqueIdentifier]  
           ,[BusinessCategory]  
           ,[OperatingModel]  
           ,[BusinessSupplies]  
           ,[SalesVATCategory]  
           ,[InvoiceType]  
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])  
  
          Select        
           @tenantId,        
           NEWID(),        
           @id,        
           @custUniqueId         
           ,ISNULL([BusinessCategory],'')        
           ,ISNULL([OperatingModel],'')   
		 ,ISNULL([BusinessSupplies],'')   
        ,ISNULL([SalesVATCategory],'')   
       ,ISNULL([InvoiceType],'')        
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json)         
        with (        
        [BusinessCategory]  nvarchar(max) '$.Taxdetails."BusinessCategory"',   
  [OperatingModel]  nvarchar(max) '$.Taxdetails."OperatingModel"',  
  [BusinessSupplies]  nvarchar(max) '$.Taxdetails."BusinessSupplies"',  
  [SalesVATCategory]  nvarchar(max) '$.Taxdetails."SalesVATCategory"',  
  [InvoiceType]  nvarchar(max) '$.Taxdetails."InvoiceType"')  
  

  INSERT INTO [dbo].[CustomerForeignEntity]
           ([TenantId]
           ,[UniqueIdentifier]
           ,[CustomerID]
           ,[CustomerUniqueIdentifier]
           ,[LegalRepresentative]
           ,[CreationTime]        
           ,[CreatorUserId]        
           ,[IsDeleted])  
  
          Select        
           @tenantId,        
           NEWID(),        
           @id,        
           @custUniqueId         
           ,ISNULL([LegalRepresentative],'')                
           ,GETDATE()        
           ,1        
           ,0        
            from        
     OPENJSON(@json)         
        with (        
        [LegalRepresentative]  nvarchar(max) '$.Foreign."LegalRepresentative"' ) 

End
GO
