SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    Procedure [dbo].[GetTenantpartnerinfoById]                
(                
@Id INT          
)                
as                
begin                
select *,ts.UniqueIdentifier as patunique from TenantShareHolders ts where tenantid=@id and IsDeleted=0
end
GO
