SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	
CREATE   PROCEDURE [dbo].[GetSampleTemplate]    
(    
    @module NVARCHAR(MAX) = NULL,                                
    @transactionType NVARCHAR(MAX) = NULL,  
    @mappingType NVARCHAR(MAX) = NULL, 
    @mappingName NVARCHAR(MAX) = NULL, 
    @tenantId INT = NULL  
)   
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MappingData NVARCHAR(MAX);  

    SELECT @MappingData = MappingData
    FROM MappingConfiguration 
    WHERE 
        TenantId = @tenantId 
        AND Module = @module 
        AND TransactionType = @transactionType 
        AND MappingType = @mappingType 
        AND MappingName = @mappingName;

    -- Create a temporary table to store the data
    CREATE TABLE #TempData (
        uploadedFields NVARCHAR(MAX),
        fieldForMapping NVARCHAR(MAX),
        transform NVARCHAR(MAX),
        combination NVARCHAR(MAX),
        sequenceNumber INT,
        isCustomerMapped BIT
    );

    INSERT INTO #TempData
    SELECT
        uploadedFields,
        fieldForMapping,
        transform,
        combination,
        sequenceNumber,
        isCustomerMapped
    FROM OPENJSON(@MappingData)
    WITH (
        uploadedFields NVARCHAR(MAX) '$.uploadedFields[0]',
        fieldForMapping NVARCHAR(MAX) '$.fieldForMapping',
        transform NVARCHAR(MAX) '$.transform[0]',
        combination NVARCHAR(MAX) '$.combination[0]',
        sequenceNumber INT '$.sequenceNumber',
        isCustomerMapped BIT '$.isCustomerMapped'
    );

DECLARE @PivotColumns NVARCHAR(MAX) = '';
SELECT @PivotColumns = @PivotColumns + QUOTENAME(uploadedFields) + ', ' FROM #TempData;
SET @PivotColumns = LEFT(@PivotColumns, LEN(@PivotColumns) - 1); -- Remove the trailing comma

DECLARE @DynamicSQL NVARCHAR(MAX) = '
SELECT ' + @PivotColumns + ', [Error] 
FROM (
    SELECT uploadedFields, '''' as fieldForMapping
    FROM #TempData
) AS SourceTable
PIVOT (
    MAX(fieldForMapping)
    FOR uploadedFields IN (' + @PivotColumns + ')
) AS PivotTable
CROSS APPLY (
    SELECT 1 AS OrderNumber, NULL AS [Error]
) AS ErrorData
ORDER BY OrderNumber;
';

EXEC sp_executesql @DynamicSQL;


    DROP TABLE #TempData;
END
GO
