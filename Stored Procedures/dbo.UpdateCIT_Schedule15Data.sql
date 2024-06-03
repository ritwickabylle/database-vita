SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule15Data]			-- exec [UpdateCIT_Schedule15Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule15
    SET
        [Investmenttype] = JSON_VALUE(@json, '$."investment type"'),
        [TIN] = JSON_VALUE(@json, '$."tin"'),
		[Nameofentityinvestee] = JSON_VALUE(@json, '$."name of entity investee"'),
		[Amount] = JSON_VALUE(@json, '$."amount"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
