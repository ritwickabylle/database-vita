SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     PROCEDURE [dbo].[UpdateCIT_Schedule6Data]			-- exec [UpdateCIT_Schedule6Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule6
    SET
        [IDType] = JSON_VALUE(@json, '$."id Type"'),
        [IDNumber] = JSON_VALUE(@json, '$."id Number"'),
		[BeneficiaryName] = JSON_VALUE(@json, '$."beneficiary Name"'),
		[LocalorForeign] = JSON_VALUE(@json, '$."local \/ Foreign"'),
		[Country] = JSON_VALUE(@json, '$."country"'),
		[ServiceType] = JSON_VALUE(@json, '$."service Type"'),
		[Beginningoftheyearbalance] = JSON_VALUE(@json, '$."beginning of the year balance"'),
		[Chargedtotheaccounts] = JSON_VALUE(@json, '$."charged to the accounts"'),
		[Paidduringtheyear] = JSON_VALUE(@json, '$."paid during the year"'),
		[EndoftheyearBalance] = JSON_VALUE(@json, '$."end of the year Balance"'),


        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
