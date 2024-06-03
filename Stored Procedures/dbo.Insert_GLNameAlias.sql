SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[Insert_GLNameAlias] 
(
    @json nvarchar(max) = N'[{
        "GLName": "Provision name",
        "GLNameAlias"": "Acc.deprec-Computer Hardware-LAN Server"
    }]',
    @tenantid int = 148,
    @fromdate DATETIME = '2023-01-01',
    @todate DATETIME = '2023-12-31'
)
AS 
BEGIN
    INSERT INTO GLNameAlias (
        UniqueIdentifier,
        TenantId,
        GLCode,
        GLNameAlias,
		GLName,
        Taxcode,
		Finstartdate,
		Finenddate,
        IsActive,
        CreationTime,
        IsDeleted
    )
    SELECT 
        NEWID(),
        @tenantid,
        f.GLCode,
        j.GLName,
        j.GLNameAlias,
        f.Taxcode,
		@fromdate,
		@todate,
        1,
        GETDATE(),
        0
    FROM OPENJSON(@json)
    WITH (
        GLName NVARCHAR(MAX) '$.GLName',
        GLNameAlias NVARCHAR(MAX) '$.GLNameAlias'
    ) AS j
    INNER JOIN CIT_TrialBalanceTransactions f ON j.GLNameAlias = f.GLName;
END
GO
