SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[GetFileMappingByType]  
    @tenantId INT,  
@type nvarchar(255)  , 
  @module nvarchar(50) = 'VAT'
AS  
BEGIN  
    --SELECT mapping 
    --FROM FileMappings  
    --WHERE @tenantId = @TenantId and transactiontype=@type;
	Select MappingData as mapping
	from [dbo].[MappingConfiguration]
	WHERE @tenantId is null and transactionType=@type and MappingType='FieldMapping' and module=@module;
END;
GO
