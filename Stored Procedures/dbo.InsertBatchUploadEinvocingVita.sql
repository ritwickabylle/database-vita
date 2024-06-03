SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
CREATE       PROCEDURE [dbo].[InsertBatchUploadEinvocingVita]    -- exec InsertBatchUploadEinvocingVita           
  @json nvarchar(max) = N'  
  [{
    "Name of the party": "Plasser Iberica",
    "Amount Paid": "37287.80036",
    "Country of residence": "Spain",
    "Nature of payment": "Technical Services",
    "BABS Classification": "Payments for Technical and Consulting services",
    "Payment date": "7/12/2023 12:00:00 AM",
    "Services Performed in KSA": "Inside Country",
    "WHT Rate": "0.05",
    "WHT Amount": "1864.390018",
    "Payment Type": "Overhead",
    "Exchange Rate": "1",
    "Amount in Saudi Riyal": "37287.80036",
    "Currency Code": "AED",
    "xml_uuid": "fc341ff3-9c29-4a9d-a300-c3d8c31dfbf3"
  }
  ]',                   
  @fileName nvarchar(max) = '202425153858_Invalid_COPASA Nov 20023_Purchase Unified File.xlsx',           
  @mappingId int = 10616,          
  @fileType nvarchar(100) = 'Payment',          
  @tenantId int = 159,                
  @fromdate DateTime = null,                  
  @todate DateTime = null,      
  @batchId int = 46     
