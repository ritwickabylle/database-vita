SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule1Data]			-- exec [UpdateCIT_Schedule1Data] 148,157
    @tenantId INT = '159',
    @userId INT = '191',
    @json NVARCHAR(MAX) = N'{"uniqueidentifier_column":"9bd33ff2-35d6-45d4-ae06-a2a39e1f3d2a","details":"q","amount":"1"}'
AS
BEGIN

    UPDATE CIT_Schedule1
    SET
        [Details] = JSON_VALUE(@json, '$."details"'),
        [Amount] = JSON_VALUE(@json, '$."amount"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
