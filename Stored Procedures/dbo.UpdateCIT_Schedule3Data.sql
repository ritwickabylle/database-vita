SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule3Data]			-- exec [UpdateCIT_Schedule3Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule3
    SET
        [IDType] = JSON_VALUE(@json, '$."id Type"'),
        [IDNumber] = JSON_VALUE(@json, '$."id Number"'),
		[ContractorName] = JSON_VALUE(@json, '$."contractor Name"'),
		[Country] = JSON_VALUE(@json, '$."country"'),
		[Valueofworksexecuted] = JSON_VALUE(@json, '$."value of works executed in SAR"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
