SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[InsertDataCIT_Schedule8]    -- exec [InsertDataCIT_Schedule8] 
  @json nvarchar(max) = N'
[
  {
    "AmendType": "MIXED",
    "Amount": "1000",
    "Description": "All Payments to Partners, Including Salaries and Benefits",
    "LineNo": "1",
    "ID": 1,
    "xml_uuid": "8acc3d1d-babd-4f8f-9156-d4f831089f20"
  },
  {
    "AmendType": "CIT",
    "Amount": "200",
    "Description": "Head Office Management Fees And Other Head Office Expenses",
    "LineNo": "2",
    "ID": 2,
    "xml_uuid": "58943b7b-6c1a-4b00-9bc3-b46ab29e1d14"
  },
  {
    "AmendType": "CIT",
    "Amount": "300",
    "Description": "Social Insurance Paid Abroad",
    "LineNo": "3",
    "ID": 3,
    "xml_uuid": "b92b034c-9333-44c9-a4b6-55052b7227d4"
  },
  {
    "AmendType": "MIXED",
    "Amount": "1000000",
    "Description": "Pension Fund Contributions In Excess Of The Tax0Allowable Amount",
    "LineNo": "4",
    "ID": 4,
    "xml_uuid": "cd956545-2271-4fc6-918c-83a72b4e5ef3"
  },
  {
    "AmendType": "CIT",
    "Amount": "150000",
    "Description": "Entertainment Expenses",
    "LineNo": "5",
    "ID": 5,
    "xml_uuid": "ad6c6d63-bb19-442c-939f-a16ae86c3d40"
  },
  {
    "AmendType": "MIXED",
    "Amount": "4000",
    "Description": "School Fees In Excess Of Tax0Allowable Amount",
    "LineNo": "6",
    "ID": 6,
    "xml_uuid": "18faa317-a719-478e-a47b-a3de301cdaef"
  },
  {
    "AmendType": "CIT",
    "Amount": "54095",
    "Description": "Inadmissible Fines And Penalties",
    "LineNo": "7",
    "ID": 7,
    "xml_uuid": "35fb6e80-64e6-4068-b488-0acf4467e081"
  },
  {
    "AmendType": "CIT",
    "Amount": "6478",
    "Description": "Capital Loss/Gain From The Sale Of Depreciable Assets",
    "LineNo": "8",
    "ID": 8,
    "xml_uuid": "4e762bca-2e5f-4506-8895-3cffbd7fa7b8"
  },
  {
    "AmendType": "MIXED",
    "Amount": "534278",
    "Description": "Unallowable Donations",
    "LineNo": "9",
    "ID": 9,
    "xml_uuid": "ccfc553b-4ab6-49cd-80e8-63e7c0e593cc"
  },
  {
    "AmendType": "MIXED",
    "Amount": "98765",
    "Description": "Income Taxes And Zakat And Any Associated Fines Charged To The Expenses",
    "LineNo": "10",
    "ID": 10,
    "xml_uuid": "1f62d9ac-f6af-4bef-83f0-3733ca1302e6"
  },
  {
    "AmendType": "MIXED",
    "Amount": "21345",
    "Description": "Employees'' Social Insurance And Social Fund Contributions",
    "LineNo": "11",
    "ID": 11,
    "xml_uuid": "45408a4a-d739-484b-bba1-32db7961d2b9"
  },
  {
    "AmendType": "ZAKAT",
    "Amount": "9865",
    "Description": "Adjustment to arm''s length price of costs for materials, services etc. From related parties",
    "LineNo": "12",
    "ID": 12,
    "xml_uuid": "e347316c-fde6-4255-9158-3ed2f29ac68e"
  },
  {
    "AmendType": "MIXED",
    "Amount": "32456",
    "Description": "Expenses Unrelated To Operational Activities",
    "LineNo": "13",
    "ID": 13,
    "xml_uuid": "789b9d70-9c58-4882-a35f-d1b5b01ab4d9"
  },
  {
    "AmendType": "MIXED",
    "Amount": "2345",
    "Description": "Interest on right of use asset",
    "LineNo": "14",
    "ID": 14,
    "xml_uuid": "5d4afb89-1ae5-4e98-bde7-27b32c811178"
  }
]  ',
  @tenantId int = 172,
  @userId int = null,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'  
