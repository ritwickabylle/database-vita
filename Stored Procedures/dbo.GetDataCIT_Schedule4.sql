SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[GetDataCIT_Schedule4]    -- exec [GetDataCIT_Schedule4] 148, '1/1/2023', '12/31/2023'  
( @cols NVARCHAR(MAX) = N'
[IDType] as ''ID Type'',
[IDNumber] as ''ID Number'',
[BeneficiaryName] as ''Beneficiary Name'',
[LocalorForeign] as ''Local / Foreign'',
[Country] as ''Country'',
[BeginningoftheyearBalance] as ''Beginning of the year Balance'',
[ChargetotheAccounts] as ''Charged to the Accounts'',
[PaidAmount] as ''Paid Amount'',
[EndoftheyearBalance] as ''End of the year Balance''',
  @tenantId INT =159,  
  @fromdate DATETIME = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'

	SELECT   
	  [UniqueIdentifier] as uniqueidentifier_column, 
	  ROW_NUMBER() over (order by id ) as  [sno.],
	  [IDType] as "ID Type",
	  [IDNumber] as "ID Number",
	  [BeneficiaryName] as "Beneficiary Name",
	  [LocalorForeign] as "Local / Foreign",
	  [Country] as "Country",
	  [BeginningoftheyearBalance] as "Beginning of the year Balance",
	  [ChargetotheAccounts] as "Charged to the Accounts",
	  [PaidAmount] as "Paid Amount",
	  [EndoftheyearBalance] as "End of the year Balance"
	  FROM [dbo].[CIT_Schedule4] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

  --SELECT @query = REPLACE(@query,'{statement}',  @cols)            
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
