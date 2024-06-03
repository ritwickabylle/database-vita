SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     PROCEDURE [dbo].[UpdateCIT_Schedule4Data]			-- exec [UpdateCIT_Schedule4Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N'{
  "uniqueidentifier_column": "5a73d5b6-8669-4978-872d-3f665791e56f",
  "id Type": "1",
  "id Number": 1,
  "beneficiary Name": "1",
  "local/Foreign": "e",
  "country": "1",
  "beginning of the year Balance": 1,
  "charged to the Accounts": 1,
  "paid Amount": 1,
  "end of the year Balance": 1
}'
AS
BEGIN

    UPDATE CIT_Schedule4

    SET
		    [IDType] = JSON_VALUE(@json, '$."id Type"'),
			[IDNumber] = JSON_VALUE(@json, '$."id Number"'),
			[BeneficiaryName] = JSON_VALUE(@json, '$."beneficiary Name"'),
			[LocalorForeign] = JSON_VALUE(@json, '$."local \/ Foreign"'),
			[Country] = JSON_VALUE(@json, '$."country"'),
			[BeginningoftheyearBalance] = JSON_VALUE(@json, '$."beginning of the year Balance"'),
			[ChargetotheAccounts] = JSON_VALUE(@json, '$."charged to the Accounts"'),
			[PaidAmount] = JSON_VALUE(@json, '$."paid Amount"'),
			[EndoftheyearBalance] = JSON_VALUE(@json, '$."end of the year Balance"'),
		[LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
