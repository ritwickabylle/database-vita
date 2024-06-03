SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     PROCEDURE [dbo].[InsertDataCIT_Schedule2]    -- exec [InsertDataCIT_Schedule2] 
  @json nvarchar(max) = N'
  [
[
  {
    "AmendmentsToOriginalValue": "       45,78,800",
    "CompletionPercentage": "0.756937",
    "ContractDate": "3/12/2023 12:00:00 AM",
    "ContractEstimatedCost": "        12,39,710",
    "ContractValueAfterAmendments": "      2,00,83,800",
    "ContractingParty": "Hussein Ali Costructions",
    "IDNumber": "SA20154",
    "IDType": "CRN",
    "OriginalValue": "    1,55,05,000",
    "RevenuesAccordingToCompletionPriorYear": "        12,33,901",
    "RevenuesAccordingToCompletionToDate": "    1,52,01,428.22",
    "RevenuesAccordingToCompletionDuringCurrentYear": "   1,39,67,527.22",
    "TotalActualCostsIncurred": "           9,38,286",
    "ID": 1,
    "Sr.No": "1",
    "xml_uuid": "cbb95a7f-31ae-46f8-9349-2bd54b1de393"
  }
]
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
	ContractingParty NVARCHAR(MAX),
	ContractDate DATETIME,
	OriginalValue DECIMAL(18,2),
	AmendmentsToOriginalValue DECIMAL(18,2),
	ContractValueAfterAmendments DECIMAL(18,2),
	TotalActualCostsIncurred DECIMAL(18,2),
	ContractEstimatedCost DECIMAL(18,2),
	CompletionPercentage DECIMAL(18,4),
	RevenuesAccordingToCompletionToDate DECIMAL(18,2),
	RevenuesAccordingToCompletionPriorYear DECIMAL(18,2),
	RevenuesAccordingToCompletionDuringCurrentYear DECIMAL(18,2)
)


INSERT INTO @temp (IDType, IDNumber, ContractingParty, ContractDate, OriginalValue, AmendmentsToOriginalValue, ContractValueAfterAmendments, TotalActualCostsIncurred, ContractEstimatedCost, CompletionPercentage, RevenuesAccordingToCompletionToDate, RevenuesAccordingToCompletionPriorYear, RevenuesAccordingToCompletionDuringCurrentYear)
SELECT 
    CASE 
        WHEN [IDType] IN ('CRN', 'TIN', 'VAT', 'MOM', 'MLS', 'SAG') THEN [IDType]
        ELSE 'OTH'
    END AS idtype,
    [IDNumber],
    [ContractingParty],
    CONVERT(DATETIME, [ContractDate], 101),
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([OriginalValue]) AS DECIMAL(18, 2)), 0), 
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([AmendmentsToOriginalValue]) AS DECIMAL(18, 2)), 0), 
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([OriginalValue]) AS DECIMAL(18, 2)), 0) +
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([AmendmentsToOriginalValue]) AS DECIMAL(18, 2)), 0), 
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([TotalActualCostsIncurred]) AS DECIMAL(18, 2)), 0), 
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([ContractEstimatedCost]) AS DECIMAL(18, 2)), 0),
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([CompletionPercentage]) AS DECIMAL(18, 4)), 0), 
	((ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([OriginalValue]) AS DECIMAL(18, 2)), 0)) +
	(ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([AmendmentsToOriginalValue]) AS DECIMAL(18, 2)), 0))) * (ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([CompletionPercentage]) AS DECIMAL(18, 4)), 0)), 
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([RevenuesAccordingToCompletionPriorYear]) AS DECIMAL(18, 2)), 0), 
	ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([RevenuesAccordingToCompletionDuringCurrentYear]) AS DECIMAL(18, 2)), 0)

FROM OPENJSON(@json)
WITH (
    [IDType] NVARCHAR(MAX),
    [IDNumber] NVARCHAR(MAX),
    [ContractingParty] NVARCHAR(MAX),
    [ContractDate] NVARCHAR(MAX),
    [OriginalValue] NVARCHAR(MAX),
    [AmendmentsToOriginalValue] NVARCHAR(MAX),
    [ContractValueAfterAmendments] NVARCHAR(MAX),
    [TotalActualCostsIncurred] NVARCHAR(MAX),
    [ContractEstimatedCost] NVARCHAR(MAX),
    [CompletionPercentage] NVARCHAR(MAX),
    [RevenuesAccordingToCompletionToDate] NVARCHAR(MAX),
    [RevenuesAccordingToCompletionPriorYear] NVARCHAR(MAX),
    [RevenuesAccordingToCompletionDuringCurrentYear] NVARCHAR(MAX),
    xml_uuid NVARCHAR(MAX)
);


