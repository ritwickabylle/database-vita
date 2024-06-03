SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[GetDataCIT_Schedule16]    -- exec [GetDataCIT_Schedule16] 148, '1/1/2023', '12/31/2023'  
( @cols NVARCHAR(MAX) =N'[Statement] as "Statement",
[Beginningbalancefromfinancialstatements] as "Beginning balance from financial statements",
[Additions] as "Additions",
[Disposalscost] as "Disposals cost",
[Endbalancefromfinancialstatements] as "End balance from financial statements",
[TotalSales] as "Total Sales",
[Totaladvancepaymentsreceivedfromcustomers] as "Total advance payments received from customers",
[Percentage] as "Percentage",
[Deductedfrombase] as "Deducted from base"
',
  @tenantId INT =172,  
  @fromdate DATETIME = '1/1/2024',          
  @todate DateTime = '12/31/2024'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'

	SELECT   
	  [UniqueIdentifier] as uniqueidentifier_column, 
	  ROW_NUMBER() over (order by id ) as  [sno.],
	  [Statement] as "Statement",
	  [Beginningbalancefromfinancialstatements] as "Beginning balance from financial statements",
	  [Additions] as "Additions",
	  [Disposalscost] as "Disposals cost",
	  [Endbalancefromfinancialstatements] as "End balance from financial statements",
	  [TotalSales] as "Total Sales",
	  [Totaladvancepaymentsreceivedfromcustomers] as "Total advance payments received from customers",
	  [Percentage] as "Percentage",
	  [Deductedfrombase] as "Deducted from base"
	  FROM [dbo].[CIT_Schedule16] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

  --SELECT @query = REPLACE(@query,'{statement}',  @cols)            
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
