SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[UpdateSchedules]  --  EXEC UpdateSchedules '173','2023-01-01','2023-12-31'
(
	@tenantid INT,
	@fromdate DATETIME,
	@todate DATETIME
)
AS
BEGIN

--schedule1
DECLARE @schedule1bal DECIMAL(18,2);
SELECT @schedule1bal =ABS(SUM(cme.amount)) 
        FROM CIT_Schedule1 cme
        WHERE Details='Total'
		AND cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule1bal,
    ReferenceStatus = 'T',
	ReferenceStatusOuter =(CASE WHEN (abs(CFT.ClBalance)<> @schedule1bal) THEN 'TD' ELSE 'TS' END)
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule1 cme ON cft.taxcode = 10102
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10102'
	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

--schedule2
DECLARE @schedule2bal DECIMAL(18,2);
SELECT @schedule2bal =ABS(SUM(cme.TotalActualCostsIncurred)) 
        FROM CIT_Schedule2 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule2bal,
    ReferenceStatus = 'T',
	ReferenceStatusOuter =(CASE WHEN (abs(CFT.ClBalance)<> @schedule2bal) THEN 'TD' ELSE 'TS' END)
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule2 cme ON cft.taxcode = 10103
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10103'
	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;


--schedule2_1

DECLARE @schedule21bal DECIMAL(18,2);
SELECT @schedule21bal =ABS(SUM(cme.amount)) 
        FROM CIT_Schedule2_1 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance =@schedule21bal,
    ReferenceStatus = 'T',
	ReferenceStatusOuter =(CASE WHEN (abs(CFT.ClBalance)<> @schedule21bal) THEN 'TD' ELSE 'TS' END)
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule2_1 cme ON cft.taxcode = 10202
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10202'
	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

--schedule3

DECLARE @schedule3bal DECIMAL(18,2);
SELECT @schedule3bal =ABS(SUM(cme.Valueofworksexecuted)) 
        FROM CIT_Schedule3 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance =@schedule3bal,
    ReferenceStatus = 'T',
	ReferenceStatusOuter =(CASE WHEN (abs(CFT.ClBalance)<> @schedule3bal) THEN 'TD' ELSE 'TS' END)
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule3 cme ON cft.taxcode = 10501
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10501'
	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;



--schedule4
DECLARE @schedule4bal DECIMAL(18,2);
SELECT @schedule4bal =ABS(SUM(cme.ChargetotheAccounts)) 
        FROM CIT_Schedule4 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule4bal,
    ReferenceStatus = 'T',
	ReferenceStatusOuter =(CASE WHEN (abs(CFT.ClBalance)<> @schedule4bal) THEN 'TD' ELSE 'TS' END)
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule4 cme ON cft.taxcode = 10502
	AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10502'
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate;



--schedule5
DECLARE @schedule51bal DECIMAL(18,2);
SELECT @schedule51bal =ABS(SUM(cme.Provisionsmadeduringtheyear)) 
        FROM CIT_Schedule5 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance =@schedule51bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule5 cme ON cft.taxcode = 10508
     AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10508'
	AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate;


--schedule 5_2
DECLARE @schedule52bal DECIMAL(18,2);
SELECT @schedule52bal =ABS(SUM(cme.ProvisionsUtilizedDuringTheYear)) 
        FROM CIT_Schedule5 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance =@schedule52bal ,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule5 cme ON cft.taxcode = 10903
 	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10903'
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate;


--schedule5_3		
DECLARE @schedule53bal DECIMAL(18,2);
SELECT @schedule53bal =ABS(SUM(cme.Provisionsmadeduringtheyear)) 
        FROM CIT_Schedule5 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance =@schedule53bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule5 cme ON cft.taxcode = 10904
	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10904'
	AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate;

--schedule5_4
DECLARE @schedule54bal DECIMAL(18,2);
SELECT @schedule54bal =ABS(SUM(cme.ProvisionsBalanceAtBeginningOfPeriod)-SUM(ProvisionsUtilizedDuringTheYear)) 
        FROM CIT_Schedule5 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance =@schedule54bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule5 cme ON cft.taxcode = 11304
     AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='11304'
	AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate;


