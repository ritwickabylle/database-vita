SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[Insert_ManualEntries]
(
	@json NVARCHAR(MAX)='[
[{"uid":0,"taxCode":"10101","description":"Income from Operational Activity","isInnerColumn":true,"innerColumn":10,"isOuterColumn":true,"outerColumn":10}]	
	]',
	@tenantid INT =148,
	@fromdate DATETIME ='2023-01-01',
	@todate DATETIME='2023-12-31'
)
AS
BEGIN
 DELETE FROM CIT_ManualEntry WHERE taxcode IN (
        SELECT taxcode
        FROM OPENJSON(@json) WITH (taxcode NVARCHAR(100) '$.taxCode')
    )
INSERT INTO CIT_ManualEntry (UniqueIdentifier,tenantid,taxcode,description,innermanualentry,outermanualentry,FinancialStartDate,FinancialEndDate,IsActive,CreationTime)
SELECT 
	NEWID(),
	@tenantid,
    taxCode = taxCode,
    description = description,
    innerColumn =ISNULL(innerColumn,0), 
	outerColumn=ISNULL(outerColumn,0),
	@fromdate,
	@todate,
	1,
	GETDATE()
FROM OPENJSON(@json)                              
WITH (
    taxcode NVARCHAR(100) '$.taxCode',
    description NVARCHAR(100) '$.description',
    innerColumn NVARCHAR(100) '$.innerColumn',
	outerColumn NVARCHAR(100) '$.outerColumn'
);
 
END
GO
