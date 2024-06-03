SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[DeleteFileMappings]   -- [DeleteFileMappings] 333, 148  
(@id INT,  
@tenantId int)  
AS  
BEGIN  
declare @type nvarchar(50);  
declare @updateId int;  
select @type = TransactionType from dbo.MappingConfiguration where id = @id and TenantId = @tenantId  
  
if ((select id from MappingConfiguration where MappingType = 'FieldMapping' and TransactionType = @type and TenantId = @tenantId and IsActive = 1) = @id)  
Begin  
 DELETE FROM dbo.MappingConfiguration WHERE id = @id  
 select top 1 @updateId = id from dbo.MappingConfiguration where MappingType = 'FieldMapping' and TransactionType = @type and TenantId = @tenantId and IsActive = 0 order by id desc  
 Update dbo.MappingConfiguration set IsActive = 1 WHERE id = @updateId and TenantId = @tenantId  
end  
else  
begin  
 DELETE FROM dbo.MappingConfiguration WHERE id = @id and TenantId = @tenantId 
end  
  
END
GO
