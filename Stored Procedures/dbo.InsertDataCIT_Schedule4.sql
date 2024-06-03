SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       PROCEDURE [dbo].[InsertDataCIT_Schedule4]    -- exec [InsertDataCIT_Schedule4] 
  @json nvarchar(max) = N'

 [
  {
    "BeginningoftheyearBalance": "100000",
    "BeneficiaryName": "Ritwick",
    "ChargetotheAccounts": "15000",
    "Country": "Saudi Arabia",
    "EndoftheyearBalance": "110000",
    "IDNumber": "1234561",
    "IDType": "CRN",
    "LocalorForeign": "",
    "PaidAmount": "5000",
    "ID": 1,
    "Sr.No": "1",
    "xml_uuid": "0f62ffcb-2971-40f0-bcda-d2476b30ead4"
  },
  {
    "BeginningoftheyearBalance": "200000",
    "BeneficiaryName": "Ankit",
    "ChargetotheAccounts": "20000",
    "Country": "China",
    "EndoftheyearBalance": "210000",
    "IDNumber": "2134567",
    "IDType": "TIN",
    "LocalorForeign": "",
    "PaidAmount": "10000",
    "ID": 2,
    "Sr.No": "2",
    "xml_uuid": "be7c8774-63a4-4317-b01f-ab9f1f68de50"
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
		IDType NVARCHAR(MAX),
		IDNumber NVARCHAR(MAX),
		BeneficiaryName NVARCHAR(MAX),
		LocalorForeign NVARCHAR(MAX),
		Country NVARCHAR(MAX),
		BeginningoftheyearBalance DECIMAL(18,2),
		ChargetotheAccounts DECIMAL(18,2),
		PaidAmount DECIMAL(18,2),
		EndoftheyearBalance DECIMAL(18,2)
)

INSERT INTO @temp (IDType, IDNumber, BeneficiaryName, LocalorForeign, Country, BeginningoftheyearBalance, ChargetotheAccounts, PaidAmount, EndoftheyearBalance)
SELECT 
    CASE 
        WHEN [IDType] IN ('CRN', 'TIN', 'VAT', 'MOM', 'MLS', 'SAG') THEN [IDType] 
        ELSE 'OTH'
		END AS idtype,
		IDNumber, 
		BeneficiaryName, 
		LocalorForeign, 
		Country, 
		TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(BeginningoftheyearBalance,0)) AS DECIMAL(18, 2)),
		TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(ChargetotheAccounts,0)) AS DECIMAL(18, 2)),
		TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(PaidAmount,0)) AS DECIMAL(18, 2)),
		(ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(BeginningoftheyearBalance) AS DECIMAL(18, 2)), 0) + ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ChargetotheAccounts) AS DECIMAL(18, 2)), 0))
		- ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(PaidAmount) AS DECIMAL(18, 2)), 0)
FROM OPENJSON(@json)
WITH (
    [Sr.No] NVARCHAR(10),
    IDType NVARCHAR(MAX),
    IDNumber NVARCHAR(MAX),
    BeneficiaryName NVARCHAR(MAX),
    LocalorForeign NVARCHAR(MAX),
    Country NVARCHAR(MAX),
    BeginningoftheyearBalance NVARCHAR(MAX),
    ChargetotheAccounts NVARCHAR(MAX),
    PaidAmount NVARCHAR(MAX),
    EndoftheyearBalance NVARCHAR(MAX)
);

DECLARE @errormessage NVARCHAR(MAX);
SET @errormessage='';

--IDNumber--
IF EXISTS(SELECT 1 FROM @temp WHERE IDNumber is NULL OR IDNumber='' OR IDNumber NOT LIKE '%[a-zA-Z0-9]%')
BEGIN
	SET @errormessage=@errormessage+' Enter valid ID number,'
END

--Local or foreign--
IF EXISTS(SELECT 1 FROM @temp WHERE LocalORForeign not in ('Local' , 'Foreign'))
BEGIN
	SET @errormessage=@errormessage+'  It should be either local or foreign,'
END

--COUNTRY--
IF EXISTS(SELECT 1 FROM @temp WHERE Country NOT IN (SELECT AliasName FROM CountryAlias))
BEGIN
	   SET @errormessage=@errormessage+ '  Enter Valid Country,';
END

--Beginningoftheyearbalance................
IF  EXISTS (SELECT 1 FROM @temp WHERE Beginningoftheyearbalance =0 and ChargetotheAccounts =0 and PaidAmount =0)
BEGIN
   SET @errormessage=@errormessage+ '  Enter value in at least one of the columns-Beginning of the year balance or Charge to the accounts or Paid Amount,';
END;


----Begining of the year balance--
--IF EXISTS(SELECT 1 FROM @temp WHERE BeginningoftheyearBalance =0)
--BEGIN
--	SET @errormessage=@errormessage+' Beginning of the year balance can be negative or positive'
--END

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
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10502
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+'  Schedule total does not match with the total in Form- Tax code #10502'
		END


			if exists (select top 1 id from [dbo].[CIT_Schedule4]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule4] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule4]
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[IDType]
		   ,[IDNumber]
		   ,[BeneficiaryName]
		   ,[LocalorForeign]
		   ,[Country]
		   ,[BeginningoftheyearBalance]
		   ,[ChargetotheAccounts]
		   ,[PaidAmount]
		   ,[EndoftheyearBalance]
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
		BeneficiaryName,
		LocalorForeign,
		Country,
		BeginningoftheyearBalance,
		ChargetotheAccounts,
		PaidAmount,
		EndoftheyearBalance,
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
