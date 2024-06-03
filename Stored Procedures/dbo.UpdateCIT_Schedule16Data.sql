SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[UpdateCIT_Schedule16Data]			-- exec [UpdateCIT_Schedule16Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N''
AS
BEGIN

    UPDATE CIT_Schedule16
    SET
        [Statement] = JSON_VALUE(@json, '$."statement"'),
		[Beginningbalancefromfinancialstatements] = JSON_VALUE(@json, '$."beginning balance from financial statements"'),
		[Additions] = JSON_VALUE(@json, '$."additions"'),
		[Disposalscost] = JSON_VALUE(@json, '$."disposals cost"'),
		[Endbalancefromfinancialstatements] = JSON_VALUE(@json, '$."end balance from financial statements"'),
		[TotalSales] = JSON_VALUE(@json, '$."total Sales"'),
		[Totaladvancepaymentsreceivedfromcustomers] = JSON_VALUE(@json, '$."total advance payments received from customers"'),
		[Percentage] = JSON_VALUE(@json, '$."percentage"'),
		[Deductedfrombase] = JSON_VALUE(@json, '$."deducted from base"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
