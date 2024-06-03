SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[CIT_DeleteReclassification]
(
    @json NVARCHAR(MAX) = '[{"uniqueIdentifier":"C7037C3D-C26C-441C-9BEE-FD205B171E80","entryNo":2,"glName":"Capital1","taxmap":"101021","preGLBal":202000,"debit":2000098,"credit":-9877,"finalGLBal":500650,"comments":"changed 101021 data"}
	,{"uniqueIdentifier":"85FDA2F6-958E-42A6-93E8-D179231194AC","entryNo":2,"glName":"Capital1","taxmap":"101021","preGLBal":202000,"debit":2000098,"credit":-9877,"finalGLBal":500650,"comments":"changed 101021 data"}]',
    @tenantid INT = NULL,
	@fromdate DATETIME,
	@todate DATETIME
)
AS
BEGIN
    DECLARE @temp TABLE
    (
        Entry NVARCHAR(100)
    );

    INSERT INTO @temp (Entry)
    SELECT entryNo
    FROM OPENJSON(@json)
    WITH (
        entryNo NVARCHAR(100) '$.entryNo'
    );

    DELETE FROM TrialBalance_Reclassification WHERE EntryNo IN (SELECT Entry FROM @temp) and 
	tenantid=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate
END;
GO
