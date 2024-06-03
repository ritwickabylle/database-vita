SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[GetDataCIT_Schedule14]    -- exec [GetDataCIT_Schedule14] 148, '1/1/2023', '12/31/2023'    
( @cols NVARCHAR(MAX) =N'',  
  @tenantId INT =148,    
  @fromdate DATETIME = '1/1/2023',            
  @todate DateTime = '12/31/2023'  )    
AS    
BEGIN    
DECLARE @query nvarchar(max)     
    
set @query = N'

 SELECT     
   [UniqueIdentifier] as uniqueidentifier_column,
   ROW_NUMBER() over (order by id ) as  [sno.],
   [Description] as "Description",
   [Amount] as "Amount"
   FROM [dbo].[CIT_Schedule14] where isActive = 1 and Tenantid = @tenantId     
   and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)        
   and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'    
  
  --SELECT @query = REPLACE(@query,'{statement}',  @cols)              
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;  
  
END
GO
