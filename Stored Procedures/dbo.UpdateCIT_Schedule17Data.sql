SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     PROCEDURE [dbo].[UpdateCIT_Schedule17Data]			-- exec [UpdateCIT_Schedule17Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule17
    SET
        [Accountname] = JSON_VALUE(@json, '$."account name"'),
		[Reasonfordeductionfromzakatbase] = JSON_VALUE(@json, '$."reason for deduction from zakat base"'),
		[Amount] = JSON_VALUE(@json, '$."amount"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
