SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     PROCEDURE [dbo].[UpdateCIT_Schedule9Data]			-- exec [UpdateCIT_Schedule2Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule9
    SET
        [GroupNo] = JSON_VALUE(@json, '$."group No."'),
		[TheGroupValueAtEndOfPreviousYear] = JSON_VALUE(@json, '$."the group value at the end of the previous year"'),
		[TheCostOfPreviousYearAdditions] = JSON_VALUE(@json, '$."the cost of previous year additions"'),
		[TheCostOfCurrentAdditions] = JSON_VALUE(@json, '$."the cost of current additions"'),
		[50PercentTotalCostAdditionsDuringCurAndPreYears] = JSON_VALUE(@json, '$."50% of the total cost of additions during the current and previous years"'),
		[CompForAssetsNotQualifyDepreciationPreYear] = JSON_VALUE(@json, '$."compensation for assets which do not qualify for depreciation during the previous year"'),
		[CompForAssetsNotQualifyDepreciationCurYear] = JSON_VALUE(@json, '$."compensation for assets which do not qualify for depreciation during the current year"'),
		[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear] = JSON_VALUE(@json, '$."50% of the total value of compensation for assets which do not qualify for depreciation during curre"'),
		[TheRemainingValueOfTheGroup] = JSON_VALUE(@json, '$."the remaining value of the group"'),
		[DepreciationAmortizationRatioPercentage] = JSON_VALUE(@json, '$."depreciation \/ amortization ratio (%)"'),
		[DepreciationAmortizationValue] = JSON_VALUE(@json, '$."depreciation \/ amortization value"'),
		[TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear] = JSON_VALUE(@json, '$."the remaining value of the group at the end of the current year"'),
		[RepairAndImprovementCostForTheGroup] = JSON_VALUE(@json, '$."repair and improvement cost for the group"'),
		[RepairAndImprovementExpensesExceeding4Percent] = JSON_VALUE(@json, '$."repair and improvement expenses exceeding 4%"'),
		[TheRemainingOfTheGroupAtTheEndOfTheCurrentYear] = JSON_VALUE(@json, '$."the remaining of the group at the end of the current year"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
