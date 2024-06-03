SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[UpdateFinancialYear]        
(        
@tenantid int = 159,        
@finyear nvarchar(100) = '2024-01-012024-12-31'        
)        
as        
begin        
   update FinancialYear set IsActive = 0 where TenantId=@tenantid        
   update FinancialYear set IsActive = 1 where     
   cast(FORMAT(cast (EffectiveFromDate as date), 'yyyy-MM-dd') as nvarchar) + cast(FORMAT(cast (EffectiveTillEndDate as date), 'yyyy-MM-dd') as nvarchar) = @finyear     
   and TenantId=@tenantid        
end
GO
