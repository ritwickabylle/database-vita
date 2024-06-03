SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     PROCEDURE [dbo].[UpdateCIT_Schedule8Data]			-- exec [UpdateCIT_Schedule2Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule8
    SET
        [LineNo] = JSON_VALUE(@json, '$."line No"'),
		[Description] = JSON_VALUE(@json, '$."description"'),
        [AmendType] = JSON_VALUE(@json, '$."amend type"'),
        [Amount] = JSON_VALUE(@json, '$."amount"'),
        [ZakatShare] = JSON_VALUE(@json, '$."zakat Share"'),
        [TaxShare] = JSON_VALUE(@json, '$."tax Share"'),
        [TaxMap] = JSON_VALUE(@json, '$."tax Map"'),
        [TotalValueOfTaxMap] = JSON_VALUE(@json, '$."total Value of Tax Map"'),
        [Reference] = JSON_VALUE(@json, '$."reference"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
