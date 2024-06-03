SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule6]    -- exec [InsertDataCIT_Schedule6] 
  @json nvarchar(max) = N'
[
  {
    "Beginningoftheyearbalance": "",
    "BeneficiaryName": "",
    "Chargedtotheaccounts": "2400",
    "Country": "Saudi Arabia",
    "EndoftheyearBalance": "0",
    "IDNumber": "qwwwe",
    "IDType": "TIN",
    "LocalorForeign": "Local",
    "Paidduringtheyear": "2400",
    "ServiceType": "Technical services ",
    "ID": 1,
    "Sr.No": "1",
    "xml_uuid": "b5faae2e-a36c-4edd-85d1-a600c202b5c0"
  }
]
 ',
  @tenantId int = 148,
  @userId int = null,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'  
AS
BEGIN

DECLARE @temp TABLE 
(
	idtype NVARCHAR(MAX),
	IDno NVARCHAR(MAX),
	BeneficiaryName NVARCHAR(MAX),
	LocalORForeign NVARCHAR(MAX),
	Country NVARCHAR(MAX),
	ServiceType NVARCHAR(MAX),
	Beginningoftheyearbalance DECIMAL(18,2),
	Chargedtotheaccounts DECIMAL(18,2),
	Paidduringtheyear DECIMAL(18,2),
	EndoftheyearBalance DECIMAL(18,2)
)
INSERT INTO @temp (idtype, IDno, BeneficiaryName, LocalORForeign, Country, ServiceType, Beginningoftheyearbalance, Chargedtotheaccounts, Paidduringtheyear, EndoftheyearBalance)
SELECT 
     CASE 
        WHEN [IDType] IN ('CRN', 'TIN', 'VAT', 'MOM', 'MLS', 'SAG') THEN [IDType] 
        ELSE 'OTH'
    END AS idtype,
	IDNumber,
    BeneficiaryName, 
    LocalorForeign, 
    Country, 
    ServiceType,  
	TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Beginningoftheyearbalance,0)) AS DECIMAL(18, 2)), 
    TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Chargedtotheaccounts,0)) AS DECIMAL(18, 2)), 
    TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Paidduringtheyear,0)) AS DECIMAL(18, 2)), 
    TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Beginningoftheyearbalance,0)) AS DECIMAL(18, 2))
	+ TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Chargedtotheaccounts,0)) AS DECIMAL(18, 2)) 
	- TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Paidduringtheyear,0)) AS DECIMAL(18, 2))
	FROM OPENJSON(@json)
WITH (
    [Sr.No] NVARCHAR(10),
    [IDType] NVARCHAR(MAX),
    [IDNumber] NVARCHAR(MAX),
    [BeneficiaryName] NVARCHAR(MAX),
    [LocalorForeign] NVARCHAR(MAX),
    Country NVARCHAR(MAX),
    [ServiceType] NVARCHAR(MAX),
    [GLCoderelatingtoBS] NVARCHAR(MAX),
    Beginningoftheyearbalance NVARCHAR(MAX),
    [Chargedtotheaccounts] NVARCHAR(MAX),
    [Paidduringtheyear] NVARCHAR(MAX),
    [EndoftheyearBalance] NVARCHAR(MAX)
);
DECLARE @errormessage NVARCHAR(MAX);
SET @errormessage=''

--Id number--
IF EXISTS(SELECT 1 FROM @temp WHERE IDno is NULL OR IDno='' OR IDno NOT LIKE '%[a-zA-Z0-9]%')
BEGIN
	SET @errormessage=@errormessage+' Enter valid ID number ,'
END
--Local or foreign--
IF EXISTS(SELECT 1 FROM @temp WHERE LocalORForeign not in ('Local' , 'Foreign'))
BEGIN
	SET @errormessage=@errormessage+'  It should be either local or foreign,'
END
--SERVICE TYPE--
IF EXISTS(SELECT 1 FROM @temp WHERE LTRIM(RTRIM(ServiceType)) not in ('Royalty', 'Technical Services','Technical Service','Consulting fees', 'Professional fees'))
BEGIN
	SET @errormessage=@errormessage+' Enter valid service type ,'
END
--Beginningoftheyearbalance................
IF  EXISTS (SELECT 1 FROM @temp WHERE Beginningoftheyearbalance=0 and Chargedtotheaccounts=0 and Paidduringtheyear=0)
BEGIN
   SET @errormessage=@errormessage+ ' At least one of the columns Beginning of the year balance, Charged to the accounts, Paid during the year should contain a value ,';
END;

--COUNTRY--
IF EXISTS(SELECT 1 FROM @temp WHERE Country NOT IN (SELECT AliasName FROM CountryAlias))
BEGIN
	   SET @errormessage=@errormessage+ '  Enter Valid Country ,';
END


IF @errormessage<>''
BEGIN
	 SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);
END

ELSE
BEGIN

		DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(EndoftheyearBalance)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10509
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+' Schedule total does not match with the total in Form- Tax code #10509'
		END

if exists (select top 1 id from [dbo].[CIT_Schedule6]	
	where Tenantid = @tenantId 
	and isActive = 1 
	and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
	and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

	BEGIN
					Delete from [dbo].[CIT_Schedule6] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
	END

		INSERT INTO [dbo].[CIT_Schedule6]
           ([TenantId]
           ,[UniqueIdentifier]
		   	,[IDType],
			[IDNumber],
			[BeneficiaryName],
			[LocalorForeign],
			[Country],
			[ServiceType]  ,
			[Beginningoftheyearbalance],
			[Chargedtotheaccounts],
			[Paidduringtheyear],
			[EndoftheyearBalance],
           [FinancialStartDate]
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
			IDno,
			BeneficiaryName,
			LocalorForeign ,
			Country ,
			ServiceType  ,
			Beginningoftheyearbalance,
			Chargedtotheaccounts,
			Paidduringtheyear,
			EndoftheyearBalance,
		TRY_CAST(@fromdate AS DATE),
		TRY_CAST(@todate AS DATE),
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		TRY_CAST(GETDATE() AS DATE),
		@userId,
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
