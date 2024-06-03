SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     PROCEDURE [dbo].[GetDataCIT_Schedule15]    -- exec [GetDataCIT_Schedule15] 148, '1/1/2023', '12/31/2023'
(@cols nvarchar(max) =N'[Investmenttype] as ''Investment type'',
[TIN] as ''TIN'',
[Nameofentityinvestee] as ''Name of entity investee'',
[Amount] as ''Amount''',
@tenantId INT =159,
  @fromdate DateTime = '1/1/2023',        
  @todate DateTime = '12/31/2023'  )
AS
BEGIN
  DECLARE @query nvarchar(max)     
    
  SET @query = N'
 
	SELECT     
   [UniqueIdentifier] as uniqueidentifier_column,
   ROW_NUMBER() over (order by id ) as  [Sno.],
   [Investmenttype] as "Investment type",  
   [TIN] as "TIN",
   [Nameofentityinvestee] as "Name of entity investee",
   [Amount] as "Amount"
   FROM [dbo].[CIT_Schedule15] where isActive = 1 and Tenantid = @tenantId     
   and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)        
   and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'    
  
  --SELECT @query = REPLACE(@query,'{statement}',  @cols)              
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;  

END
GO
