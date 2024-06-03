SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE      PROCEDURE [dbo].[GetDataCIT_Schedule2]    -- exec [GetDataCIT_Schedule2] 148, '1/1/2023', '12/31/2023'  
( @cols nvarchar(max) = N'[IDType] as ''ID Type'',[IDNumber] as ''ID Number'',[ContractingParty] as ''Contracting Party'',[ContractDate] as ''Contract Date'',[OriginalValue] as ''Original Value'',[AmendmentsToOriginalValue] as ''Amendments to original value'',[ContractValueAfterAmendments] as ''Contract value after amendments'',[TotalActualCostsIncurred] as ''Total actual costs incurred to date'',[ContractEstimatedCost] as ''Contract estimated cost'',[CompletionPercentage] as ''Completion percentage'',[RevenuesAccordingToCompletionToDate] as ''Revenues according to the % of completion to date'',[RevenuesAccordingToCompletionPriorYear] as ''Revenues according to the % of completion in prior years'',[RevenuesAccordingToCompletionDuringCurrentYear] as ''Revenues according to the % of completion during the current year''',
  @tenantId int = 148 ,
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'
	SELECT   
	  [UniqueIdentifier] as uniqueidentifier_column, ROW_NUMBER() over (order by id ) as  [sno.],
	  [IDType] as ''ID Type'',
	  [IDNumber] as ''ID Number'',
	  [ContractingParty] as ''Contracting Party'',
	  FORMAT([ContractDate], ''dd-MM-yyyy'') AS ''Contract Date'',
	  [OriginalValue] as ''Original Value'',
	  [AmendmentsToOriginalValue] as ''Amendments to original value'',
	  [ContractValueAfterAmendments] as ''Contract value after amendments'',
	  [TotalActualCostsIncurred] as ''Total actual costs incurred to date'',
	  [ContractEstimatedCost] as ''Contract estimated cost'',
	  [CompletionPercentage] as ''Completion percentage'',
	  [RevenuesAccordingToCompletionToDate] as ''Revenues according to the % of completion to date'',
	  [RevenuesAccordingToCompletionPriorYear] as ''Revenues according to the % of completion in prior years'',
	  [RevenuesAccordingToCompletionDuringCurrentYear] as ''Revenues according to the % of completion during the current year''
	  FROM [dbo].[CIT_Schedule2] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

  SELECT @query = REPLACE(@query,'{statement}',  @cols)
  PRINT @query
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
