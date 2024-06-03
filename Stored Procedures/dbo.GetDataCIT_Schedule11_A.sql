SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE        PROCEDURE [dbo].[GetDataCIT_Schedule11_A]    -- exec [GetDataCIT_Schedule11_A] 148, '1/1/2023', '12/31/2023'  
( @cols nvarchar(max) = '',
  @tenantId INT = 148,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'

	SELECT   
	  [UniqueIdentifier] as uniqueidentifier_column,  ROW_NUMBER() over (order by id ) as  [Line Item],
	  [AdjustedCarriedForwardCITLosses] as "Adjusted carried forward CIT losses",
      [AdjustedDeclaredNetProfit] as "Adjusted declared net profit",
      [LossDeductedDuringTheYear] as "Loss deducted during the year",
      [EndOfYearBalance] as "End of year Balance"
	  FROM [dbo].[CIT_Schedule11_A] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

  --SELECT @query = REPLACE(@query,'{statement}',  @cols)            
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
