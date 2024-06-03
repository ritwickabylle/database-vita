SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   Proc [dbo].[GetFormAggregateData](
	@taxcode int=11303,
	@tenantId int = 159,
	@fromdate DateTime = '2023-01-01',        
	@todate DateTime = '2023-12-31'
)
As
Begin

	SELECT DisplayInnerColumn as amount FROM CIT_FormAggregateData where TaxCode = @taxcode and tenantid=@tenantId and FinStartDate=@fromdate and FinEndDate=@todate;
end


GO
