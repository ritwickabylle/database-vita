SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[CIT_Reclassification]
(
	@fromdate DATETIME,
	@todate DATETIME,
	@tenantid INT
)
AS
BEGIN
	SELECT UniqueIdentifier,EntryNo,GLName,TAXMAP,PreGLBal,Debit,Credit,FinalGLBal,Comments  FROM TrialBalance_Reclassification where isActive = 1
	and Tenantid=@tenantid and FinancialStartDate=@fromdate and FinancialEndDate=@todate
END
GO