--schedule6
DECLARE @schedule6bal DECIMAL(18,2);
SELECT @schedule6bal =ABS(SUM(cme.EndoftheyearBalance)) 
        FROM CIT_Schedule6 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule6bal,
    ReferenceStatus = 'T',
	ReferenceStatusOuter =(CASE WHEN (abs(CFT.ClBalance)<> @schedule6bal) THEN 'TD' ELSE 'TS' END)
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule6 cme ON cft.taxcode = 10509
       AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='10509'
	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;


--schedule7
DECLARE @schedule7bal DECIMAL(18,2);
SELECT @schedule7bal =ABS(SUM(cme.Amount)) 
        FROM CIT_Schedule7 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance =@schedule7bal ,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule7 cme ON cft.taxcode = 10513
        AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='10513'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;


		
--schedule8
DECLARE @schedule8bal DECIMAL(18,2);
SELECT @schedule8bal =ABS(SUM(cme.Amount)) 
        FROM CIT_Schedule8 cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule8bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule8 cme ON cft.taxcode = 10901
     AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='10901'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

		--schedule11a
DECLARE @schedule11Abal DECIMAL(18,2);
SELECT @schedule11Abal =ABS(SUM(cme.LossDeductedDuringTheYear)) 
        FROM CIT_Schedule11_A cme
        WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule11Abal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule11_A cme ON cft.taxcode = 12103
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='12103'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

--schedule11B
DECLARE @schedule11Bbal DECIMAL(18,2);
SELECT @schedule11Bbal =ABS(SUM(cme.Amount)) 
        FROM CIT_Schedule11_B cme
        WHERE Description like 'Total adjusted accumulated losses deductible from zakat base in the return'
		AND cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

		print(@schedule11Bbal);
UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule11Bbal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule11_B cme ON cft.taxcode = 11404
        AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='11404'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

--schedule16
DECLARE @schedule16bal DECIMAL(18,2);
SELECT @schedule16bal =ABS(SUM(cme.Deductedfrombase)) 
        FROM CIT_Schedule16 cme
		WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule16bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule16 cme ON cft.taxcode = 11405
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='11405'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

--schedule15
DECLARE @schedule15bal DECIMAL(18,2);
SELECT @schedule15bal =ABS(SUM(cme.Amount)) 
        FROM CIT_Schedule15 cme
		WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule15bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule15 cme ON cft.taxcode = 11403
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
	AND  CFT.TaxCode='11403'
	AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

--schedule14
DECLARE @schedule14bal DECIMAL(18,2);
SELECT @schedule14bal =ABS(SUM(cme.Amount)) 
        FROM CIT_Schedule14 cme
		WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule14bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule14 cme ON cft.taxcode = 11309
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='11309'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

		--schedule17
DECLARE @schedule17bal DECIMAL(18,2);
SELECT @schedule17bal =ABS(SUM(cme.Amount)) 
        FROM CIT_Schedule17 cme
		WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule17bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule17 cme ON cft.taxcode = 11406
    AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='11406'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

				--schedule18
DECLARE @schedule18bal DECIMAL(18,2);
SELECT @schedule18bal =ABS(SUM(cme.Amount)) 
        FROM CIT_Schedule18 cme
		WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule18bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule18 cme ON cft.taxcode = 12240
        AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='12240'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

				--schedule9
DECLARE @schedule9bal DECIMAL(18,2);
SELECT @schedule9bal =ABS(SUM(cme.RepairAndImprovementExpensesExceeding4Percent)) 
        FROM CIT_Schedule9 cme
		WHERE cme.TenantId = @tenantId 
        AND cme.FinancialStartDate = @fromdate 
        AND cme.FinancialEndDate = @todate

UPDATE CIT_FormAggregateData
SET 
    ScheduleBalance = @schedule9bal,
    ReferenceStatus = 'S'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_Schedule9 cme ON cft.taxcode = 10902
       AND cft.TenantId = cme.tenantid
    AND cft.FinStartDate = cme.financialstartdate
    AND cft.FinEndDate = cme.financialenddate
WHERE cft.TenantId = @tenantid 
    AND cft.FinStartDate = @fromdate 
    AND cft.FinEndDate = @todate
		AND  CFT.TaxCode='10902'
			AND cme.financialstartdate=@fromdate
	AND cme.financialenddate=@todate
	AND cme.tenantid=@tenantid;

END
GO
