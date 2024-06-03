SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROC [dbo].[Get_CITManualEntries]
(
	@tenantid INT,
	@fromdate datetime,
	@todate DATETIME
)
AS
BEGIN
	SELECT UniqueIdentifier,Taxcode,Description,InnerManualEntry,OuterManualEntry from CIT_ManualEntry
	WHERE tenantid=@tenantid and financialstartdate=@fromdate and FinancialEnddate=@todate
END
GO
