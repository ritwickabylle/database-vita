SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule3]    -- exec [InsertDataCIT_Schedule3] 
  @json nvarchar(max) = N'
[
  {
    "ContractorName": "Jawodh ceramoic Industry Company",
    "Country": "",
    "IDNumber": "2331212145",
    "IDType": "CRERN",
    "Valueofworksexecuted": "230",
    "ID": 1,
    "Sr.No": "1"
  },
  {
    "ContractorName": "Omega Softwares KSA",
    "Country": "",
    "IDNumber": "2983955790",
    "IDType": "VAEDT",
    "Valueofworksexecuted": "5",
    "ID": 2,
    "Sr.No": "2"
  }
]',
  @tenantId int = 148,
  @userId int = null,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'  
AS
BEGIN
DECLARE @temp TABLE
(
	ContractorName NVARCHAR(MAX),
	Country NVARCHAR(MAX),
	IDNumber NVARCHAR(MAX),
	IDType NVARCHAR(MAX),
	Valueofworksexecuted DECIMAL(18,2) null
)
INSERT INTO @temp (ContractorName, Country, IDNumber, IDType, Valueofworksexecuted)
SELECT ContractorName, 
Country,
IDNumber,
    CASE 
        WHEN [IDType] IN ('CRN', 'TIN', 'VAT', 'MOM', 'MLS', 'SAG') THEN [IDType] 
        ELSE 'OTH'
    END AS idtype,
	case 
		when Valueofworksexecuted = '' or Valueofworksexecuted is null then null
		else TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Valueofworksexecuted, 0)) AS DECIMAL(18, 2))
	end as Valueofworksexecuted
FROM OPENJSON(@json)
WITH (
    ContractorName NVARCHAR(MAX),
    Country NVARCHAR(MAX),
    IDNumber NVARCHAR(MAX),
    IDType NVARCHAR(MAX),
    Valueofworksexecuted NVARCHAR(MAX)
)

DECLARE @errormessage NVARCHAR(MAX);
SET @errormessage=''

--Id number--
IF EXISTS(SELECT 1 FROM @temp WHERE IDNumber is NULL OR IDNumber='' OR IDNumber NOT LIKE '%[a-zA-Z0-9]%')
BEGIN
	SET @errormessage=@errormessage+'  Enter valid ID number,'
END

--Contractor Name--
IF EXISTS(SELECT 1 FROM @temp WHERE ContractorName='' OR ContractorName IS NULL)
BEGIN
	SET @errormessage=@errormessage+'  Enter valid contractor name,'
END

--Optional Fields----
--Country--
IF EXISTS(SELECT 1 FROM @temp WHERE Country <> '' and Country IS NOT NULL)
BEGIN
	IF EXISTS(SELECT 1 FROM @temp WHERE Country NOT IN (SELECT AliasName FROM CountryAlias))
		BEGIN
			   SET @errormessage=@errormessage+ ' Enter valid Country Name,';
		END
END


--Value of works executed in SAR
IF EXISTS(SELECT 1 FROM @temp WHERE Valueofworksexecuted=0)
	BEGIN
		SET @errormessage=@errormessage+ '  Value of works executed can not be zero,';
	END


IF @errormessage <> ''
BEGIN
		 SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);
END
ELSE
BEGIN
		DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(Valueofworksexecuted)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10501
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+'  Schedule total does not match with the total in Form- Tax code #10501'
		END

			if exists (select top 1 id from [dbo].[CIT_Schedule3]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule3] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule3]
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[IDType]
		   ,[IDNumber]
		   ,[ContractorName]
		   ,[Country]
		   ,[Valueofworksexecuted]
           ,[FinancialStartDate]
           ,[FinancialEndDate]
           ,[CreationTime]
           ,[CreatorUserId]
           ,[LastModificationTime]
           ,[LastModifierUserId]
           ,[IsActive])
	SELECT 
		@tenantId,
		NEWID(),
		IDType,
		IDNumber,
		ContractorName,
		Country,
		Valueofworksexecuted,
		TRY_CAST(@fromdate AS DATE),
		TRY_CAST(@todate AS DATE),
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		null,
		null,
		'1'
	FROM @temp
	IF @errormessage1 <>''
	BEGIN
		 SELECT ErrorStatus = 2, ErrorMessage = @errormessage1;   
	END
	ELSE
	BEGIN
		 SELECT ErrorStatus = 0, ErrorMessage = 'SUCCESS'
	END
END
END
GO
