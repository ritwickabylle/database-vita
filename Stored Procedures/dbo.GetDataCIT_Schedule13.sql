SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[GetDataCIT_Schedule13]    -- exec [GetDataCIT_Schedule13] 148, '1/1/2023', '12/31/2023'  
( @cols nvarchar(max) = N'[LenderName] as "Lender Name",
[LocalorForeign] as "Local / Foreign",
[BeginningOfPeriodBalance] as "Beginning Of Period Balance",
[AmountClearedFromTheLoanDuringTheCurrentYear] as "Amount Cleared From The Loan During The Current Year",
[AdditionsToTheLoanDuringTheYear] as "Additions To The Loan During The Year",
[EndOfPeriodBalance] as "End Of Period Balance",
[UtilizedInDeductedItem] as "Utilized In Deducted Item",
[DateOfLoansStart] as "Date Of Loans Start",
[DateOfLoanCleared] as "Date Of Loan Cleared",
[LoansAddedToZakatBaseComponents] as "Loans Added To Zakat Base Components"
',
  @tenantId INT =159,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'

 SELECT null as uniqueidentifier_column, 

 ''1'' as ''Lender Name'',
 ''0'' as ''Local / Foreign'',
 ''1'' as ''Beginning Of Period Balance'',
 ''0'' as ''Amount Cleared From The Loan During The Current Year'',
 ''1'' as ''Additions To The Loan During The Year'',
 ''0'' as ''End Of Period Balance'',
 ''1'' as ''Utilized In Deducted Item'',
  null as ''Date Of Loans Start'',
  null as ''Date Of Loan Cleared'',
 ''0'' as ''Loans Added To Zakat Base Components''

 union all

	SELECT   
	  [UniqueIdentifier] as uniqueidentifier_column, {statement}  
	  FROM [dbo].[CIT_Schedule13] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

  SELECT @query = REPLACE(@query,'{statement}',  @cols)            
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
