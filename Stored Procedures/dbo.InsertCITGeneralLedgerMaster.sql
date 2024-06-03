SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
CREATE          PROCEDURE [dbo].[InsertCITGeneralLedgerMaster]    -- exec [InsertCITGeneralLedgerMaster]         
  @json nvarchar(max) = N'
  [
  {
    "GL Code": "31016001",
    "GL Name": "Retail Sales Cafe",
    "GL Group": "Revenue",
    "xml_uuid": "ac95dc0a-e983-44f0-ba8f-c70d9476be05"
  },
  {
    "GL Code": "31011002",
    "GL Name": "Wholesale Sales",
    "GL Group": "Revenue",
    "xml_uuid": "d7cbe0ca-91fe-490c-ac49-ffd8c8b88566"
  },
  {
    "GL Code": "31011004",
    "GL Name": "Employee Sales",
    "GL Group": "Revenue",
    "xml_uuid": "3b0688e1-c385-44f1-8c37-c06f3b96ac46"
  },
  {
    "GL Code": "41051003",
    "GL Name": "Rent - Employee Accommodation - P",
    "GL Group": "Rent Expense",
    "xml_uuid": "a5b87b67-ab7f-4fe2-8ab0-4cd3f9a3ab3e"
  },
  {
    "GL Code": "41051005",
    "GL Name": "Warehouse Rent - P",
    "GL Group": "Rent Expense",
    "xml_uuid": "96baa8d2-2ac7-47b5-b2da-56bb3653e29b"
  },
  {
    "GL Code": "51031002",
    "GL Name": "Rent - Employee Accommodation - A",
    "GL Group": "Rentals",
    "xml_uuid": "71cfdcba-9d21-40e2-9907-c28bd3251cce"
  }
]
  ',             
  @type nvarchar(max) = 'GLMaster',        
  @userId int = null,        
  @tenantId int = 148,      
  @fromdate DateTime = '1/1/2023',            
  @todate DateTime = '12/31/2023'   
AS        
BEGIN        
        
 IF @type = 'GLMaster'        
 BEGIN        
 DROP TABLE IF EXISTS ##TempJsonData        
 DECLARE @mappingsJson NVARCHAR(MAX)        
    DECLARE @transformedJson NVARCHAR(MAX)        
 DECLARE @MappingJsonGL NVARCHAR(MAX)
