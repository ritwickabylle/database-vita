SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[GetFileMappingById] 
    @tenantId INT,    
  @id INT  = null 
AS    
BEGIN    
DECLARE @mapping NVARCHAR(MAX),
@transactionType nvarchar(max);  

 

    --SELECT @mapping= mapping   
    --FROM FileMappings    
    --WHERE @tenantId = @TenantId and id=@id;  [dbo].[MappingConfiguration]  
	Select @mapping=MappingData 
	from [dbo].[MappingConfiguration]
	WHERE @tenantId = @TenantId and id = @id;
IF(@mapping = '' OR @mapping IS NULL)  
BEGIN  
--SELECT @mapping= mapping   
--   FROM FileMappings    
--   WHERE @tenantId IS null and id=@id;
	Select @mapping=MappingData 
	from [dbo].[MappingConfiguration]
	WHERE @tenantId is null and id = @id;
END  
SELECT @mapping  
END;
GO
