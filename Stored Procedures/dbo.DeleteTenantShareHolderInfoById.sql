SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[DeleteTenantShareHolderInfoById]                  
(                  
@Id INT  
--,@TenantId INT
)                  
as                  
begin         
update TenantShareHolders set IsDeleted=1 where  Id=@Id
--update TenantShareHolders set IsDeleted=1 where TenantId=@TenantId and Id=@Id
end
GO
