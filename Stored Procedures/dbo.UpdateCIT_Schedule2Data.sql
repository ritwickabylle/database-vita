SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule2Data]			-- exec [UpdateCIT_Schedule2Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N'
	{
  "uniqueidentifier_column": "C88E4708-8F55-45E1-BEB7-F127D2F20BA6",
  "id Type": "Passportttt",
  "id Number": "A1234567",
  "contracting Party": "ABC Company",
  "contract Date": "16-01-2023",
  "original Value": 10000,
  "amendments to original value": 500,
  "contract value after amendments": 10500,
  "total actual costs incurred to date": 8000,
  "contract estimated cost": 8500,
  "completion percentage": 60,
  "revenues according to the % of completion to date": 6000,
  "revenues according to the % of completion in prior years": 3500,
  "revenues according to the % of completion during the current year": "2500000"
}'
AS
BEGIN

    UPDATE CIT_Schedule2
    SET
        [IDType] = JSON_VALUE(@json, '$."id Type"'),
        [IDNumber] = JSON_VALUE(@json, '$."id Number"'),
        [ContractingParty] = JSON_VALUE(@json, '$."contracting Party"'),
        [ContractDate] = CAST(CONVERT(DATE, JSON_VALUE(@json, '$."contract Date"'), 105) AS DATETIME),
        [OriginalValue] = JSON_VALUE(@json, '$."original Value"'),
        [AmendmentsToOriginalValue] = JSON_VALUE(@json, '$."amendments to original value"'),
        [ContractValueAfterAmendments] = JSON_VALUE(@json, '$."contract value after amendments"'),
        [TotalActualCostsIncurred] = JSON_VALUE(@json, '$."total actual costs incurred to date"'),
        [ContractEstimatedCost] = JSON_VALUE(@json, '$."contract estimated cost"'),
        [CompletionPercentage] = JSON_VALUE(@json, '$."completion percentage"'),
        [RevenuesAccordingToCompletionToDate] = JSON_VALUE(@json, '$."revenues according to the % of completion to date"'),
        [RevenuesAccordingToCompletionPriorYear] = JSON_VALUE(@json, '$."revenues according to the % of completion in prior years"'),
        [RevenuesAccordingToCompletionDuringCurrentYear] = JSON_VALUE(@json, '$."revenues according to the % of completion during the current year"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
