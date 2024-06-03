SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[InsertDataCIT_Schedule9]    -- exec [InsertDataCIT_Schedule9] 
  @json nvarchar(max) = N'
[
  {
    "50PercentTotalCostAdditionsDuringCurAndPreYears": "375000",
    "50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear": "  ",
    "CompForAssetsNotQualifyDepreciationCurYear": "",
    "CompForAssetsNotQualifyDepreciationPreYear": "",
    "DepreciationAmortizationRatioPercentage": "",
    "DepreciationAmortizationValue": "",
    "GroupNo": "Land",
    "RepairAndImprovementCostForTheGroup": "",
    "RepairAndImprovementExpensesExceeding4Percent": "",
    "TheCostOfCurrentAdditions": "",
    "TheCostOfPreviousYearAdditions": "750000",
    "TheGroupValueAtEndOfPreviousYear": "6375000",
    "TheRemainingOfTheGroupAtTheEndOfTheCurrentYear": "6750000",
    "TheRemainingValueOfTheGroup": "6750000",
    "TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear": "6750000",
    "ID": 1,
    "xml_uuid": "d3ac90bc-4122-447f-acc8-86d15b9d0f01"
  },
  {
    "50PercentTotalCostAdditionsDuringCurAndPreYears": "2346361",
    "50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear": "",
    "CompForAssetsNotQualifyDepreciationCurYear": "",
    "CompForAssetsNotQualifyDepreciationPreYear": "",
    "DepreciationAmortizationRatioPercentage": "",
    "DepreciationAmortizationValue": "",
    "GroupNo": "First - Fixed Buildings",
    "RepairAndImprovementCostForTheGroup": "27288",
    "RepairAndImprovementExpensesExceeding4Percent": "",
    "TheCostOfCurrentAdditions": "2053522",
    "TheCostOfPreviousYearAdditions": "2639199",
    "TheGroupValueAtEndOfPreviousYear": "8508845",
    "TheRemainingOfTheGroupAtTheEndOfTheCurrentYear": "10312445",
    "TheRemainingValueOfTheGroup": "10855205",
    "TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear": "10312445",
    "ID": 2,
    "xml_uuid": "35251be0-07ba-426c-ac64-aca10278374d"
  },
  {
    "50PercentTotalCostAdditionsDuringCurAndPreYears": "77290",
    "50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear": "58025",
    "CompForAssetsNotQualifyDepreciationCurYear": "116050",
    "CompForAssetsNotQualifyDepreciationPreYear": "",
    "DepreciationAmortizationRatioPercentage": "",
    "DepreciationAmortizationValue": "",
    "GroupNo": "Second - Industrial and Agricultural Portable Buildings",
    "RepairAndImprovementCostForTheGroup": " ",
    "RepairAndImprovementExpensesExceeding4Percent": "",
    "TheCostOfCurrentAdditions": "33466",
    "TheCostOfPreviousYearAdditions": "121113",
    "TheGroupValueAtEndOfPreviousYear": "3267847",
    "TheRemainingOfTheGroupAtTheEndOfTheCurrentYear": "2958400",
    "TheRemainingValueOfTheGroup": "3287111",
    "TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear": "2958400",
    "ID": 3,
    "xml_uuid": "5808ccab-5bbb-4147-9812-55dde4a157eb"
  },
  {
    "50PercentTotalCostAdditionsDuringCurAndPreYears": "",
    "50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear": "",
    "CompForAssetsNotQualifyDepreciationCurYear": "20",
    "CompForAssetsNotQualifyDepreciationPreYear": "10",
    "DepreciationAmortizationRatioPercentage": "",
    "DepreciationAmortizationValue": "",
    "GroupNo": "asdfedwa",
    "RepairAndImprovementCostForTheGroup": "20",
    "RepairAndImprovementExpensesExceeding4Percent": "",
    "TheCostOfCurrentAdditions": "30",
    "TheCostOfPreviousYearAdditions": "10",
    "TheGroupValueAtEndOfPreviousYear": "4000",
    "TheRemainingOfTheGroupAtTheEndOfTheCurrentYear": "",
    "TheRemainingValueOfTheGroup": "",
    "TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear": "",
    "ID": 4,
    "xml_uuid": "9f4d2e6d-a3aa-4ace-8556-c4980e98f7b4"
  }
]',
  @tenantId int = 172,
  @userId int = null,
  @fromdate DateTime = '2024-01-01',        
  @todate DateTime = '2024-12-31'  
AS
BEGIN


