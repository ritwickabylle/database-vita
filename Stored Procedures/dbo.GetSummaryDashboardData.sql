SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[GetSummaryDashboardData]
AS
BEGIN
    WITH DummyDataCTE AS (
        SELECT 
            tenantid = ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
            Description = 'Description ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)),
            Name = 'Name ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)),
            Additionaldata1 = 'Additional Data 1',
            Additionaldata2 = 'Additional Data 2',
            isactive = 1
        FROM sys.objects 
    )
    SELECT 
        tenantid,
        Description,
        Name,
        Additionaldata1,
        Additionaldata2,
        isactive
    FROM DummyDataCTE
    WHERE tenantid <= 5 FOR JSON AUTO;
END;
GO
