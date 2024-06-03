SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule7Data]			-- exec [UpdateCIT_Schedule7Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N'{"uniqueidentifier_column":null,"sno.":0,"statement":"2","amount":"2"}'
AS
BEGIN

    UPDATE CIT_Schedule7
    SET
        [Statement] = JSON_VALUE(@json, '$."statement"'),
        [Amount] = JSON_VALUE(@json, '$."amount"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