AS
BEGIN
DECLARE @temp TABLE
(
		Description NVARCHAR(MAX),
		AmendType NVARCHAR(MAX),
		Amount Decimal(18,2),
		ZakatShare DECIMAL(18,2),
		TaxShare DECIMAL(18,2),
		TaxMap NVARCHAR(MAX),
		TotalValueOfTaxMap DECIMAL(18,2),
		Reference NVARCHAR(MAX)

)
INSERT INTO @temp (Description, AmendType, Amount, ZakatShare, TaxShare, TaxMap, TotalValueOfTaxMap, Reference)
SELECT 
	Description,
    AmendType,
     TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Amount, '0')) AS DECIMAL(18, 2)),
	 case
		WHEN AmendType = 'ZAKAT' 
			THEN (0.025 * TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Amount, '0')) AS DECIMAL(18, 2))) 
			ELSE (0.025 * TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(Amount, '0')) AS DECIMAL(18, 2))) 
		END as ZakatShare,
     TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(TaxShare, '0')) AS DECIMAL(18, 2)),
    TaxMap,
    TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(ISNULL(TotalValueOfTaxMap, '0')) AS DECIMAL(18, 2)),
    Reference    
FROM OPENJSON(@json)
WITH (
    Description NVARCHAR(MAX),
    AmendType NVARCHAR(MAX),
    Amount NVARCHAR(MAX),
    ZakatShare NVARCHAR(MAX),
    TaxShare NVARCHAR(MAX),
    TaxMap NVARCHAR(MAX),
    TotalValueOfTaxMap NVARCHAR(MAX),
    Reference NVARCHAR(MAX)
);

DECLARE @errormessage NVARCHAR(MAX);
SET @errormessage='';
--Description--
IF EXISTS(SELECT 1 FROM @temp WHERE Description IS NULL OR Description='')
BEGIN
	SET @errormessage=@errormessage +' Enter valid Description ,' 
END

--Ament type--

IF EXISTS(SELECT 1 FROM @temp WHERE AmendType NOT IN ('CIT','MIXED','ZAKAT'))
BEGIN
	SET @errormessage=@errormessage +' Invalid Amend Type ,' 
END

--Amount--
IF EXISTS(SELECT 1 FROM @temp where amount <0)
BEGIN
	SET @errormessage=@errormessage+' Enter valid Amount,'
END

--Tax MAP--

IF EXISTS(SELECT 1 FROM @temp WHERE TaxMap is not null and TaxMap <>'' and taxmap not in (SELECT taxcode from CIT_GLTaxCodeMaster))
BEGIN
	SET @errormessage=@errormessage+'  Enter Valid Tax Map,'
END

IF @errormessage<>''
BEGIN
		 SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);

END

ELSE
BEGIN
	----Total value pof tax map
		--DECLARE @errormessage1 NVARCHAR(MAX);
		--SET @errormessage1='';
		--IF EXISTS(SELECT 1 FROM @temp WHERE taxmap is not null and TotalValueOfTaxMap<>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=TaxMap
		--and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		--BEGIN
		--	SET @errormessage1=@errormessage1+'  Total amount should match with the trial balance value for the taxcode'
		--END

			DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(Amount)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10901
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+'  Schedule total does not match with the total in Form- Tax code #10901'
		END

				if exists (select top 1 id from [dbo].[CIT_Schedule8]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule8] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END

		INSERT INTO [dbo].[CIT_Schedule8]
           ([TenantId]
           ,[UniqueIdentifier]
		   ,[Description]
		   ,[AmendType]
		   ,[Amount]
		   ,[ZakatShare]
		   ,[TaxShare]
		   ,[TaxMap]
		   ,[TotalValueOfTaxMap]
		   ,[Reference]
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
		Description,
		AmendType,
		Amount,
		ZakatShare,
		TaxShare,
		TaxMap,
		TotalValueOfTaxMap,
		Reference,
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

	EXEC CIS_Implementation @tenantid,@fromdate,@todate

UPDATE CIT_Schedule8
SET ZakatShare = (
    SELECT cc.TotalSaudiShare 
    FROM CIT_CIS cc
    WHERE cc.Description = CIT_Schedule8.Description 
    AND cc.TenantId = @tenantId 
    AND cc.FinancialStartDate = @fromdate 
    AND cc.FinancialEndDate = @todate
)
WHERE CIT_Schedule8.tenantid = @tenantId 
AND CIT_Schedule8.FinancialStartDate = @fromdate 
AND CIT_Schedule8.FinancialEndDate = @todate;

UPDATE CIT_Schedule8
SET taxshare = (
    SELECT cc.TotalNonSaudiShare 
    FROM CIT_CIS cc
    WHERE cc.Description = CIT_Schedule8.Description 
    AND cc.TenantId = @tenantId 
    AND cc.FinancialStartDate = @fromdate 
    AND cc.FinancialEndDate = @todate
)
WHERE CIT_Schedule8.tenantid = @tenantId 
AND CIT_Schedule8.FinancialStartDate = @fromdate 
AND CIT_Schedule8.FinancialEndDate = @todate;


END
END
GO
