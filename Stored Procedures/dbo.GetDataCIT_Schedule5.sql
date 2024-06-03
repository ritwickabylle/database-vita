SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        PROCEDURE [dbo].[GetDataCIT_Schedule5]    -- exec [GetDataCIT_Schedule5] 148, '1/1/2023', '12/31/2023'  
( @cols NVARCHAR(MAX) = N'[ProvisionName] as "Provision name",
[ProvisionsBalanceAtBeginningOfPeriod] as "Provisions balance at the beginning of the period",
[ProvisionsMadeDuringTheYear] as "Provisions made during the year",
[ProvisionsUtilizedDuringTheYear] as "Provisions utilized during the year",
[Adjustments] as "Adjustments",
[ProvisionsBalanceAtTheEndOfThePeriod] as "Provisions balance at the end of the period"',
  @tenantId INT = 159,  
  @fromdate DATETIME = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'
 SELECT     
   [UniqueIdentifier] as uniqueidentifier_column, 
   ROW_NUMBER() over (order by id ) as  [sno.],
   [ProvisionName] as "Provision name",
[ProvisionsBalanceAtBeginningOfPeriod] as "Provisions balance at the beginning of the period",
[ProvisionsMadeDuringTheYear] as "Provisions made during the year",
[ProvisionsUtilizedDuringTheYear] as "Provisions utilized during the year",
[Adjustments] as "Adjustments",
[ProvisionsBalanceAtTheEndOfThePeriod] as "Provisions balance at the end of the period"
   FROM [dbo].[CIT_Schedule5] where isActive = 1 and Tenantid = @tenantId     
   and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)        
   and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'    
  
  --SELECT @query = REPLACE(@query,'{statement}',  @cols)              
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
