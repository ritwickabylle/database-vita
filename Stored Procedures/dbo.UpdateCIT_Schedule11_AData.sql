SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE     PROCEDURE [dbo].[UpdateCIT_Schedule11_AData]			-- exec [UpdateCIT_Schedule10Data] 148,157
    @tenantId INT =143,
    @userId INT=169,
    @json NVARCHAR(MAX) = N'{"uniqueidentifier_column":"654c673f-8f69-4b8a-9f56-604d79ed5da2","line item":"qwwe","adjusted carried forward CIT losses":"1","adjusted declared net profit":"1","loss deducted during the year":"1","end of year Balance":"1"}'
AS
BEGIN

    UPDATE CIT_Schedule11_A
    SET
        [LineItem] = JSON_VALUE(@json, '$."line item"'),
        [AdjustedCarriedForwardCITLosses] = JSON_VALUE(@json, '$."adjusted carried forward CIT losses"'),
        [AdjustedDeclaredNetProfit] = JSON_VALUE(@json, '$."adjusted declared net profit"'),
        [LossDeductedDuringTheYear] = JSON_VALUE(@json, '$."loss deducted during the year"'),
        [EndOfYearBalance] = JSON_VALUE(@json, '$."end of year Balance"'),
        [LastModificationTime] = GETDATE(),
        [LastModifierUserId] = @userId
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END
GO
