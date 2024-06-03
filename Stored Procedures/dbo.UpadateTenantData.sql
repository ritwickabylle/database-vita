SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE       PROCEDURE [dbo].[UpadateTenantData]           
( @json NVARCHAR(max),             
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
    [VATReturnFillingFrequency],
	[Website],[FaxNo]
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
	   [Website] nvarchar(max) '$."Website"',
	   [FaxNo] nvarchar(max) '$."FaxNo"',
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
cs.Website=jd.Website,
cs.FaxNo=jd.FaxNo,
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
    
  
        
  
---update doc data     
With Json_data as       
(   Select   
  [UniqueId],  
           [id]=@id,        
           [DocumentType]        
           ,[DocumentId]        
           ,[DocumentNumber]        
           ,[RegistrationDate]        
            from        
     OPENJSON(@json,'$.Documents')         
        with (      
  [UniqueId] nvarchar(max) '$."DocUniqueId"',  
       [DocumentType]  nvarchar(max) '$."DocumentType"',         
        [DocumentId] nvarchar(max) '$."DocumentId"',         
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',         
        [RegistrationDate] nvarchar(max) '$."RegistrationDate"'         
  ) where [UniqueId]<>'00000000-0000-0000-0000-000000000000' )       
   
  
Update td      
set       
td.documentid=jd.documentid,  
td.DocumentNumber=jd.DocumentNumber,  
td.DocumentType=jd.documenttype,  
td.RegistrationDate=jd.RegistrationDate,  
td.LastModificationTime=getdate()      
from TenantDocuments as td     
inner join Json_data as JD on JD.id=td.TenantId and jd.UniqueId=td.UniqueIdentifier     
where td.TenantId=jd.id;    
   
  
 --delete doc data  
With Json_data as       
(      Select   
  [UniqueId] as UniqueIdentifier,  
           [id]=@id,        
           [DocumentType]        
           ,[DocumentId]        
           ,[DocumentNumber]        
           ,[RegistrationDate]        
            from        
     OPENJSON(@json,'$.Documents')         
        with (      
  [UniqueId] nvarchar(max) '$."DocUniqueId"',  
       [DocumentType]  nvarchar(max) '$."DocumentType"',         
        [DocumentId] nvarchar(max) '$."DocumentId"',         
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',         
        [RegistrationDate] nvarchar(max) '$."RegistrationDate"'   
  )where [UniqueId]<>'00000000-0000-0000-0000-000000000000' )  
    
update  td  
set isdeleted=1  
from  
TenantDocuments td   
where td.UniqueIdentifier not in (select UniqueIdentifier from Json_data where UniqueIdentifier<>'00000000-0000-0000-0000-000000000000') and td.TenantId=@id;  
  
---tenant doc insert data  
With Json_data as       
(        Select   
  [UniqueId],  
           [id]=@id,        
           [DocumentType]        
           ,[DocumentId]        
           ,[DocumentNumber]        
           ,[RegistrationDate]        
            from        
     OPENJSON(@json,'$.Documents')         
        with (      
  [UniqueId] nvarchar(max) '$."DocUniqueId"',  
       [DocumentType]  nvarchar(max) '$."DocumentType"',         
        [DocumentId] nvarchar(max) '$."DocumentId"',         
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',         
        [RegistrationDate] nvarchar(max) '$."RegistrationDate"' ) where [UniqueId]='00000000-0000-0000-0000-000000000000' )       
  
INSERT INTO [dbo].[TenantDocuments]      
           ([UniqueIdentifier]  ,          
           [TenantId] ,         
           [DocumentType]        
           ,[DocumentId]        
           ,[DocumentNumber]        
           ,[RegistrationDate]             
           ,[CreationTime]          
           ,[CreatorUserId]          
           ,[IsDeleted])          
               
Select   
  
  newid(),  
           @id,  
           [DocumentType]        
           ,[DocumentId]        
           ,[DocumentNumber]        
           ,[RegistrationDate],  
     GETDATE(),  
     1,  
     0  
            from        
     OPENJSON(@json,'$.Documents')         
        with (      
  [UniqueId] nvarchar(max) '$."DocUniqueId"',  
       [DocumentType]  nvarchar(max) '$."DocumentType"',         
        [DocumentId] nvarchar(max) '$."DocumentId"',         
        [DocumentNumber] nvarchar(max) '$."DocumentNumber"',         
        [RegistrationDate] nvarchar(max) '$."RegistrationDate"') where [UniqueId]='00000000-0000-0000-0000-000000000000' ;  
  
  
  
  
  
  
  
  
---update partner data     
With Json_data as       
(   Select   
  [UniqueId],  
           [id]=@id,  
     [PartnerName],  
     [Designation],  
     [DomesticName],  
     [CapitalAmount],  
     [CapitalShare],  
     [ProfitShare],  
     [ConstitutionName],  
     [Nationality],  
     [RepresentativeName]  
            from          
     OPENJSON(@json, '$.partnerShareHolders')           
        with (       
    [UniqueId] nvarchar(max) '$."ShareUniqueId"',  
        [PartnerName] nvarchar(max) '$."PartnerName"',  
      [Designation] nvarchar(max) '$."Designation"',  
   [DomesticName]  nvarchar(max) '$."DomesticName"',  
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',  
        [CapitalShare] nvarchar(max) '$."CapitalShare"',  
             [ProfitShare] nvarchar(max) '$."ProfitShare"',  
        [ConstitutionName] nvarchar(max) '$."ConstitutionName"',  
        [Nationality] nvarchar(max) '$."Nationality"',  
             [RepresentativeName] nvarchar(max) '$."RepresentativeName"'        
  ) where [UniqueId]<>'00000000-0000-0000-0000-000000000000' )       
   
  
Update ts      
set       
ts.PartnerName=jd.partnername,  
ts.designation=jd.designation,  
ts.DomesticName=jd.domesticname,  
ts.CapitalAmount=jd.capitalamount,  
ts.CapitalShare=jd.capitalshare,  
ts.ProfitShare=jd.profitshare,  
ts.ConstitutionName=jd.constitutionname,  
ts.nationality=jd.nationality,  
ts.LastModificationTime=getdate()      
from TenantShareHolders as ts  
inner join Json_data as JD on JD.id=ts.TenantId and jd.UniqueId=ts.UniqueIdentifier     
where ts.TenantId=jd.id;    
  
With Json_data as       
(   Select   
  [UniqueId],  
           [id]=@id,        
     [PartnerName],  
     [Designation],  
     [DomesticName],  
     [CapitalAmount],  
     [CapitalShare],  
     [ProfitShare],  
     [ConstitutionName],  
     [Nationality],  
     [RepresentativeName]       
            from        
     OPENJSON(@json, '$.partnerShareHolders')           
        with (       
    [UniqueId] nvarchar(max) '$."ShareUniqueId"',  
        [PartnerName] nvarchar(max) '$."PartnerName"',  
      [Designation] nvarchar(max) '$."Designation"',  
   [DomesticName]  nvarchar(max) '$."DomesticName"',  
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',  
        [CapitalShare] nvarchar(max) '$."CapitalShare"',  
             [ProfitShare] nvarchar(max) '$."ProfitShare"',  
        [ConstitutionName] nvarchar(max) '$."ConstitutionName"',  
        [Nationality] nvarchar(max) '$."Nationality"',  
             [RepresentativeName] nvarchar(max) '$."RepresentativeName"'       
  ) where [UniqueId]<>'00000000-0000-0000-0000-000000000000' )       
   
  
Update ts      
set       
ts.PartnerName=jd.partnername,  
ts.designation=jd.designation,  
ts.DomesticName=jd.domesticname,  
ts.CapitalAmount=jd.capitalamount,  
ts.CapitalShare=jd.capitalshare,  
ts.ProfitShare=jd.profitshare,  
ts.ConstitutionName=jd.constitutionname,  
ts.nationality=jd.nationality,  
ts.LastModificationTime=getdate()      
from TenantShareHolders as ts  
inner join Json_data as JD on JD.id=ts.TenantId and jd.UniqueId=ts.UniqueIdentifier     
where ts.TenantId=jd.id;     
  
  
--delete TENANT data  
With Json_data as       
(   Select   
  [UniqueId],  
           [id]=@id,        
     [PartnerName],  
     [Designation],  
     [DomesticName],  
     [CapitalAmount],  
     [CapitalShare],  
     [ProfitShare],  
     [ConstitutionName],  
     [Nationality],  
     [RepresentativeName]       
            from        
     OPENJSON(@json, '$.partnerShareHolders')           
        with (       
    [UniqueId] nvarchar(max) '$."ShareUniqueId"',  
        [PartnerName] nvarchar(max) '$."PartnerName"',  
      [Designation] nvarchar(max) '$."Designation"',  
   [DomesticName]  nvarchar(max) '$."DomesticName"',  
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',  
        [CapitalShare] nvarchar(max) '$."CapitalShare"',  
             [ProfitShare] nvarchar(max) '$."ProfitShare"',  
        [ConstitutionName] nvarchar(max) '$."ConstitutionName"',  
        [Nationality] nvarchar(max) '$."Nationality"',  
             [RepresentativeName] nvarchar(max) '$."RepresentativeName"'   
  )where [UniqueId]<>'00000000-0000-0000-0000-000000000000' )  
    
update  tsh  
set isdeleted=1  
from  
TenantShareHolders tsh   
where tsh.UniqueIdentifier not in (select UniqueId from Json_data where UniqueId<>'00000000-0000-0000-0000-000000000000') and tsh.TenantId=@id;  
  
  
---tenant partner insert data  
With Json_data as       
(   Select   
  [UniqueId],  
           [id]=@id,        
     [PartnerName],  
     [Designation],  
     [DomesticName],  
     [CapitalAmount],  
     [CapitalShare],  
     [ProfitShare],  
     [ConstitutionName],  
     [Nationality],  
     [RepresentativeName]       
            from        
     OPENJSON(@json, '$.partnerShareHolders')           
        with (       
    [UniqueId] nvarchar(max) '$."ShareUniqueId"',  
        [PartnerName] nvarchar(max) '$."PartnerName"',  
      [Designation] nvarchar(max) '$."Designation"',  
   [DomesticName]  nvarchar(max) '$."DomesticName"',  
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',  
        [CapitalShare] nvarchar(max) '$."CapitalShare"',  
             [ProfitShare] nvarchar(max) '$."ProfitShare"',  
        [ConstitutionName] nvarchar(max) '$."ConstitutionName"',  
        [Nationality] nvarchar(max) '$."Nationality"',  
             [RepresentativeName] nvarchar(max) '$."RepresentativeName"')  where [UniqueId]='00000000-0000-0000-0000-000000000000' )       
  
INSERT INTO [dbo].[TenantShareHolders]      
           ([UniqueIdentifier]  ,  
     [TenantId],  
     [PartnerName],  
     [Designation],  
     [DomesticName],  
     [CapitalAmount],  
     [CapitalShare],  
     [ProfitShare],  
     [ConstitutionName],  
     [Nationality],  
     [RepresentativeName]              
           ,[CreationTime]          
           ,[CreatorUserId]          
           ,[IsDeleted])          
               
   Select   
  newid(),  
           [id]=@id,        
     [PartnerName],  
     [Designation],  
     [DomesticName],  
     [CapitalAmount],  
     [CapitalShare],  
     [ProfitShare],  
     [ConstitutionName],  
     [Nationality],  
     [RepresentativeName] ,  
     getdate(),  
     1,  
     0  
            from        
     OPENJSON(@json, '$.partnerShareHolders')           
        with (       
    [UniqueId] nvarchar(max) '$."ShareUniqueId"',  
        [PartnerName] nvarchar(max) '$."PartnerName"',  
      [Designation] nvarchar(max) '$."Designation"',  
   [DomesticName]  nvarchar(max) '$."DomesticName"',  
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',  
        [CapitalShare] nvarchar(max) '$."CapitalShare"',  
             [ProfitShare] nvarchar(max) '$."ProfitShare"',  
        [ConstitutionName] nvarchar(max) '$."ConstitutionName"',  
        [Nationality] nvarchar(max) '$."Nationality"',  
             [RepresentativeName] nvarchar(max) '$."RepresentativeName"')  where [UniqueId]='00000000-0000-0000-0000-000000000000' ;  
  
  
  
  
--businesspurchaseupdate  
   With Json_data as       
(   Select          
           [id]=@id,        
           [BusinessPurchase]  
            from        
     OPENJSON(@json)         
        with (      
        [BusinessPurchase]  nvarchar(max) '$.BusinessPurchase."BusinessPurchase"') )      
  
Update tb      
set       
tb.BusinessPurchase=jd.BusinessPurchase,      
tb.LastModificationTime=getdate()      
from TenantBusinessPurchase as tb      
inner join Json_data as JD on JD.id=tb.TenantId      
where tb.TenantId=jd.id;   
  
  
--businesssupplies  
  
   With Json_data as       
(   Select          
           [id]=@id,        
           [BusinessSupplies]  
            from        
     OPENJSON(@json)         
        with (      
        [BusinessSupplies]  nvarchar(max) '$.businessSupplies."BusinessSupplies"') )      
  
Update tbs      
set       
tbs.BusinessSupplies=jd.BusinessSupplies,      
tbs.LastModificationTime=getdate()      
from TenantBusinessSupplies as tbs      
inner join Json_data as JD on JD.id=tbs.TenantId      
where tbs.TenantId=jd.id;  
  
  
--supplyvatcategory  
   With Json_data as       
(   Select          
           [id]=@id,        
           [VATCategoryName]  
            from        
     OPENJSON(@json)         
        with (      
        [VATCategoryName]  nvarchar(max) '$.supplyVATCategory."VATCategoryName"') )      
  
Update tsv      
set       
tsv.VATCategoryName=jd.VATCategoryName,      
tsv.LastModificationTime=getdate()      
from TenantSupplyVATCategory as tsv      
inner join Json_data as JD on JD.id=tsv.TenantId      
where tsv.TenantId=jd.id;  
  
  
--purchasevatcategory  
   With Json_data as       
(   Select          
           [id]=@id,        
           [VATCategoryName]  
            from        
     OPENJSON(@json)         
        with (      
        [VATCategoryName]  nvarchar(max) '$.purchaseVatCateory."VATCategoryName"') )      
  
Update tsv      
set       
tsv.VATCategoryName=jd.VATCategoryName,      
tsv.LastModificationTime=getdate()      
from TenantPurchaseVatCateory as tsv      
inner join Json_data as JD on JD.id=tsv.TenantId      
where tsv.TenantId=jd.id;  

--bankdetails
Begin
	DECLARE @index int = 0;
	DECLARE @bankDetails nvarchar(max) = JSON_QUERY(@json, '$.bankDetails');
	DECLARE @totalCount int = 0;

	IF ISJSON(@bankDetails) > 0
	BEGIN
		WHILE JSON_VALUE(@json, CONCAT('lax $.bankDetails[', @index, '].UniqueIdentifier')) IS NOT NULL
		BEGIN
			SET @index = @index + 1;
			SET @totalCount = @totalCount + 1;
		END
	END
	print @totalCount
	SET @index = 0;
	WHILE @index < @totalCount
	BEGIN
		DECLARE @uniqueIdentifier uniqueidentifier;
		SELECT @uniqueIdentifier = JSON_VALUE(@json, CONCAT('$.bankDetails[', @index, '].UniqueIdentifier'));

		IF EXISTS (SELECT * FROM TenantBankDetail WHERE TenantId = @id AND UniqueIdentifier = @uniqueIdentifier)
		BEGIN
			WITH Json_data AS         
			(   
				SELECT            
					[id] = @id,       
					[AccountName],        
					[AccountNumber],        
					[IBAN],        
					[BankName],  
					[BranchAddress],
					[CurrencyCode],
					[SwiftCode],
					[IsDefault],
					[IsActive]
				FROM          
					OPENJSON(@json, '$.bankDetails[' + CAST(@index AS NVARCHAR(10)) + ']')           
				WITH (        
					[AccountName] nvarchar(max) '$.AccountName',         
					[AccountNumber] nvarchar(max) '$.AccountNumber',         
					[IBAN] nvarchar(max) '$.IBAN',         
					[BankName] nvarchar(max) '$.BankName', 
					[BranchAddress] nvarchar(max) '$.BranchAddress', 
					[CurrencyCode] nvarchar(max) '$.CurrencyCode', 
					[SwiftCode] nvarchar(max) '$.SwiftCode',
					[IsDefault] nvarchar(max) '$.IsDefault',
					[IsActive] nvarchar(max) '$.IsActive'
				)
			) 

			UPDATE tbd        
			SET         
				tbd.AccountName = jd.AccountName,        
				tbd.AccountNumber = jd.AccountNumber,        
				tbd.IBAN = jd.IBAN,        
				tbd.BankName = jd.BankName, 
				tbd.BranchAddress = jd.BranchAddress,
				tbd.CurrencyCode = jd.CurrencyCode,
				tbd.SwiftCode = jd.SwiftCode,  
				tbd.IsDefault = jd.IsDefault,
				tbd.IsActive = jd.IsActive
			FROM TenantBankDetail AS tbd        
			INNER JOIN Json_data AS JD ON JD.id = tbd.tenantid        
			WHERE tbd.TenantId = jd.id AND tbd.UniqueIdentifier = @uniqueIdentifier;
		END
		ELSE
		BEGIN
			WITH Json_data AS         
			(   
				SELECT            
					[id] = @id,       
					[AccountName],        
					[AccountNumber],        
					[IBAN],        
					[BankName], 
					[BranchAddress],
					[CurrencyCode],
					[SwiftCode],
					[IsDefault]
				FROM          
					OPENJSON(@json, '$.bankDetails[' + CAST(@index AS NVARCHAR(10)) + ']')           
				WITH (        
					[AccountName] nvarchar(max) '$.AccountName',         
					[AccountNumber] nvarchar(max) '$.AccountNumber',         
					[IBAN] nvarchar(max) '$.IBAN',         
					[BankName] nvarchar(max) '$.BankName',
					[BranchAddress] nvarchar(max) '$.BranchAddress', 
					[CurrencyCode] nvarchar(max) '$.CurrencyCode', 
					[SwiftCode] nvarchar(max) '$.SwiftCode',
					[IsDefault] nvarchar(max) '$.IsDefault'
				)
			) 

			INSERT INTO TenantBankDetail ([UniqueIdentifier], [TenantId], [AccountName], [AccountNumber], [IBAN], [BankName],[BranchAddress], [CurrencyCode], [SwiftCode], [IsActive], [CreationTime], [IsDeleted],[IsDefault])
			SELECT newid(), [id], [AccountName], [AccountNumber], [IBAN], [BankName], [BranchAddress], [CurrencyCode], [SwiftCode], 1, GETDATE(), 0, [IsDefault]
			FROM Json_data;
		END

		-- Increment index for the next iteration
		SET @index = @index + 1;
	END
	End
end
GO
