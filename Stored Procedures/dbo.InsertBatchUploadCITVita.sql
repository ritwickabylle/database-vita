SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[InsertBatchUploadCITVita]    -- exec [InsertBatchUploadCITVita]     
  @json nvarchar(max) = N'
[
  {
    "Sr.No": null,
    "Provision name": "Interco Loan-Alf Trading",
    "Provisions balance at the beginning of the period": "434271",
    "Provisions made during the year": "58820",
    "Provisions utilized during the year": null,
    "Adjustments": "46010",
    "Provisions balance at the end of the period": "447087",
    "xml_uuid": "e1ebf820-f6db-42ef-8bfd-64b6b495fec1"
  },
  {
    "Sr.No": null,
    "Provision name": "IC-Ace Hardware",
    "Provisions balance at the beginning of the period": "434271",
    "Provisions made during the year": "58820",
    "Provisions utilized during the year": null,
    "Adjustments": "46010",
    "Provisions balance at the end of the period": "447087",
    "xml_uuid": "9bbb468a-0e1c-4c83-a92f-981863aeb770"
  },
  {
    "Sr.No": null,
    "Provision name": "provision",
    "Provisions balance at the beginning of the period": "434271",
    "Provisions made during the year": "58820",
    "Provisions utilized during the year": null,
    "Adjustments": "46010",
    "Provisions balance at the end of the period": "447087",
    "xml_uuid": "c175ab5a-0344-4652-a054-d06c52f0ddd7"
  },
  {
    "Sr.No": null,
    "Provision name": "clearing",
    "Provisions balance at the beginning of the period": "434271",
    "Provisions made during the year": "58820",
    "Provisions utilized during the year": null,
    "Adjustments": "46010",
    "Provisions balance at the end of the period": "447087",
    "xml_uuid": "a2128fc3-6163-4f3c-9f2b-a3f1760cb564"
  }
]
  ',  
  @scheduleCode nvarchar(max) = 'CIT_Schedule5',    
  @financialYear nvarchar(max) = null,    
  @userId int = 204,    
  @fileName nvarchar(max) = 'testing.xlsx',     
  @mappingId int = 0,    
  @tenantId int = 172,     
  @totalCount int = 4,  
  @fromdate DateTime = '1/1/2024',            
  @todate DateTime = '12/31/2024'   ,
   @isCreditNegative bit = 0
