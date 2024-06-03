SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
          
CREATE       PROCEDURE [dbo].[ExecuteValidations]    -- exec ExecuteValidations  'PurchaseUnified',159, 8116, 10446               
  @fileType nvarchar(100),          
  @tenantId int,                
  @batchId int,      
  @mappingId int       
AS          
BEGIN        
    
   Insert into Logs( [json],[date],[batchid])            
   Values('Insertion end', GetDate(),@batchId)      
    
       
        
    
    
   Insert into Logs( [json],[date],[batchid])            
   Values('Validation Started', GetDate(),@batchId)      
      
  IF @fileType = 'Sales'        
  begin      
   update                       
   BatchData                       
 set                                   
   status = 'Processed',          
   [Type] = 'Sales'          
 where             
   BatchId = @batchid                       
   and Status = 'Unprocessed';      
    exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
    exec SalesTransValidation @batchid,1,@tenantId      
  end      
      
  ELSE IF @fileType = 'Credit'       
  begin      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Credit'        
 where           
   BatchId = @batchid                   
   and Status = 'Unprocessed';      
    exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
    exec CreditNoteTransValidation @batchid, 1, @tenantId      
  end      
      
  ELSE IF @fileType = 'Debit'         
  begin      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Debit'        
 where           
   BatchId = @batchid                   
   and Status = 'Unprocessed';      
    exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
    exec DebitNoteTransValidation @batchid,1 , @tenantId       
  end        
         
  ELSE IF @fileType = 'Purchase'      
  begin      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Purchase'        
 where           
   BatchId = @batchid                   
   and Status = 'Unprocessed';      
    exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
    exec PurchaseTransValidation @batchid,1,@tenantId        
  end       
      
  ELSE IF @fileType = 'PurchaseCredit'          
  begin      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Credit-purchase'        
 where           
   BatchId = @batchid                       
   and Status = 'Unprocessed';    
    exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
   exec CreditNotePurchaseTransValidation @batchid,1,@tenantId       
   end      
      
  ELSE IF @fileType = 'PurchaseDebit'        
  begin      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Debit-purchase'        
 where           
   BatchId = @batchid                       
   and Status = 'Unprocessed';        
    exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
   exec DebitNotePurchaseTransValidation @batchid,1,@tenantId       
   end       
      
  ELSE IF @fileType = 'Payment'      
  begin      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Payment'        
 where           
   BatchId = @batchid                       
   and Status = 'Unprocessed';      
    exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
    exec PaymentTransValidation @batchId,1, @tenantId        
  end      
      
  ELSE IF @fileType = 'SalesUnified'        
  begin      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Sales Unified'        
 where           
   BatchId = @batchid                      
   and Status = 'Unprocessed';      
      
   ------------updating according to criteria-------------      
      
  declare @sql nvarchar(max);                          
  declare @desc nvarchar(max);                          
  declare @field nvarchar(max);                          
  declare @error_code  nvarchar(max);                          
  declare @stop_condition  int;                          
  declare @next_rule_on_success int;                          
  declare @next_rule_on_failure int;                          
  declare @output int;                          
  declare @count int=0;                          
  declare @skip int=0;                          
  declare @query nvarchar(max)='update ImportBatchData set TransType=@transType,  InvoiceType = @transType + '' Invoice - Standard'' where batchId=@batchId and '                    
  declare @transType nvarchar(200)                    
                    
  declare @v_sql CURSOR;               
  set @v_sql=                           
  CURSOR FOR                          
  select r.SqlStatement,r.OnSuccessNext,r.OnFailureNext,r.errorCode,r.StopCondition,r.[key],r.TransactionType from [unifiedRules] r                          
  where r.[key]='Map'+cast(@mappingId as nvarchar(50)) and r.isActive=1                     
  and  ((r.TenantId=@tenantId and (select count(*) from [unifiedRules] where tenantId=@tenantId)>0)                      
  or (r.TenantId is null and (select count(*) from [unifiedRules] where tenantId=@tenantId)=0))                    
  order by r.[Order]                        
                  
                    
  --select * from [unifiedRules]                    
                    
  OPEN @v_sql                                      
  FETCH NEXT  FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition,@field,@transType;                                      
  WHILE @@FETCH_STATUS = 0                                      
  BEGIN                                      
     set @count=@count+1;                          
                             
    --print concat(concat(@sql, @field),@count)                                  
     set @sql = @query + @sql  ;                                      
   print @sql                          
     EXECUTE sp_executesql @SQL,@Params = N'@batchId INT,@transType nvarchar(200)', @batchId = @batchId,                    
     @transType = @transType                              
                                 
   FETCH NEXT                                       
  FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition,@field,@transType;                                      
                                      
  END                                      
                                      
  CLOSE @v_sql                                      
                                      
                                      
  DEALLOCATE @v_sql         
      
      
   exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
    if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'SALES')                
 BEGIN              
 exec SalesTransValidation @batchid,1, @tenantId             
 END              
  if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'CREDIT')                
 BEGIN              
 exec CreditNoteTransValidation @batchid, 1, @tenantId                        
 END              
  if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'DEBIT')                
 BEGIN              
 exec DebitNoteTransValidation @batchid,1  , @tenantId                    
 END      
 if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'UNCLASSIFIED')                
 BEGIN              
 exec UnclassifiedTransValidation @batchid,1,@tenantId                        END       
 end      
      
      
  ELSE IF @fileType = 'PurchaseUnified'          
  begin      
      
   update                     
   BatchData                     
 set                                 
   status = 'Processed',        
   [Type] = 'Purchase Unified'        
 where           
   BatchId = @batchid                      
   and Status = 'Unprocessed';      
      
      
   DECLARE @p_sql NVARCHAR(MAX);      
   DECLARE @p_desc NVARCHAR(MAX);      
   DECLARE @p_field NVARCHAR(MAX);      
   DECLARE @p_error_code NVARCHAR(MAX);      
   DECLARE @p_stop_condition INT;      
   DECLARE @p_next_rule_on_success INT;      
   DECLARE @p_next_rule_on_failure INT;      
   DECLARE @p_output INT;      
   DECLARE @p_count INT = 0;      
   DECLARE @p_skip INT = 0;      
   DECLARE @p_query NVARCHAR(MAX) = 'UPDATE ImportBatchData SET TransType=@p_transType,  InvoiceType = @p_transType + '' Invoice - Standard'' WHERE batchId=@batchId AND ';      
   DECLARE @p_transType NVARCHAR(200);      
      
   DECLARE @p_v_sql CURSOR;      
   SET @p_v_sql = CURSOR FOR      
    SELECT r.SqlStatement, r.OnSuccessNext, r.OnFailureNext, r.errorCode, r.StopCondition, r.[key], r.TransactionType      
    FROM [unifiedRules] r      
    WHERE r.[key]='Map'+CAST(@mappingId AS NVARCHAR(50)) AND r.isActive=1      
    AND ((r.TenantId=@tenantId AND (SELECT COUNT(*) FROM [unifiedRules] WHERE tenantId=@tenantId)>0)      
    OR (r.TenantId IS NULL AND (SELECT COUNT(*) FROM [unifiedRules] WHERE tenantId=@tenantId)=0))      
    ORDER BY r.[Order];      
      
   OPEN @p_v_sql;      
      
   FETCH NEXT FROM @p_v_sql INTO @p_sql, @p_next_rule_on_success, @p_next_rule_on_failure, @p_error_code, @p_stop_condition, @p_field, @p_transType;      
      
   WHILE @@FETCH_STATUS = 0      
   BEGIN      
    SET @p_count = @p_count + 1;      
      
    SET @p_sql = @p_query + @p_sql;      
    PRINT @p_sql;      
      
    EXECUTE sp_executesql @p_sql, @Params = N'@batchId INT, @p_transType NVARCHAR(200)', @batchId = @batchId, @p_transType = @p_transType;      
      
    FETCH NEXT FROM @p_v_sql INTO @p_sql, @p_next_rule_on_success, @p_next_rule_on_failure, @p_error_code, @p_stop_condition, @p_field, @p_transType;      
   END;      
      
   CLOSE @p_v_sql;      
   DEALLOCATE @p_v_sql;      
      
      
      
   exec InsertBatchUploadDefaultValues @batchId, @tenantId;    
     if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'PURCHASE')                
 BEGIN              
 exec PurchaseTransValidation @batchid,1 ,@tenantId               
 END                   
  if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'CREDIT-PURCHASE')                
 BEGIN              
 exec CreditNotePurchaseTransValidation @batchid,1,@tenantId                         
 END                    
  if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'DEBIT-PURCHASE')                
 BEGIN              
 exec DebitNotePurchaseTransValidation @batchid,1 ,@tenantId                        
 END                    
  if exists (select top 1 id from ImportBatchData where BatchId = @BatchId and upper(trim(TransType)) = 'UNCLASSIFIED')                
 BEGIN              
 exec UnclassifiedTransValidation @batchid,1,@tenantId                         
 END       
 end      
      
  ELSE          
   PRINT 'Unknown FileType: ' + @fileType;        
         
   Insert into Logs( [json],[date],[batchid])            
   Values('Validation End', GetDate(),@batchId)      
       
END
GO