AS          
BEGIN          
 DECLARE @mappingsJson NVARCHAR(MAX)          
    DECLARE @transformedJson NVARCHAR(MAX)          
 DROP TABLE IF EXISTS ##TempJsonData;            
 DROP TABLE IF EXISTS ##TempJsonData2;            

 CREATE TABLE #mappingsJson (Data NVARCHAR(MAX))          
          
 INSERT INTO #mappingsJson (Data)           
 EXEC [dbo].[GetFileMappingById] @tenantId, @mappingId          
          
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
 DECLARE @NewColumnNamesWithoutAlias NVARCHAR(MAX);          
 SELECT @NewColumnNames = STRING_AGG(          
  'ISNULL(' + QUOTENAME(c.[ColumnName]) + ',' +           
  CASE           
   WHEN m.DefaultValue IS NULL THEN ''''''          
   ELSE '''' + m.DefaultValue + ''''           
  END + ') AS ' + QUOTENAME(m.FieldForMapping),          
  ', '          
 ),      @NewColumnNamesWithoutAlias =  STRING_AGG(          
   QUOTENAME(m.FieldForMapping),          
  ', '          
 )    
 FROM @mappings as m Join #ColumnNames as c on TRIM(c.[ColumnName]) = TRIM(m.UploadedFields);    
 

 print @NewColumnNames
 print @NewColumnNamesWithoutAlias
          
 DECLARE @NewColumnNamesS NVARCHAR(MAX);          
 SELECT @NewColumnNamesS = STRING_AGG(          
  'ISNULL(' + QUOTENAME(c.[ColumnName]) + ', '''') AS ' + QUOTENAME(c.[ColumnName]),          
  ', '          
 )          
 FROM #ColumnNames c          
 LEFT JOIN @mappings m ON TRIM(c.[ColumnName]) = TRIM(m.UploadedFields)          
 WHERE m.UploadedFields IS NULL;    
 
 
 declare @sqlquery nvarchar(max)

 set @sqlquery = 'select '+ @NewColumnNames +'    
				   into ##TempJsonData2    
				  from ##TempJsonData;'

EXEC sp_executesql @sqlquery


     
 DECLARE @MandatCols nvarchar(max) = 'UniqueIdentifier,    
           BatchId,    
           TenantId,    
           Processed,    
           IsDeleted,    
           CreatorUserId,    
           [Filename],    
           TransType,    
           CreationTime'    
     
 ALTER TABLE ##TempJsonData2    
 ADD UniqueIdentifier uniqueIdentifier DEFAULT NEWID(),    
  BatchId int DEFAULT 0,    
  TenantId int DEFAULT 0,    
  Processed int DEFAULT 0,    
  IsDeleted bit DEFAULT 0,    
  CreatorUserId bigint default 1,    
  [Filename] nvarchar(500) default null,    
  TransType nvarchar(100) DEFAULT null,    
  CreationTime datetime2(7) DEFAULT GETDATE()    
        
      
    IF NOT EXISTS (SELECT *    
      FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
      WHERE TABLE_NAME = '##TempJsonData2' AND COLUMN_NAME = 'WHTApplicable')    
    BEGIN    
     BEGIN TRY    
      SET @SQL = 'ALTER TABLE ##TempJsonData2 ADD WHTApplicable NVARCHAR(MAX) DEFAULT NULL;';    
      EXEC sp_executesql @SQL;    
      set @MandatCols = @MandatCols + ',WHTApplicable';    
               
     END TRY    
     BEGIN CATCH    
      PRINT 'Error occurred: ' + ERROR_MESSAGE();    
     END CATCH    
    END    
    
    IF NOT EXISTS (SELECT *    
      FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
      WHERE TABLE_NAME = '##TempJsonData2' AND COLUMN_NAME = 'Isapportionment')    
    BEGIN    
     BEGIN TRY    
      SET @SQL = 'ALTER TABLE ##TempJsonData2 ADD Isapportionment NVARCHAR(MAX) DEFAULT NULL;';    
      EXEC sp_executesql @SQL;    
      set @MandatCols = @MandatCols + ',Isapportionment';    
               
     END TRY    
     BEGIN CATCH    
      PRINT 'Error occurred: ' + ERROR_MESSAGE();    
     END CATCH    
    END    
      
    IF NOT EXISTS (SELECT *    
      FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
      WHERE TABLE_NAME = '##TempJsonData2' AND COLUMN_NAME = 'VATDeffered')    
    BEGIN    
     BEGIN TRY    
      SET @SQL = 'ALTER TABLE ##TempJsonData2 ADD VATDeffered NVARCHAR(MAX) DEFAULT NULL;';    
      EXEC sp_executesql @SQL;    
      set @MandatCols = @MandatCols + ',VATDeffered';    
               
     END TRY    
     BEGIN CATCH    
      PRINT 'Error occurred: ' + ERROR_MESSAGE();    
     END CATCH    
    END    
       
    IF NOT EXISTS (SELECT *    
      FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
      WHERE TABLE_NAME = '##TempJsonData2' AND COLUMN_NAME = 'RCMApplicable')    
    BEGIN    
     BEGIN TRY    
      SET @SQL = 'ALTER TABLE ##TempJsonData2 ADD RCMApplicable NVARCHAR(MAX) DEFAULT NULL;';    
      EXEC sp_executesql @SQL;    
      set @MandatCols = @MandatCols + ',RCMApplicable';    
     END TRY    
     BEGIN CATCH    
      PRINT 'Error occurred: ' + ERROR_MESSAGE();    
     END CATCH    
    END    
    
    IF NOT EXISTS (SELECT *    
      FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
      WHERE TABLE_NAME = '##TempJsonData2' AND COLUMN_NAME = 'InvoiceType')    
    BEGIN    
     BEGIN TRY    
      SET @SQL = 'ALTER TABLE ##TempJsonData2 ADD InvoiceType NVARCHAR(MAX) DEFAULT NULL;';    
      EXEC sp_executesql @SQL;    
      set @MandatCols = @MandatCols + ',InvoiceType';    
     END TRY    
     BEGIN CATCH    
      PRINT 'Error occurred: ' + ERROR_MESSAGE();    
     END CATCH    
    END    
    
    IF NOT EXISTS (SELECT *    
      FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
      WHERE TABLE_NAME = '##TempJsonData2' AND COLUMN_NAME = 'PurchaseCategory')    
    BEGIN    
     BEGIN TRY    
      SET @SQL = 'ALTER TABLE ##TempJsonData2 ADD PurchaseCategory NVARCHAR(MAX) DEFAULT NULL;';    
      EXEC sp_executesql @SQL;    
      set @MandatCols = @MandatCols + ',PurchaseCategory';    
     END TRY    
     BEGIN CATCH    
      PRINT 'Error occurred: ' + ERROR_MESSAGE();    
     END CATCH    
    END   
	
               
 SET     
  @DynamicSQL = '          
  DECLARE @modifiedJson NVARCHAR(MAX);      
  UPDATE ##TempJsonData2 set  BatchId = @batchid,    
                TenantId = @tenantId,    
                Processed = 0,    
                IsDeleted = 0,    
                [Filename] = @fileN,    
                CreationTime = GETDATE(),    
                CreatorUserId = 1,    
                UniqueIdentifier = NEWID();    
       
   IF @file = ''Sales''       
  begin      
    Drop Table if exists #SalesTable;      
  select '+ @NewColumnNamesWithoutAlias +',' + @MandatCols +' into #SalesTable from ##TempJsonData2;      
    
   update #SalesTable set WHTApplicable = 0,      
    Isapportionment = 0,      
    VATDeffered = 0,      
    RCMApplicable = 0,      
    TransType = CASE WHEN TransType IS NULL THEN ''sales'' ELSE TransType END,    
    InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''Sales Invoice - Standard'' ELSE ''Sales Invoice - '' + InvoiceType END;      
    
   ALTER TABLE #SalesTable ALTER COLUMN Isapportionment bit      
         ALTER TABLE #SalesTable ALTER COLUMN VATDeffered bit      
         ALTER TABLE #SalesTable ALTER COLUMN RCMApplicable bit      
         ALTER TABLE #SalesTable ALTER COLUMN WHTApplicable bit     
    
             SET @modifiedJson = (select *      
          from #SalesTable FOR JSON AUTO);       
      
           Drop Table if exists #SalesTable;      
        
  end  
    
   ELSE IF @file = ''Credit''     
  begin      
    Drop Table if exists #CreditTable;      
  select '+ @NewColumnNamesWithoutAlias +',' + @MandatCols +' into #CreditTable from ##TempJsonData2;      
    
   update #CreditTable set WHTApplicable = 0,      
    Isapportionment = 0,      
    VATDeffered = 0,      
    RCMApplicable = 0,      
    TransType = CASE WHEN TransType IS NULL THEN ''Credit'' ELSE TransType END,    
    InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''Credit Note -'' ELSE ''Credit Note -'' + InvoiceType END;       
    
   ALTER TABLE #CreditTable ALTER COLUMN Isapportionment bit      
         ALTER TABLE #CreditTable ALTER COLUMN VATDeffered bit      
         ALTER TABLE #CreditTable ALTER COLUMN RCMApplicable bit      
         ALTER TABLE #CreditTable ALTER COLUMN WHTApplicable bit     
    
             SET @modifiedJson = (select *      
          from #CreditTable FOR JSON AUTO);       
      
           Drop Table if exists #CreditTable;      
        
  end
    
  ELSE IF @file = ''Debit''     
  begin      
    Drop Table if exists #DebitTable;      
  select '+ @NewColumnNamesWithoutAlias +',' + @MandatCols +' into #DebitTable from ##TempJsonData2;      
    
   update #DebitTable set WHTApplicable = 0,      
    Isapportionment = 0,      
    VATDeffered = 0,      
    RCMApplicable = 0,      
    TransType = CASE WHEN TransType IS NULL THEN ''Debit'' ELSE TransType END,    
    InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''Debit Note -'' ELSE ''Debit Note -'' + InvoiceType END;        
    
   ALTER TABLE #DebitTable ALTER COLUMN Isapportionment bit      
         ALTER TABLE #DebitTable ALTER COLUMN VATDeffered bit      
         ALTER TABLE #DebitTable ALTER COLUMN RCMApplicable bit      
         ALTER TABLE #DebitTable ALTER COLUMN WHTApplicable bit     
    
             SET @modifiedJson = (select *      
          from #DebitTable FOR JSON AUTO);       
      
           Drop Table if exists #DebitTable;      
        
  end

    
 ELSE IF @file = ''Purchase''     
  --  begin    
  --   update ##TempJsonData2 set WHTApplicable = dbo.ISNULLOREMPTYFORBIT(WHTApplicable),    
  --       Isapportionment = case when upper(PurchaseCategory) like ''OVER%'' and isnull(substring(upper(Isapportionment),1,1),''Y'') = ''Y'' then 1 else 0 end,    
    
  -- VATDeffered = case   
  -- WHEN VATDeffered IS NULL THEN 0  
  -- when isnull(VATdeffered,''Y'') like ''Y%'' then 1    
  --     when isnull(VATdeffered,''True'') like ''True%'' then 1  
  --     when isnull(VATdeffered,''T'') like ''T%'' then 1  
  --     when isnull(VATdeffered,''1'') like ''1%'' then 1  
  --      else 0 end,  
  
  -- RCMApplicable = case   
  -- WHEN RCMApplicable IS NULL THEN 0  
  -- when isnull(RCMApplicable,''Y'') like ''Y%'' then 1    
  --     when isnull(RCMApplicable,''True'') like ''True%'' then 1  
  --     when isnull(RCMApplicable,''T'') like ''T%'' then 1  
  --     when isnull(RCMApplicable,''1'') like ''1%'' then 1  
  --      else 0 end,   
  --       TransType = CASE WHEN TransType IS NULL THEN ''PURCHASE'' ELSE TransType END,    
  --       InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''Purchase Entry-STANDARD'' ELSE ''Purchase Entry-'' + InvoiceType END;   
     
  -- ALTER TABLE ##TempJsonData2 ALTER COLUMN Isapportionment bit    
  --       ALTER TABLE ##TempJsonData2 ALTER COLUMN VATDeffered bit    
  --       ALTER TABLE ##TempJsonData2 ALTER COLUMN RCMApplicable bit    
  --       ALTER TABLE ##TempJsonData2 ALTER COLUMN WHTApplicable bit   
    
  --SET @modifiedJson = (select '+ @NewColumnNamesWithoutAlias +',    
  --         UniqueIdentifier,    
  --         BatchId,    
  --         TenantId,    
  --         Processed,    
  --         IsDeleted,    
  --         WHTApplicable,    
  --         Isapportionment,    
  --         VATDeffered,    
  --         RCMApplicable,    
  --         CreatorUserId,    
  --         [Filename],    
  --         InvoiceType,    
  --         TransType,    
  --         CreationTime    
  --        from ##TempJsonData2 FOR JSON AUTO);      
  --end 
  
  begin    
   Drop Table if exists #PurchaseSingle;    
  select '+ @NewColumnNamesWithoutAlias +',' + @MandatCols +' into #PurchaseSingle from ##TempJsonData2;      
        update #PurchaseSingle set     
         WHTApplicable = dbo.ISNULLOREMPTYFORBIT(WHTApplicable),    
         Isapportionment = case when upper(PurchaseCategory) like ''OVER%'' and isnull(substring(upper(Isapportionment),1,1),''Y'') = ''Y'' then 1 else 0 end,    
  
   VATDeffered = case   
       WHEN VATDeffered IS NULL THEN 0  
       when isnull(VATdeffered,''Y'') like ''Y%'' then 1    
       when isnull(VATdeffered,''True'') like ''True%'' then 1  
       when isnull(VATdeffered,''T'') like ''T%'' then 1  
       when isnull(VATdeffered,''1'') like ''1%'' then 1  
        else 0 end,  
  
   RCMApplicable = case   
       WHEN RCMApplicable IS NULL THEN 0  
       when isnull(RCMApplicable,''Y'') like ''Y%'' then 1    
       when isnull(RCMApplicable,''True'') like ''True%'' then 1  
       when isnull(RCMApplicable,''T'') like ''T%'' then 1  
       when isnull(RCMApplicable,''1'') like ''1%'' then 1  
        else 0 end,  
    
         TransType = CASE WHEN TransType IS NULL THEN ''PURCHASE'' ELSE TransType END,    
         InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''Purchase Entry-STANDARD'' ELSE ''Purchase Entry-'' + InvoiceType END;    
    
         ALTER TABLE #PurchaseSingle ALTER COLUMN Isapportionment bit    
         ALTER TABLE #PurchaseSingle ALTER COLUMN VATDeffered bit    
         ALTER TABLE #PurchaseSingle ALTER COLUMN RCMApplicable bit    
         ALTER TABLE #PurchaseSingle ALTER COLUMN WHTApplicable bit   
    
          SET @modifiedJson = (select *    
          from #PurchaseSingle FOR JSON AUTO);     
    
           Drop Table if exists #PurchaseSingle;    
  end
    
  ELSE IF @file = ''PurchaseCredit''     
    begin    
     update ##TempJsonData2 set WHTApplicable = dbo.ISNULLOREMPTYFORBIT(WHTApplicable),    
         Isapportionment = case when upper(PurchaseCategory) like ''OVER%'' and isnull(substring(upper(Isapportionment),1,1),''Y'') = ''Y'' then 1 else 0 end,    
    
   VATDeffered = case   
   WHEN VATDeffered IS NULL THEN 0  
   when isnull(VATdeffered,''Y'') like ''Y%'' then 1    
       when isnull(VATdeffered,''True'') like ''True%'' then 1  
       when isnull(VATdeffered,''T'') like ''T%'' then 1  
       when isnull(VATdeffered,''1'') like ''1%'' then 1  
        else 0 end,  
  
   RCMApplicable = case   
  
   WHEN RCMApplicable IS NULL THEN 0  
   when isnull(RCMApplicable,''Y'') like ''Y%'' then 1    
       when isnull(RCMApplicable,''True'') like ''True%'' then 1  
       when isnull(RCMApplicable,''T'') like ''T%'' then 1  
       when isnull(RCMApplicable,''1'') like ''1%'' then 1  
        else 0 end,     
         TransType = CASE WHEN TransType IS NULL THEN ''CREDIT-PURCHASE'' ELSE TransType END,    
         InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''CN Purchase-STANDARD'' ELSE ''CN Purchase-'' + InvoiceType END;    
  
   ALTER TABLE ##TempJsonData2 ALTER COLUMN Isapportionment bit    
         ALTER TABLE ##TempJsonData2 ALTER COLUMN VATDeffered bit    
         ALTER TABLE ##TempJsonData2 ALTER COLUMN RCMApplicable bit    
         ALTER TABLE ##TempJsonData2 ALTER COLUMN WHTApplicable bit   
    
  SET @modifiedJson = (select '+ @NewColumnNamesWithoutAlias +',    
           UniqueIdentifier,    
           BatchId,    
           TenantId,    
           Processed,    
           IsDeleted,    
           WHTApplicable,    
           Isapportionment,    
           VATDeffered,    
           RCMApplicable,    
           CreatorUserId,    
           [Filename],    
           InvoiceType,    
           TransType,    
           CreationTime    
          from ##TempJsonData2 FOR JSON AUTO);      
  end    
    
  ELSE IF @file = ''PurchaseDebit''     
    begin    
     update ##TempJsonData2 set WHTApplicable = dbo.ISNULLOREMPTYFORBIT(WHTApplicable),    
         Isapportionment = case when upper(PurchaseCategory) like ''OVER%'' and isnull(substring(upper(Isapportionment),1,1),''Y'') = ''Y'' then 1 else 0 end,    
    
   VATDeffered = case   
        WHEN VATDeffered IS NULL THEN 0  
        when isnull(VATdeffered,''Y'') like ''Y%'' then 1    
       when isnull(VATdeffered,''True'') like ''True%'' then 1  
       when isnull(VATdeffered,''T'') like ''T%'' then 1  
       when isnull(VATdeffered,''1'') like ''1%'' then 1  
        else 0 end,  
  
   RCMApplicable = case   
        WHEN RCMApplicable IS NULL THEN 0  
        when isnull(RCMApplicable,''Y'') like ''Y%'' then 1    
       when isnull(RCMApplicable,''True'') like ''True%'' then 1  
       when isnull(RCMApplicable,''T'') like ''T%'' then 1  
       when isnull(RCMApplicable,''1'') like ''1%'' then 1  
        else 0 end,     
         TransType = CASE WHEN TransType IS NULL THEN ''DEBIT-PURCHASE'' ELSE TransType END,    
         InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''DN Purchase-STANDARD'' ELSE ''DN Purchase-'' + InvoiceType END;    
  
   ALTER TABLE ##TempJsonData2 ALTER COLUMN Isapportionment bit    
         ALTER TABLE ##TempJsonData2 ALTER COLUMN VATDeffered bit    
         ALTER TABLE ##TempJsonData2 ALTER COLUMN RCMApplicable bit    
         ALTER TABLE ##TempJsonData2 ALTER COLUMN WHTApplicable bit   
    
  SET @modifiedJson = (select '+ @NewColumnNamesWithoutAlias +',    
           UniqueIdentifier,    
           BatchId,    
           TenantId,    
           Processed,    
           IsDeleted,    
           WHTApplicable,    
           Isapportionment,    
           VATDeffered,    
           RCMApplicable,    
           CreatorUserId,    
           [Filename],    
           InvoiceType,    
           TransType,    
           CreationTime    
          from ##TempJsonData2 FOR JSON AUTO);      
  end    
    
  ELSE IF @file = ''Payment''     
    begin    
     DROP TABLE IF EXISTS #Payment  
  select '+ @NewColumnNamesWithoutAlias +',    
           ' + @MandatCols +'    
           into #Payment    
          from ##TempJsonData2;      
    
        update #Payment set WHTApplicable = 0,    
         Isapportionment = 0,    
         VATDeffered = case when upper(VATDeffered) like ''Y%'' then 1 else 0 end,    
         RCMApplicable = 0,    
         TransType = CASE WHEN TransType IS NULL THEN ''PAYMENT'' ELSE TransType END,    
         InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''WHT - '' ELSE ''WHT - '' + InvoiceType END;    
    
   ALTER TABLE #Payment ALTER COLUMN Isapportionment bit    
         ALTER TABLE #Payment ALTER COLUMN VATDeffered bit    
         ALTER TABLE #Payment ALTER COLUMN RCMApplicable bit    
         ALTER TABLE #Payment ALTER COLUMN WHTApplicable bit   
  
          SET @modifiedJson = (select *    
          from #Payment FOR JSON AUTO);    
    
           DROP TABLE IF EXISTS #Payment    
  end    
    
  ELSE IF @file = ''SalesUnified''     
    begin    
    Drop Table if exists #SalesUnified;    
  select '+ @NewColumnNamesWithoutAlias +',' + @MandatCols +' into #SalesUnified from ##TempJsonData2;    
  
   update #SalesUnified set WHTApplicable = 0,    
    Isapportionment = 0,    
    VATDeffered = 0,    
    RCMApplicable = 0,    
    TransType = CASE WHEN TransType IS NULL THEN ''Unclassified'' ELSE TransType END,    
    InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''Unclassified'' ELSE InvoiceType END;    
  
   ALTER TABLE #SalesUnified ALTER COLUMN Isapportionment bit    
         ALTER TABLE #SalesUnified ALTER COLUMN VATDeffered bit    
         ALTER TABLE #SalesUnified ALTER COLUMN RCMApplicable bit    
         ALTER TABLE #SalesUnified ALTER COLUMN WHTApplicable bit   
  
             SET @modifiedJson = (select *    
          from #SalesUnified FOR JSON AUTO);     
    
           Drop Table if exists #SalesUnified;    
      
  end    
    
  ELSE IF @file = ''PurchaseUnified''     
  begin    
   Drop Table if exists #PurchaseUnified;    
  select '+ @NewColumnNamesWithoutAlias +',' + @MandatCols +' into #PurchaseUnified from ##TempJsonData2;      
        update #PurchaseUnified set     
         WHTApplicable = dbo.ISNULLOREMPTYFORBIT(WHTApplicable),    
         Isapportionment = case when upper(PurchaseCategory) like ''OVER%'' and isnull(substring(upper(Isapportionment),1,1),''Y'') = ''Y'' then 1 else 0 end,    
  
   VATDeffered = case   
       WHEN VATDeffered IS NULL THEN 0  
       when isnull(VATdeffered,''Y'') like ''Y%'' then 1    
       when isnull(VATdeffered,''True'') like ''True%'' then 1  
       when isnull(VATdeffered,''T'') like ''T%'' then 1  
       when isnull(VATdeffered,''1'') like ''1%'' then 1  
        else 0 end,  
  
   RCMApplicable = case   
       WHEN RCMApplicable IS NULL THEN 0  
       when isnull(RCMApplicable,''Y'') like ''Y%'' then 1    
       when isnull(RCMApplicable,''True'') like ''True%'' then 1  
       when isnull(RCMApplicable,''T'') like ''T%'' then 1  
       when isnull(RCMApplicable,''1'') like ''1%'' then 1  
        else 0 end,  
    
         TransType = CASE WHEN TransType IS NULL THEN ''Unclassified'' ELSE TransType END,    
         InvoiceType = CASE WHEN InvoiceType IS NULL THEN ''Unclassified'' ELSE InvoiceType END;    
    
         ALTER TABLE #PurchaseUnified ALTER COLUMN Isapportionment bit    
         ALTER TABLE #PurchaseUnified ALTER COLUMN VATDeffered bit    
         ALTER TABLE #PurchaseUnified ALTER COLUMN RCMApplicable bit    
         ALTER TABLE #PurchaseUnified ALTER COLUMN WHTApplicable bit   
    
          SET @modifiedJson = (select *    
          from #PurchaseUnified FOR JSON AUTO);     
    
           Drop Table if exists #PurchaseUnified;    
  end    
    
  ELSE          
   PRINT ''Unknown FileType: '' + @fileN;     
    
   SELECT @modifiedJson    
    
 --  else    
 --  SET @modifiedJson = (SELECT ' + @NewColumnNames + ',' + @NewColumnNamesS + ' FROM ##TempJsonData2 FOR JSON AUTO);      
  DROP TABLE ##TempJsonData;            
  DROP TABLE ##TempJsonData2;            
  DROP TABLE #ColumnNames;          
  DROP TABLE #mappingsJson;          
 ';    
    
          
 EXEC sp_executesql @DynamicSQL , N'@tenantId int, @file nvarchar(100), @fileN nvarchar(100),@mapId int, @batchid int',           
 @tenantId, @fileType,@fileName,@mappingId, @batchId;          
 END
GO
