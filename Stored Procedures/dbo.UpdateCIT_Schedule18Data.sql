SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule18Data]			-- exec [UpdateCIT_Schedule18Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule18
    SET
        [ReceiptNumber] = JSON_VALUE(@json, '$."receipt No."'),
		[Type] = JSON_VALUE(@json, '$."type"'),
		[Date] = JSON_VALUE(@json, '$."date"'),
		[Amount] = JSON_VALUE(@json, '$."amount"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