DECLARE @temp TABLE
(
	GroupNo NVARCHAR(MAX),
	TheGroupValueAtEndOfPreviousYear DECIMAL(18,2),
	TheCostOfPreviousYearAdditions  DECIMAL(18,2),
	TheCostOfCurrentAdditions DECIMAL(18,2),
	[50PercentTotalCostAdditionsDuringCurAndPreYears]  DECIMAL(18,2),
	CompForAssetsNotQualifyDepreciationPreYear DECIMAL(18,2),
	CompForAssetsNotQualifyDepreciationCurYear DECIMAL(18,2),
	[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear] DECIMAL(18,2),
	TheRemainingValueOfTheGroup DECIMAL(18,2),
	DepreciationAmortizationRatioPercentage DECIMAL(18,2),
	DepreciationAmortizationValue DECIMAL(18,2),
	TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear DECIMAL(18,2),
	RepairAndImprovementCostForTheGroup DECIMAL(18,2),
	RepairAndImprovementExpensesExceeding4Percent DECIMAL(18,2),
	TheRemainingOfTheGroupAtTheEndOfTheCurrentYear DECIMAL(18,2)
	
)
INSERT INTO @temp (GroupNo, 
                    TheGroupValueAtEndOfPreviousYear, 
                    TheCostOfPreviousYearAdditions, 
                    TheCostOfCurrentAdditions, 
                    [50PercentTotalCostAdditionsDuringCurAndPreYears], 
                    CompForAssetsNotQualifyDepreciationPreYear, 
                    CompForAssetsNotQualifyDepreciationCurYear, 
                    [50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear], 
                    TheRemainingValueOfTheGroup, 
                    DepreciationAmortizationRatioPercentage, 
                    DepreciationAmortizationValue, 
                    TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear, 
                    RepairAndImprovementCostForTheGroup, 
                    RepairAndImprovementExpensesExceeding4Percent, 
                    TheRemainingOfTheGroupAtTheEndOfTheCurrentYear)
SELECT  GroupNo,
		ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TheGroupValueAtEndOfPreviousYear) AS DECIMAL(18, 2)), 0) ,
		ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TheCostOfPreviousYearAdditions) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TheCostOfCurrentAdditions) AS DECIMAL(18, 2)), 0) , 
		ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([50PercentTotalCostAdditionsDuringCurAndPreYears]) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(CompForAssetsNotQualifyDepreciationPreYear) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(CompForAssetsNotQualifyDepreciationCurYear) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal([50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear]) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TheRemainingValueOfTheGroup) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(DepreciationAmortizationRatioPercentage) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(DepreciationAmortizationValue) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(RepairAndImprovementCostForTheGroup) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(RepairAndImprovementExpensesExceeding4Percent) AS DECIMAL(18, 2)), 0) , 
        ISNULL(TRY_CAST(dbo.ConvertAndReplaceStringToDecimal(TheRemainingOfTheGroupAtTheEndOfTheCurrentYear) AS DECIMAL(18, 2)), 0) 
FROM OPENJSON(@json)
WITH (
    GroupNo NVARCHAR(MAX),
	TheGroupValueAtEndOfPreviousYear NVARCHAR(MAX),
	TheCostOfPreviousYearAdditions NVARCHAR(MAX),
	TheCostOfCurrentAdditions NVARCHAR(MAX),
	[50PercentTotalCostAdditionsDuringCurAndPreYears] NVARCHAR(MAX),
	CompForAssetsNotQualifyDepreciationPreYear NVARCHAR(MAX),
	CompForAssetsNotQualifyDepreciationCurYear NVARCHAR(MAX),
	[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear] NVARCHAR(MAX),
	TheRemainingValueOfTheGroup NVARCHAR(MAX),
	DepreciationAmortizationRatioPercentage NVARCHAR(MAX),
	DepreciationAmortizationValue NVARCHAR(MAX),
	TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear NVARCHAR(MAX),
	RepairAndImprovementCostForTheGroup NVARCHAR(MAX),
	RepairAndImprovementExpensesExceeding4Percent NVARCHAR(MAX),
	TheRemainingOfTheGroupAtTheEndOfTheCurrentYear NVARCHAR(MAX)
);

--computed values

--50 % of total cost of additions
UPDATE @temp SET [50PercentTotalCostAdditionsDuringCurAndPreYears]=(TheCostOfPreviousYearAdditions+TheCostOfCurrentAdditions)*(50.0 / 100.0);
--50 % of total value of compensation
UPDATE @temp SET [50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear]=(CompForAssetsNotQualifyDepreciationPreYear+CompForAssetsNotQualifyDepreciationCurYear)*(50.0 / 100.0);
--the remaining value of the group
UPDATE @temp SET  TheRemainingValueOfTheGroup =TheGroupValueAtEndOfPreviousYear+[50PercentTotalCostAdditionsDuringCurAndPreYears]-[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear];
--"Depreciation / amortization value"
UPDATE @temp SET DepreciationAmortizationValue=TheRemainingValueOfTheGroup*DepreciationAmortizationRatioPercentage;
--"The remaining value of the group at the end of the current year "
UPDATE @temp SET TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear=TheRemainingValueOfTheGroup-DepreciationAmortizationValue;
--"Repair and improvement expenses exceeding 4% "
UPDATE @temp SET RepairAndImprovementExpensesExceeding4Percent=CASE WHEN (RepairAndImprovementCostForTheGroup-(TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear*(4.0/100.0)))<0
															 THEN 0 ELSE (RepairAndImprovementCostForTheGroup-(TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear*(4.0/100.0)))
															 END;
--"The remaining of the group at the end of the current year "
UPDATE @temp SET TheRemainingOfTheGroupAtTheEndOfTheCurrentYear=TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear+RepairAndImprovementExpensesExceeding4Percent;


