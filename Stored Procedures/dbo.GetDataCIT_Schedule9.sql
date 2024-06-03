SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        PROCEDURE [dbo].[GetDataCIT_Schedule9]    -- exec [GetDataCIT_Schedule7] 148, '1/1/2023', '12/31/2023'  
( @cols nvarchar(max) = N'[GroupNo] as "Group No.",
[TheGroupValueAtEndOfPreviousYear] as "The group value at the end of the previous year",
[TheCostOfPreviousYearAdditions] as "The cost of previous year additions",
[TheCostOfCurrentAdditions] as "The cost of current additions",
[50PercentTotalCostAdditionsDuringCurAndPreYears] as "50% of the total cost of additions during the current and previous years",
[CompForAssetsNotQualifyDepreciationPreYear] as "Compensation for assets which do not qualify for depreciation during the previous year",
[CompForAssetsNotQualifyDepreciationCurYear] as "Compensation for assets which do not qualify for depreciation during the current year",
[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear] as "50% of the total value of compensation for assets which do not qualify for depreciation during curre",
[TheRemainingValueOfTheGroup] as "The remaining value of the group",
[DepreciationAmortizationRatioPercentage] as "Depreciation / amortization ratio (%)",
[DepreciationAmortizationValue] as "Depreciation / amortization value",
[TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear] as "The remaining value of the group at the end of the current year",
[RepairAndImprovementCostForTheGroup] as "Repair and improvement cost for the group",
[RepairAndImprovementExpensesExceeding4Percent] as "Repair and improvement expenses exceeding 4%",
[TheRemainingOfTheGroupAtTheEndOfTheCurrentYear] as "The remaining of the group at the end of the current year"
',
  @tenantId INT = 159,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'

	SELECT   
	[UniqueIdentifier] as uniqueidentifier_column, 
	[GroupNo] as "Group No.",
	[TheGroupValueAtEndOfPreviousYear] as "The group value at the end of the previous year",
	[TheCostOfPreviousYearAdditions] as "The cost of previous year additions",
	[TheCostOfCurrentAdditions] as "The cost of current additions",
	[50PercentTotalCostAdditionsDuringCurAndPreYears] as "50% of the total cost of additions during the current and previous years",
	[CompForAssetsNotQualifyDepreciationPreYear] as "Compensation for assets which do not qualify for depreciation during the previous year",
	[CompForAssetsNotQualifyDepreciationCurYear] as "Compensation for assets which do not qualify for depreciation during the current year",
	[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear] as "50% of the total value of compensation for assets which do not qualify for depreciation during curre",
	[TheRemainingValueOfTheGroup] as "The remaining value of the group",
	[DepreciationAmortizationRatioPercentage] as "Depreciation / amortization ratio (%)",
	[DepreciationAmortizationValue] as "Depreciation / amortization value",
	[TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear] as "The remaining value of the group at the end of the current year",
	[RepairAndImprovementCostForTheGroup] as "Repair and improvement cost for the group",
	[RepairAndImprovementExpensesExceeding4Percent] as "Repair and improvement expenses exceeding 4%",
	[TheRemainingOfTheGroupAtTheEndOfTheCurrentYear] as "The remaining of the group at the end of the current year"

	  FROM [dbo].[CIT_Schedule9] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

  SELECT @query = REPLACE(@query,'{statement}',  @cols)            
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
