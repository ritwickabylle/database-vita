SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[Insertintocitformtransactions]  --  EXEC Insertintocitformtransactions '172','2024-01-01','2024-12-31'
(
	@tenantid INT,
	@fromdate DATETIME,
	@todate DATETIME,
	@updateop BIT=0
)
AS
BEGIN

--DELETE Existing data
DELETE FROM CIT_FormTransactions WHERE tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate
--Inserting into 	CIT_FormTransactions
INSERT INTO CIT_FormTransactions(tenantid,uniqueidentifier,glcode,glname,isbs,finstartdate,finenddate,taxcode,opbalance,
clbalance,debit,credit,creationtime,isactive)
SELECT
	@tenantid,
	NEWID(),
    glt.GLCode,
	GLT.GLName,
	glm.ISBS,
	@fromdate,
	@todate,
    glt.taxcode,
	ISNULL(ctbt.OpBalance,0),
    ISNULL(ctbt.CIBalance,0),
	ISNULL(ctbt.Debit,0),
	ISNULL(ctbt.Credit,0),
	GETDATE(),
	1
FROM
	 CIT_GLTaxCodeMapping GLT
	Left JOIN CIT_TrialBalanceTransactions CTBT  ON GLT.GLCode=ctbt.GLCode and glt.TenantId=ctbt.tenantid 
	and glt.FinancialStartDate=ctbt.FinancialStartDate and glt.FinancialEndDate=ctbt.FinancialEndDate
	LEft join CIT_GLMaster glm on glm.GLCode=ctbt.GLCode and glt.FinancialEndDate=ctbt.FinancialEndDate
	and glm.FinancialStartDate=ctbt.FinancialStartDate 
WHERE ctbt.FinancialStartDate=@fromdate AND ctbt.FinancialEndDate=@todate 
and ctbt.tenantid=@tenantId and glt.financialstartdate=@fromdate and glt.financialenddate=@todate and glt.tenantid=@tenantid
and  glm.financialstartdate=@fromdate and glm.financialenddate=@todate and glm.tenantid=@tenantid

--updating data with reclassification


UPDATE CIT_FormTransactions
SET clbalance = ISNULL(ct.ClBalance,0)+ISNULL(tr.Debit,0)-ISNULL(tr.Credit,0) FROM CIT_FormTransactions ct
INNER JOIN TrialBalance_Reclassification tr ON  ct.glname = tr.glname and ct.taxcode=tr.TAXMAP
WHERE ct.tenantid =@tenantid and ct.finstartdate =@fromdate and ct.finenddate =@todate
AND tr.tenantid =@tenantid
and tr.FinancialStartDate =@fromdate and tr.FinancialEndDate =@todate


--DELETE existing data
DELETE FROM CIT_FormAggregateData WHERE tenantid=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate

--Insert into CIT_FormAggregateData
--displayinneramount-clbalance
--displayouteramout -opbalance
INSERT INTO CIT_FormAggregateData(tenantid,uniqueidentifier,taxcode,finstartdate,finenddate,OpBalance,credit,debit,clbalance,IsActive,CreationTime,
DisplayInnerColumn,DisplayOuterColumn,ReferenceStatus,ScheduleNo)
SELECT cft.tenantid,newid(),cft.taxcode,@fromdate,@todate,sum(ISNULL(cft.opbalance,0)),sum(ISNULL(cft.credit,0)),sum(ISNULL(cft.debit,0)),sum(ISNULL(cft.clbalance,0)),1,GETDATE(),
sum(ISNULL(cft.clbalance,0)),sum(ISNULL(cft.OpBalance,0)),'T',cgcm.scheduleno from CIT_GLTaxCodeMaster cgcm
LEFT JOIN CIT_FormTransactions cft ON cgcm.TaxCode = cft.TaxCode AND  cft.tenantid=@tenantid 
and cft.FinStartDate=@fromdate and cft.FinEndDate=@todate  
WHERE cft.tenantid=@tenantid and FinStartDate=@fromdate AND FinEndDate=@todate 
group by cft.taxcode,cft.tenantid,cgcm.ScheduleNo