AS    
BEGIN    
Declare @maxBatchNo Int  
SELECT @maxBatchNo = MAX(BatchNo) + 1 FROM CITScheduleBatchData  
INSERT INTO [dbo].[CITScheduleBatchData]  
           ([TenantId]  
           ,[UniqueIdentifier]  
           ,[BatchNo]  
           ,[ScheduleName]  
           ,[FileName]  
           ,[UploadedOn]  
           ,[UploadedBy]  
           ,[TotalRecord]  
           ,[FinancialStartDate]  
           ,[FinancialEndDate]  
           ,[CreationTime]  
           ,[CreatorUserId]  
           ,[LastModificationTime]  
           ,[LastModifierUserId]  
           ,[IsActive])  
     VALUES  
           (@tenantId  
           ,NEWID()  
           ,isNUll(@maxBatchNo,1)  
           ,@scheduleCode  
           ,@fileName  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
           ,@totalCount  
     ,TRY_CAST(@fromdate AS DATE)  
     ,TRY_CAST(@todate AS DATE)  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
           ,TRY_CAST(GETDATE() AS DATE)  
           ,@userId  
           ,1)  
  DROP TABLE IF EXISTS ##TempJsonData   
  DECLARE @mappingsJson NVARCHAR(MAX)     
  DECLARE @mappingIdCIT NVARCHAR(MAX)    
  DECLARE @transformedJson NVARCHAR(MAX)    
  --set @mappingIdCIT = (select id from MappingConfiguration where TenantId = 0 and isActive = 1 and TransactionType = @scheduleCode) 
	set @mappingIdCIT = (select id from MappingConfiguration where TenantId = @tenantId and isActive = 1 and MappingType = 'FieldMapping' and TransactionType = @scheduleCode)    
	if(@mappingIdCIT is null or @mappingIdCIT=0)
	BEGIN
	   set @mappingIdCIT = (select id from MappingConfiguration where TenantId = 0 and isActive = 1 and MappingType = 'FieldMapping' and TransactionType = @scheduleCode)    
	END
  CREATE TABLE #mappingsJson (Data NVARCHAR(MAX))    
  INSERT INTO #mappingsJson (Data)     
  EXEC [dbo].[GetFileMappingById] @tenantId, @mappingIdCIT    
  SELECT @mappingsJson = Data FROM #mappingsJson json    
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
  FROM OPENJSON(@mappingsJson)    
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
  SET @DynamicSQL = '    
   DECLARE @JSONResult NVARCHAR(MAX);   
   DECLARE @Result TABLE (  
ErrorStatus INT,  
    ErrorMessage VARCHAR(MAX));  
   print ''hello''  
   SET @JSONResult = (SELECT '+ @NewColumnNames +','+ @NewColumnNamesS +' FROM ##TempJsonData FOR JSON AUTO);    
   print @JSONResult  
   IF @schedule = ''CIT_Schedule1''    
    EXEC dbo.InsertDataCIT_Schedule1 @JSONResult, @tenant, @userId, @fromdate, @todate;   
   ELSE IF @schedule = ''CIT_Schedule2''
   begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule2 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
   end
   ELSE IF @schedule = ''CIT_Schedule2_1''  
   begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule2_1 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
    end
   ELSE IF @schedule = ''CIT_Schedule3''    
     begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule3 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
   end   
   ELSE IF @schedule = ''CIT_Schedule4''    
     begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule4 @JSONResult, @tenant, @userId, @fromdate, @todate;   
	SELECT * FROM @Result;
    end     
   ELSE IF @schedule = ''CIT_Schedule5''
   begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule5 @JSONResult, @tenant, @userId, @fromdate, @todate;   
	SELECT * FROM @Result;
    end    
   ELSE IF @schedule = ''CIT_Schedule6''    
	begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule6 @JSONResult, @tenant, @userId, @fromdate, @todate;   
	SELECT * FROM @Result;
    end  
    ELSE IF @schedule = ''CIT_Schedule7''    
    begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule7 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
    end     
   ELSE IF @schedule = ''CIT_Schedule8''    
   begin
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule8 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
    end   
   ELSE IF @schedule = ''CIT_Schedule9''    
   BEGIN
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule9 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
	END
   ELSE IF @schedule = ''CIT_Schedule10''    
    EXEC dbo.InsertDataCIT_Schedule10 @JSONResult, @tenant, @userId, @fromdate, @todate; 
   ELSE IF @schedule = ''CIT_Schedule11_A''    
    EXEC dbo.InsertDataCIT_Schedule11_A @JSONResult, @tenant, @userId, @fromdate, @todate; 
   ELSE IF @schedule = ''CIT_Schedule11_B''    
    EXEC dbo.InsertDataCIT_Schedule11_B @JSONResult, @tenant, @userId, @fromdate, @todate; 
   ELSE IF @schedule = ''CIT_Schedule13''    
    EXEC dbo.InsertDataCIT_Schedule13 @JSONResult, @tenant, @userId, @fromdate, @todate; 
   ELSE IF @schedule = ''CIT_Schedule14''    
   BEGIN
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule14 @JSONResult, @tenant, @userId, @fromdate, @todate;    
	SELECT * FROM @Result;
	END
   ELSE IF @schedule = ''CIT_Schedule15''    
   BEGIN
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule15 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
	END
   ELSE IF @schedule = ''CIT_Schedule16'' 
   BEGIN
    INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule16 @JSONResult, @tenant, @userId, @fromdate, @todate;
	SELECT * FROM @Result;
	END
   ELSE IF @schedule = ''CIT_Schedule17'' 
   BEGIN
   INSERT INTO @Result EXEC dbo.InsertDataCIT_Schedule17 @JSONResult, @tenant, @userId, @fromdate, @todate; 
   SELECT * FROM @Result;
   END
   ELSE IF @schedule = ''CIT_Schedule18''  
   BEGIN
    INSERT INTO @Result  EXEC dbo.InsertDataCIT_Schedule18 @JSONResult, @tenant, @userId, @fromdate, @todate; 
	SELECT * FROM @Result;
	END
   ELSE IF @schedule = ''CIT_TrailBalance''    
Begin  
  INSERT INTO @Result EXEC dbo.TrialBalanceValidations @JSONResult, @tenant, @userId, @fromdate, @todate,@isCreditNegative;  
  SELECT * FROM @Result;  
end  
   ELSE    
    PRINT ''Unknown FileType: '' + @schedule;    
   DROP TABLE ##TempJsonData;    
   DROP TABLE #ColumnNames;    
   DROP TABLE if exists #mappingsJson    
  ';    
  EXEC sp_executesql @DynamicSQL , N'@tenant int, @schedule nvarchar(100), @userId INT, @fromdate datetime, @todate datetime, @isCreditNegative nvarchar(100)', @tenantId, @scheduleCode, @userId, @fromdate, @todate, @isCreditNegative;    
END
GO
