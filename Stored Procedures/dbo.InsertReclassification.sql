SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[InsertReclassification]
(
	@json nvarchar(max)=N'
[
  {
    "id": 1,
    "entryNo": 1,
    "accountNo": "870000",
    "taxCode": "10101",
    "generalLedgerName": "Revenue Reversals - IFRS15",
    "preliminaryGLBalance": null,
    "debit": "",
    "isDebit": true,
    "credit": 0,
    "isCredit": false,
    "finalGLBalance": 0,
    "comments": "Comment 1"
  }
]
',
@tenantid int=148 ,
@fromdate DATETIME,
@todate DATETIME
)
as
begin
INSERT INTO TrialBalance_Reclassification (tenantid,UniqueIdentifier,entryNo,TAXMAP,GLName,PreGLBal,Debit,Credit,FinalGLBal,Comments,creationtime,isactive,FinancialStartDate,FinancialEndDate)
SELECT 
	@tenantid,
	newid(),
    entryNo = entryNo,
    taxCode = taxCode,
    generalLedgerName = generalLedgerName, 
	preliminaryGLBalance=ISNULL(preliminaryGLBalance,0),
	debit=ISNULL(debit,0),
	credit=ISNULL(credit,0),
	finalGLBalance=ISNULL(finalGLBalance,0),
	comments=comments,
	GETDATE(),
	1,
	@fromdate,
	@todate
FROM OPENJSON(@json)                              
WITH (
    entryNo NVARCHAR(100) '$.entryNo',
    taxCode NVARCHAR(100) '$.taxCode',
    generalLedgerName NVARCHAR(100) '$.generalLedgerName',
	preliminaryGLBalance NVARCHAR(100) '$.preliminaryGLBalance',
    debit NVARCHAR(100) '$.debit',
    credit NVARCHAR(100) '$.credit',
	finalGLBalance NVARCHAR(100) '$.finalGLBalance',
    comments NVARCHAR(100) '$.comments',
    credit NVARCHAR(100) '$.credit'
);
end
GO
