SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE      PROCEDURE [dbo].[GetDataCIT_Schedule1]    -- exec [GetDataCIT_Schedule1] 148, '1/1/2023', '12/31/2023'  
(@cols nvarchar(max) = N'[Details] as ''Details'',[Amount] as ''Amount''',   
@tenantId int = 159,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN   
  
  DECLARE @query nvarchar(max)    
      
set @query = N' 

 SELECT       
   [UniqueIdentifier] as uniqueidentifier_column,
   [Details] as Details,
   [Amount] as Amount
   FROM [dbo].[CIT_Schedule1] where isActive = 1 and Tenantid = @tenantId       
   and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)          
   and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  
    
  SELECT @query = REPLACE(@query,'{statement}',  @cols)  
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;    
  
END
GO
