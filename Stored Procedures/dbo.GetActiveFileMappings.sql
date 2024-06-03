SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create      PROCEDURE [dbo].[GetActiveFileMappings]    -- exec   GetActiveFileMappings 148, 'VAT'
    @tenantId INT , 
	@module nvarchar(50)
AS  
BEGIN  
	Select Id,TenantId,Module,MappingData as Mapping, TransactionType,isActive,MappingName as Name
	from [dbo].[MappingConfiguration]
	WHERE tenantId = @tenantId and Module = @module and MappingType='FieldMapping' and IsActive = 1;
END;
GO