DECLARE @errormessage NVARCHAR(MAX);
set @errormessage = '';
--group no
IF EXISTS(SELECT 1 FROM @temp where GroupNo='' or GroupNo is null)
BEGIN
	SET @errormessage= @errormessage + '  Group No can not be Blank, ';
END

--The group value at the end of the previous year
IF EXISTS(SELECT 1 FROM @temp where TheGroupValueAtEndOfPreviousYear<0)
BEGIN
	SET @errormessage= @errormessage + ' The group value at the end of the previous year can be zero or positive, ';
END
--The cost of previous year additions
IF EXISTS(SELECT 1 FROM @temp where TheCostOfPreviousYearAdditions<0)
BEGIN
	SET @errormessage= @errormessage + ' The cost of previous year additions can be zero or positive, ';
END			
--	The cost of current additions
IF EXISTS(SELECT 1 FROM @temp where TheCostOfPreviousYearAdditions<0)
BEGIN
	SET @errormessage= @errormessage + ' The cost of current additions can be zero or positive, ';
END		
--Compensation for assets which do not qualify for depreciation during the previous year
IF EXISTS(SELECT 1 FROM @temp where CompForAssetsNotQualifyDepreciationPreYear<0)
BEGIN
	SET @errormessage= @errormessage + ' Compensation for assets which do not qualify for depreciation during the previous year can be zero or positive, ';
END		

--Compensation for assets which do not qualify for depreciation during the current year
IF EXISTS(SELECT 1 FROM @temp where CompForAssetsNotQualifyDepreciationCurYear<0)
BEGIN
	SET @errormessage= @errormessage + ' Compensation for assets which do not qualify for depreciation during the current year can be zero or positive, ';
END	
--Depreciation /amortization ratio (%)
IF EXISTS(SELECT 1 FROM @temp where ((DepreciationAmortizationRatioPercentage)*100)<0 or ((DepreciationAmortizationRatioPercentage)*100)>100)
BEGIN
	SET @errormessage= @errormessage + 'Depreciation /amortization ratio (%) should be between Zero and Hundred, ';
END	

--"Repair and improvement cost for the group"
IF EXISTS(SELECT 1 FROM @temp where RepairAndImprovementCostForTheGroup<0)
BEGIN
	SET @errormessage= @errormessage + ' Repair and improvement cost for the group can be zero or positive, ';
END	
IF @errormessage<>''
BEGIN   
	 SELECT ErrorStatus = 1, ErrorMessage = substring(@errormessage, 1, len(@errormessage) - 1);
END
ELSE
BEGIN

		--total amount
 		DECLARE @errormessage1 NVARCHAR(MAX);
		SET @errormessage1='';
		DECLARE @total DECIMAL(18,4);
		SELECT @total=SUM(RepairAndImprovementExpensesExceeding4Percent)FROM @temp
		IF EXISTS(SELECT 1 FROM @temp WHERE @total <>(SELECT DisplayInnerColumn FROM CIT_FormAggregateData WHERE TaxCode=10902
		and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate))
		BEGIN
			SET @errormessage1=@errormessage1+'  Schedule total does not match with the total in Form- Tax code #10902'
		END

	 if exists (select top 1 id from [dbo].[CIT_Schedule9]	
				where Tenantid = @tenantId 
				and isActive = 1 
				and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
				and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)) 

				BEGIN
					Delete from [dbo].[CIT_Schedule9] where Tenantid = @tenantId 
					and isActive = 1 
					and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
					and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)	 
				END
		
		INSERT INTO [dbo].[CIT_Schedule9]
           ([TenantId],
            [UniqueIdentifier],
			[GroupNo],
			[TheGroupValueAtEndOfPreviousYear],
			[TheCostOfPreviousYearAdditions],
			[TheCostOfCurrentAdditions],
			[50PercentTotalCostAdditionsDuringCurAndPreYears],
			[CompForAssetsNotQualifyDepreciationPreYear],
			[CompForAssetsNotQualifyDepreciationCurYear],
			[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear],
			[TheRemainingValueOfTheGroup],
			[DepreciationAmortizationRatioPercentage],
			[DepreciationAmortizationValue],
			[TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear],
			[RepairAndImprovementCostForTheGroup],
			[RepairAndImprovementExpensesExceeding4Percent],
			[TheRemainingOfTheGroupAtTheEndOfTheCurrentYear]
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
		GroupNo,
		TheGroupValueAtEndOfPreviousYear,
		TheCostOfPreviousYearAdditions,
		TheCostOfCurrentAdditions,
		[50PercentTotalCostAdditionsDuringCurAndPreYears],
		CompForAssetsNotQualifyDepreciationPreYear,
		CompForAssetsNotQualifyDepreciationCurYear,
		[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear],
		TheRemainingValueOfTheGroup,
		((DepreciationAmortizationRatioPercentage)*100),
		DepreciationAmortizationValue,
		TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear,
		RepairAndImprovementCostForTheGroup,
		RepairAndImprovementExpensesExceeding4Percent,
		TheRemainingOfTheGroupAtTheEndOfTheCurrentYear,
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
