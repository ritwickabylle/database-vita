SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create       PROCEDURE [dbo].[UpdateCIT_Schedule13Data]			-- exec [UpdateCIT_Schedule13Data] 148,157
    @tenantId INT,
    @userId INT,
    @json NVARCHAR(MAX) = N'{
  "uniqueidentifier_column": "dfea148f-528b-4370-bf30-8409b68f87a9",
  "sr.No": "2",
  "lender Name": "x",
  "local / Foreign": "z",
  "beginning Of Period Balance": "3",
  "amount Cleared From The Loan During The Current Year": "3",
  "additions To The Loan During The Year": "3",
  "end Of Period Balance": "3",
  "utilized In Deducted Item": "3",
  "date Of Loans Start": "2024-02-02T00:00:00",
  "date Of Loan Cleared": "2024-02-02T00:00:00",
  "loans Added To Zakat Base Components": "3"
}'
AS
BEGIN
select * from CIT_Schedule13 WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
    UPDATE CIT_Schedule13

    SET
		    [LenderName] = JSON_VALUE(@json, '$."lender Name"'),
			[LocalorForeign] = JSON_VALUE(@json, '$."local \/ Foreign"'),
			[BeginningOfPeriodBalance] = JSON_VALUE(@json, '$."beginning Of Period Balance"'),
			[AmountClearedFromTheLoanDuringTheCurrentYear] = JSON_VALUE(@json, '$."amount Cleared From The Loan During The Current Year"'),
			[AdditionsToTheLoanDuringTheYear] = JSON_VALUE(@json, '$."additions To The Loan During The Year"'),
			[EndOfPeriodBalance] = JSON_VALUE(@json, '$."end Of Period Balance"'),
			[UtilizedInDeductedItem] = JSON_VALUE(@json, '$."utilized In Deducted Item"'),
			[DateOfLoansStart] = JSON_VALUE(@json, '$."date Of Loans Start"'),
		[DateOfLoanCleared] = JSON_VALUE(@json, '$."date Of Loan Cleared"'),
        [LoansAddedToZakatBaseComponents] = JSON_VALUE(@json, '$."loans Added To Zakat Base Components"')
    WHERE
        [UniqueIdentifier] = JSON_VALUE(@json, '$."uniqueidentifier_column"') AND
        [tenantId] = @tenantId;
END

--select * from CIT_Schedule13
GO
