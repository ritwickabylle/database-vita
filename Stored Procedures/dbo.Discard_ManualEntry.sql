SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[Discard_ManualEntry]
(
	@json NVARCHAR(MAX)='[{"uniqueIdentifier":"84B8E173-5365-4E78-BE8F-5F12C196FCED","taxcode":"10101","description":"Income","outerManualEntry":100000}]',
	@tenantid INT =148,
	@fromdate DATETIME='2023-01-01',
	@todate DATETIME='2023-12-31'
)
AS
BEGIN
	 DECLARE @temp TABLE
    (
        uuid NVARCHAR(100)
    );

    INSERT INTO @temp (uuid)
    SELECT uuid
    FROM OPENJSON(@json)
    WITH (
        uuid NVARCHAR(100) '$.uniqueIdentifier'
    );
	DELETE from CIT_ManualEntry Where Uniqueidentifier in(select uuid from @temp) and tenantid=@tenantid 
	and Financialstartdate=@fromdate and FinancialEnddate=@todate
END
GO
