SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[GetTenantShareHolderInfoById]                  
(                  
@Id INT            
)                  
as                  
begin                  
select *,ts.UniqueIdentifier as patunique from TenantShareHolders ts left join TenantShareHolderAddress tsa
on ts.Id = tsa.TenantShareHolderId where ts.id=@id and ts.IsDeleted=0  
end
GO
