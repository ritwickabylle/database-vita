SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    PROCEDURE [dbo].[GetFileMappings]    -- exec GetFileMappings 148
    @tenantId INT , 
	@module nvarchar(50) = 'WHT'
AS  
BEGIN  
	Select mconfig.Id,mconfig.MappingId,mconfig.TenantId,mconfig.Module,mconfig.MappingData as Mapping, mconfig.TransactionType,mconfig.isActive,mconfig.MappingName as Name
	,mm.MappingData as TransactionalMapping
	from [dbo].[MappingConfiguration] mconfig join  [dbo].[MappingConfiguration] mm on mm.MappingId = mconfig.MappingId and mm.MappingType = 'TransactionalMapping'
	WHERE mconfig.tenantId = @tenantId and mconfig.MappingType='FieldMapping';
END;
GO
