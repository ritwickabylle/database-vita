SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
create    PROCEDURE [dbo].[GetDataCIT_Schedule9_1]    -- exec [GetDataCIT_Schedule11_B] 148, '1/1/2023', '12/31/2023'  
( @cols nvarchar(max) =N'[Description] as ''Description'',[Amount] as ''Amount''',
  @tenantId INT =159,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'
	SELECT   
	  [UniqueIdentifier] as uniqueidentifier_column,
	  [DepreciationAsPerAccounts] as Depreciation,
	  [DeductableExpensesperTaxLaw] as Deductable,
	  [totalDifferencialAmount] as Total
	  FROM [dbo].[CIT_Schedule9_1] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

 --SELECT @query = REPLACE(@query,'{statement}',  @cols)            
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END

 --select * from CIT_Schedule10
GO
