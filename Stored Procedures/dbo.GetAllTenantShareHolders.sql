SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[GetAllTenantShareHolders]                  
(                  
@Id INT            
)                  
as                  
begin                  
select *,ts.UniqueIdentifier as patunique from TenantShareHolders ts left join TenantShareHolderAddress tsa
on ts.Id = tsa.TenantShareHolderId where ts.tenantid=@id and ts.IsDeleted=0  
end
GO
