SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule5Data]			-- exec [UpdateCIT_Provisions] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule5
    SET
		   [ProvisionName] = JSON_VALUE(@json, '$."provision name"')
		   ,[ProvisionsBalanceAtBeginningOfPeriod] = JSON_VALUE(@json, '$."provisions balance at the beginning of the period"')
		   ,[ProvisionsMadeDuringTheYear] = JSON_VALUE(@json, '$."provisions made during the year"')
		   ,[ProvisionsUtilizedDuringTheYear] = JSON_VALUE(@json, '$."provisions utilized during the year"')
		   ,[Adjustments] = JSON_VALUE(@json, '$."adjustments"')
		   ,[ProvisionsBalanceAtTheEndOfThePeriod] = JSON_VALUE(@json, '$."provisions balance at the end of the period"'),
		[LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