DECLARE @errormessage NVARCHAR(MAX);
set @errormessage = '';

--Id type --

IF  EXISTS(SELECT 1 FROM @temp WHERE idtype not in('CRN','TIN','VAT','MOM','MLS','SAG','OTH'))
BEGIN
	SET @errormessage= @errormessage + 'Enter valid  Id type ,'
END

--Contracting Party--

IF EXISTS(SELECT 1 FROM @temp WHERE ContractingParty is NULL OR ContractingParty='' OR  ContractingParty NOT LIKE '%[a-zA-Z0-9]%')
BEGIN
	SET @errormessage=@errormessage+' Enter valid Contracting Party ,'
END

--ORIGINAL VALUE

IF EXISTS(SELECT 1 FROM @temp WHERE ISNUMERIC(originalValue) = 0 OR originalValue<0 or originalValue=0)
BEGIN
	SET @errormessage=@errormessage+' Original Value Should be greater than zero,'
END

--Contract date----

IF EXISTS (SELECT 1 from @temp WHERE ContractDate>
(SELECT EffectiveTillEndDate from FinancialYear  WHERE TenantId=@tenantId) 
OR ContractDate ='' OR ContractDate IS NULL OR TRY_CONVERT(DATE, ContractDate, 101) IS NULL )
BEGIN
	SET @errormessage=@errormessage+' Contract Date should be less than active financial year end date,'
END

--Amendments to original value--

IF EXISTS(SELECT 1 FROM @temp WHERE AmendmentsToOriginalValue =0 OR ISNUMERIC(AmendmentsToOriginalValue) =0)
BEGIN
	SET @errormessage=@errormessage+' Amendment Storing value should not be zero,'
END


IF @errormessage <> ''          
 
BEGIN          
        SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);     
END   

ELSE
BEGIN
if exists (select top 1 id from [dbo].[CIT_Schedule2]
where Tenantid = @tenantId 
and isActive = 1 
and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 
BEGIN
		Delete from [dbo].[CIT_Schedule2] where Tenantid = @tenantId 
		and isActive = 1 
		and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
		and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
END
INSERT INTO [dbo].[CIT_Schedule2]
			([TenantId]
           ,[UniqueIdentifier]
           ,[IDType]
           ,[IDNumber]
           ,[ContractingParty]
           ,[ContractDate]
           ,[OriginalValue]
           ,[AmendmentsToOriginalValue]
           ,[ContractValueAfterAmendments]
           ,[TotalActualCostsIncurred]
           ,[ContractEstimatedCost]
           ,[CompletionPercentage]
           ,[RevenuesAccordingToCompletionToDate]
           ,[RevenuesAccordingToCompletionPriorYear]
           ,[RevenuesAccordingToCompletionDuringCurrentYear]
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
		ContractingParty,
		ContractDate,
		dbo.ConvertAndReplaceStringToDecimal(OriginalValue),
		dbo.ConvertAndReplaceStringToDecimal(AmendmentsToOriginalValue),
		dbo.ConvertAndReplaceStringToDecimal(ContractValueAfterAmendments),
		dbo.ConvertAndReplaceStringToDecimal(TotalActualCostsIncurred),
		dbo.ConvertAndReplaceStringToDecimal(ContractEstimatedCost),
		dbo.ConvertAndReplaceStringToDecimal(CompletionPercentage),
		dbo.ConvertAndReplaceStringToDecimal(RevenuesAccordingToCompletionToDate),
		dbo.ConvertAndReplaceStringToDecimal(RevenuesAccordingToCompletionPriorYear),
		dbo.ConvertAndReplaceStringToDecimal(RevenuesAccordingToCompletionDuringCurrentYear),
		TRY_CAST(@fromdate AS DATE),
		TRY_CAST(@todate AS DATE),
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		TRY_CAST(GETDATE() AS DATE),
		@userId,
		'1'
	FROM  @temp
	 SELECT ErrorStatus = 0, ErrorMessage = 'SUCCESS'
END
END
GO