--Inserting with zeroes
INSERT INTO CIT_FormAggregateData (tenantid, UniqueIdentifier, FinStartDate, FinEndDate, taxcode,DEBIT,Credit, ClBalance, OpBalance,
CreationTime,IsActive,DisplayInnerColumn,DisplayOuterColumn,ScheduleNo)
SELECT @tenantid, NEWID(), @fromdate, @todate, cgcm.TaxCode,0,0, 0, 0,GETDATE(),1,0,0,cgcm.ScheduleNo
FROM CIT_GLTaxCodeMaster cgcm
LEFT JOIN CIT_FormTransactions cft ON cgcm.TaxCode = cft.TaxCode AND  cft.tenantid=@tenantid 
and cft.FinStartDate=@fromdate and cft.FinEndDate=@todate  
WHERE cft.TaxCode IS NULL
ORDER BY TaxCode 


EXEC UpdateSchedules @tenantid,@fromdate,@todate

Update CIT_FormAggregateData
SET 
DisplayInnerColumn=ScheduleBalance
from CIT_FormAggregateData 
WHERE ReferenceStatus='S' and TenantId=@tenantid and FinStartDate=@fromdate and FinEndDate=@todate

--select * from CIT_FormAggregateData where TaxCode=10513


--and cs.taxcode=cft.taxcode



--execute CIT_OPBalanceRefresh sp for updating op balance with the clbalance of previous financial year when op balance is not there in this finanial year
IF @updateop=1
BEGIN
 EXEC CIT_OPBalanceRefresh @fromdate,@todate,@tenantid
END

--Updating with Manual Entry data
--displayinneramount-clbalance  
--displayouteramout -opbalance
UPDATE cft
SET FormData =CASE WHEN cme.Taxcode  like '13%'  then cme.OuterManualEntry 
			ELSE cme.InnerManualEntry END,
    DisplayInnerColumn =CASE WHEN cme.Taxcode  like '13%'  then cme.OuterManualEntry 
			ELSE cme.InnerManualEntry END,
	formdata_oc = CASE WHEN cme.Taxcode  LIKE '13%'  then cme.InnerManualEntry 
		ELSE cme.OuterManualEntry END,
    DisplayOuterColumn =CASE WHEN cme.Taxcode  LIKE '13%' then cme.InnerManualEntry 
		ELSE cme.OuterManualEntry END,
	ReferenceStatus='M'
FROM CIT_FormAggregateData cft
INNER JOIN CIT_ManualEntry cme ON cft.taxcode = cme.taxcode
AND cft.TenantId = @tenantid
    AND cft.FinStartDate = @fromdate
    AND cft.FinEndDate = @todate
WHERE cft.TenantId=@tenantid and cft. FinStartDate=@fromdate and cft.FinEndDate=@todate
and cme.TenantId=@tenantid and cme.FinancialStartDate=@fromdate and cme.FinancialEndDate=@todate


--UPDATE cft
--SET formdata_oc = CASE WHEN cme.Taxcode  LIKE '13%'  then cme.InnerManualEntry 
--	ELSE cme.OuterManualEntry END,
--    DisplayOuterColumn =CASE WHEN cme.Taxcode  LIKE '13%' then cme.InnerManualEntry 
--	ELSE cme.OuterManualEntry END,
--	REferencestatusouter='M'
--FROM CIT_FormAggregateData cft
--INNER JOIN CIT_ManualEntry cme ON cft.taxcode = cme.taxcode
--AND cft.TenantId = @tenantid
--    AND cft.FinStartDate = @fromdate
--    AND cft.FinEndDate = @todate
--WHERE cft.TenantId=@tenantid and cft. FinStartDate=@fromdate and cft.FinEndDate=@todate
--and cme.TenantId=@tenantid and cme.FinancialStartDate=@fromdate and cme.FinancialEndDate=@todate


---updating for sign change issue
UPDATE CIT_FormAggregateData
SET DisplayInnerColumn = CASE 
                WHEN DisplayInnerColumn < 0 THEN ABS(DisplayInnerColumn)
                ELSE 0 - DisplayInnerColumn
            END
WHERE taxcode IN (
        SELECT taxcode 
        FROM CIT_GLTaxCodeMaster 
        WHERE ISBS IN ('I', 'L')
    ) and ReferenceStatus='T';

UPDATE CIT_FormAggregateData
SET DisplayInnerColumn = CASE 
                WHEN DisplayInnerColumn > 0 THEN ABS(DisplayInnerColumn)
                ELSE 0 - ABS(DisplayInnerColumn)
            END
WHERE taxcode IN (
        SELECT taxcode 
        FROM CIT_GLTaxCodeMaster 
        WHERE ISBS IN ('A', 'E')
    ) and ReferenceStatus='T';
	-----------------

END
GO
