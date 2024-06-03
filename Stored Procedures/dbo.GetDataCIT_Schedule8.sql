SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        PROCEDURE [dbo].[GetDataCIT_Schedule8]    -- exec [GetDataCIT_Schedule8] 148, '1/1/2023', '12/31/2023'  
( @cols nvarchar(max) = N'[LineNo] as ''Line No'',Description as ''Description'',AmendType as ''Amend type'',Amount as ''Amount'',ZakatShare as ''Zakat Share'',TaxShare as ''Tax Share'',TaxMap as ''Tax Map'',TotalValueOfTaxMap as ''Total Value of Tax Map'',Reference as ''Reference''',
  @tenantId int =159,  
  @fromdate DateTime = '1/1/2023',          
  @todate DateTime = '12/31/2023'  )  
AS  
BEGIN  
DECLARE @query nvarchar(max)   
  
set @query = N'

	SELECT   
	  [UniqueIdentifier] as uniqueidentifier_column,
	   ROW_NUMBER() over (order by id ) as  [sno.],
	   Description as ''Description'',
	   AmendType as ''Amend type'',
	   Amount as ''Amount'',
	   ZakatShare as ''Zakat Share'',
	   TaxShare as ''Tax Share'',
	   TaxMap as ''Tax Map'',
	   TotalValueOfTaxMap as ''Total Value of Tax Map'',
	   Reference as ''Reference''
	  FROM [dbo].[CIT_Schedule8] where isActive = 1 and Tenantid = @tenantId   
	  and TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)      
	  and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE)'  

  --SELECT @query = REPLACE(@query,'{statement}',  @cols)            
  EXEC sp_executesql @query , N'@fromDate datetime, @toDate datetime, @tenantId int', @fromdate, @todate, @tenantId;

END
GO
