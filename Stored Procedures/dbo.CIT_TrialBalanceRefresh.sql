SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[CIT_TrialBalanceRefresh]        --    EXEC CIT_TrialBalanceRefresh '2024-01-01','2024-12-31',172
(
	@fromdate DATE,
	@todate DATE,
	@tenantid INT
)
AS
BEGIN
--Update for opbalance
select * from cit_formaggregatedata where tenantid=172 and taxcode in('13301','13303')

UPDATE A
SET A.OpBalance = 
    CASE 
        WHEN A.OpBalance IS NULL OR A.OpBalance = 0 
            THEN B.ClBalance
        ELSE A.OpBalance
    END,
    A.DisplayOuterColumn = 
    CASE 
        WHEN A.OpBalance IS NULL OR A.OpBalance = 0 
            THEN B.ClBalance
        ELSE A.OpBalance
    END
FROM CIT_FormAggregateData A
JOIN CIT_FormAggregateData B ON A.Taxcode = B.Taxcode
    AND B.FinStartDate = DATEADD(YEAR, -1, A.FinStartDate)
    AND B.FinEndDate = DATEADD(YEAR, -1, A.FinEndDate) 
    AND B.TenantId = A.TenantId
WHERE A.TenantId = @tenantid 
    AND A.FinStartDate = @fromdate 
    AND A.FinEndDate = @todate
	AND (A.OpBalance IS NULL OR A.OpBalance = 0)
	-- Insert new record if it not present in this financial year ,but present in previous Financial Year

	--INSERT INTO CIT_TrialBalanceTransactions (GLCode, GLName, ISBS, TaxCode, FinancialStartDate, FinancialEndDate,OpBalance,Debit,Credit,CIBalance,GLGroup)
	--SELECT 
	--	GLCode,
	--	GLName,
	--	ISBS,
	--	TaxCode,
	--	FinancialStartDate,
	--	FinancialEndDate,
	--	OpBalance,
	--	Debit,
	--	Credit,
	--	CIBalance,
	--	GLGroup
	--FROM CIT_TrialBalanceTransactions 
	--WHERE 
	--	TenantId = @tenantid
	--	AND FinancialStartDate >= DATEADD(YEAR, -1, @fromdate)
	--	AND FinancialStartDate >= DATEADD(YEAR, -1, @todate)
	--	--AND ISBS='BS'
	--	AND NOT EXISTS (
	--		SELECT 1
	--		FROM CIT_TrialBalanceTransactions t
	--		WHERE t.TaxCode = CIT_TrialBalanceTransactions.TaxCode
	--		  AND t.FinancialStartDate = @fromdate
	--		  AND t.FinancialEndDate = @todate
	--		  AND t.TenantId = @tenantid
	--	);
END
GO
