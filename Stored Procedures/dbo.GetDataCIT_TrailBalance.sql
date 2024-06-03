SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        PROCEDURE [dbo].[GetDataCIT_TrailBalance]    -- exec [GetDataCIT_TrailBalance] '', 148, '2023-01-01', '2023-12-31'      
( @cols nvarchar(max),    
  @tenantId int,      
  @fromdate DateTime = '2023-01-01',              
  @todate DateTime = '2023-12-31'  )      
AS      
BEGIN      
DECLARE @query nvarchar(max)      
set @query = N'    
 SELECT       
   [UniqueIdentifier] as uniqueidentifier_column,{statement}  
   FROM [dbo].[CIT_TrialBalanceTransactions] where isActive = 1 and Tenantid = @tenantId       
   and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)          
   and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'      
    
  SELECT @query = REPLACE(@query,'{statement}',  @cols)                
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;    
    
END
GO
