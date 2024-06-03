SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create      PROCEDURE [dbo].[ActivateFileMapping]  --exec ActivateFileMapping 173, 148  
(@id INT,  
@tenantId int)  
AS  
BEGIN  
declare @type nvarchar(50);  
  
Update dbo.MappingConfiguration set IsActive = 1 WHERE id = @id and TenantId = @tenantId  
  
select @type = TransactionType from dbo.MappingConfiguration where id = @id and TenantId = @tenantId  
  
Update dbo.MappingConfiguration set IsActive = 0 Where id <> @id and MappingType = 'FieldMapping' and TransactionType = @type  and TenantId = @tenantId
END
GO
