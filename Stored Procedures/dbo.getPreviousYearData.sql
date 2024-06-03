SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[getPreviousYearData]   --exec getPreviousYearData 127
(@tenantId int = null)
as
begin
Select FinYear,ApportionmentSupplies from ApportionmentBaseData where [Type]='Previous' and [Date] = 'Total' and TenantId=@tenantId
end
GO
