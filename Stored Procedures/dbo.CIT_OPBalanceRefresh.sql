SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           PROCEDURE [dbo].[CIT_OPBalanceRefresh]        --    EXEC CIT_OPBalanceRefresh '2024-01-01','2024-12-31',172
(
	@fromdate DATE,
	@todate DATE,
	@tenantid INT
)
AS
BEGIN
--Update for opbalance

--Updating with previous year clbalance 
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


END
GO
