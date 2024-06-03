SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_TrailBalanceData]			-- exec [UpdateCIT_Schedule2Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

  --  UPDATE CIT_TrailBalance
  --  SET
		--   [GLCode] = JSON_VALUE(@json, '$."gl Code"')
		--   ,[GLName] = JSON_VALUE(@json, '$."gl Name"')
		--   ,[GLGroup] = JSON_VALUE(@json, '$."gl Group"')
		--   ,[OPBalance] = JSON_VALUE(@json, '$."op Balance"')
		--   ,[OpBalanceType] = JSON_VALUE(@json, '$."op Balance Type"')
		--   ,[Debit] = JSON_VALUE(@json, '$."debit"')
		--   ,[Credit] = JSON_VALUE(@json, '$."credit"')
		--   ,[CLBalance] = JSON_VALUE(@json, '$."cl Balance"')
		--   ,[CLBalanceType] = JSON_VALUE(@json, '$."cl Balance Type"')
		--   ,[TaxCode] = JSON_VALUE(@json, '$."tax Code"')
		--   ,[ISBS] = JSON_VALUE(@json, '$."isbs"'),
		--[LastModificationTime] = GETDATE(),
  --      [LastModifierUserId] = @userId
  --  WHERE
  --      [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
  --      [tenantId] = @tenantId;
  print ''
END
GO