DECLARE @mappingIdCIT NVARCHAR(MAX)      
  --set @mappingIdCIT = (select id from MappingConfiguration where TenantId = 0 and isActive = 1 and TransactionType = @scheduleCode) 
	set @mappingIdCIT = (select id from MappingConfiguration where TenantId = @tenantId and isActive = 1 and MappingType = 'FieldMapping' and TransactionType = 'CIT_GeneralLedger')    
	if(@mappingIdCIT is null or @mappingIdCIT=0)
	BEGIN
	   set @mappingIdCIT = (select id from MappingConfiguration where TenantId = 0 and isActive = 1 and MappingType = 'FieldMapping' and TransactionType = 'CIT_GeneralLedger')    
	END

 
  CREATE TABLE #mappingsJson (Data NVARCHAR(MAX))    
  INSERT INTO #mappingsJson (Data)     
  EXEC [dbo].[GetFileMappingById] @tenantId, @mappingIdCIT    
  SELECT @MappingJsonGL = Data FROM #mappingsJson json  

 --CREATE TABLE #mappingsJson (Data NVARCHAR(MAX))        
        
 --INSERT INTO #mappingsJson (Data)         
 --EXEC [dbo].[GetFileMappingById] @tenantId, @mappingId        
        
 --SELECT @mappingsJson = Data FROM #mappingsJson json        
        
 DECLARE @sql NVARCHAR(MAX) = N'CREATE TABLE ##TempJsonData (ID INT IDENTITY(1,1), ';        
        
 SELECT @sql += QUOTENAME([key]) + ' NVARCHAR(MAX), ' FROM OPENJSON(@json, '$[0]');        
        
 SET @sql = LEFT(@sql, LEN(@sql) - 1) + ')';        
        
     
        
 EXEC sp_executesql @sql;        
        
 DECLARE @columns_for_Json NVARCHAR(MAX);        
 DECLARE @columns_for_Json_type NVARCHAR(MAX);        
 DECLARE @sql_for_Json NVARCHAR(MAX);        
        
 SELECT @columns_for_Json_type = STRING_AGG(QUOTENAME([key]) + ' NVARCHAR(MAX)', ',')         
 FROM OPENJSON(@json, '$[0]');        
        
 SELECT @columns_for_Json = STRING_AGG(QUOTENAME([key]), ',')         
 FROM OPENJSON(@json, '$[0]');        
        
       
        
    DECLARE @index INT = 1        
    DECLARE @count INT = (SELECT COUNT(*) FROM OpenJson(@json))        
        
 SET @sql_for_Json = 'INSERT INTO ##TempJsonData (' + @columns_for_Json + ') ' +        
      'SELECT *        
      FROM OPENJSON(@j) ' +        
      'WITH (' + @columns_for_Json_type + ')';        
        
 EXEC sp_executesql @sql_for_Json, N'@j NVARCHAR(MAX)', @json;        
        
    DECLARE @mappings TABLE (        
        UploadedFields NVARCHAR(MAX),        
        FieldForMapping NVARCHAR(MAX),        
        DefaultValue NVARCHAR(MAX),        
        Transform NVARCHAR(MAX),        
        DataType NVARCHAR(MAX),        
        Combination NVARCHAR(MAX),        
        SequenceNumber INT,        
        IsCustomerMapped BIT        
    )        
    INSERT INTO @mappings        
    SELECT        
        JSON_VALUE(value, '$.uploadedFields[0]') AS UploadedFields,        
        JSON_VALUE(value, '$.fieldForMapping') AS FieldForMapping,        
        JSON_VALUE(value, '$.defaultValue') AS DefaultValue,        
        JSON_VALUE(value, '$.transform') AS Transform,        
        JSON_VALUE(value, '$.dataType') AS DataType,        
        JSON_VALUE(value, '$.combination[0]') AS Combination,        
        JSON_VALUE(value, '$.sequenceNumber') AS SequenceNumber,        
        JSON_VALUE(value, '$.isCustomerMapped') AS IsCustomerMapped        
    FROM OPENJSON(@MappingJsonGL)        
        
 CREATE TABLE #ColumnNames (ColumnName NVARCHAR(MAX));        
 INSERT INTO #ColumnNames        
 Select [name] from tempdb.sys.all_columns where object_id = OBJECT_ID('tempdb..##TempJsonData');        
        
 DECLARE @DynamicSQL NVARCHAR(MAX);        
 DECLARE @NewColumnNames NVARCHAR(MAX);        
 SELECT @NewColumnNames = STRING_AGG(        
  'ISNULL(' + QUOTENAME(c.[ColumnName]) + ',' +         
  CASE         
   WHEN m.DefaultValue IS NULL THEN ''''''        
   ELSE '''' + m.DefaultValue + ''''         
  END + ') AS ' + QUOTENAME(m.FieldForMapping),        
  ', '        
 )        
 FROM @mappings as m Join #ColumnNames as c on TRIM(c.[ColumnName]) = TRIM(m.UploadedFields);        
        
 DECLARE @NewColumnNamesS NVARCHAR(MAX);        
 SELECT @NewColumnNamesS = STRING_AGG(        
  'ISNULL(' + QUOTENAME(c.[ColumnName]) + ', '''') AS ' + QUOTENAME(c.[ColumnName]),        
  ', '        
 )        
 FROM #ColumnNames c        
 LEFT JOIN @mappings m ON TRIM(c.[ColumnName]) = TRIM(m.UploadedFields)        
 WHERE m.UploadedFields IS NULL;        
        
 PRINT @NewColumnNames        
 PRINT @NewColumnNamesS        
        
 SET @DynamicSQL = '        
  DECLARE @JSONResult NVARCHAR(MAX);       
   DECLARE @Result TABLE (    
 ErrorStatus INT,    
    ErrorMessage VARCHAR(MAX));   
        
  SET @JSONResult = (SELECT '+ @NewColumnNames +','+ @NewColumnNamesS +' FROM ##TempJsonData FOR JSON AUTO);             
  print @JSONResult
  IF @type = ''GLMaster''    
  begin  
   INSERT INTO @Result EXEC dbo.InsertGLMasterData @JSONResult, @tenantId, @userId, @fromdate, @todate;   
   SELECT * FROM @Result;  
   end  
  ELSE        
   PRINT ''Unknown Type: '' + @type;        
        
  DROP TABLE ##TempJsonData;        
  DROP TABLE #ColumnNames;        
 ';        
        
 EXEC sp_executesql @DynamicSQL , N'@tenantId int, @type nvarchar(100), @userId int, @fromdate datetime, @todate datetime', @tenantId, @type, @userId, @fromdate, @todate;        
 END        
        
 ELSE        
 BEGIN        
  Print ''        
 END        
END
GO
