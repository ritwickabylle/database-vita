SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE       PROCEDURE [dbo].[GetSalesInvalidRecordByDynamicMapping]                         
(                        
 @batchId int=148,                      
 @tenantId int=148,            
 @status nvarchar(max)='Success'         
)                        
AS                        
BEGIN                 
                         
declare @type nvarchar(20)                  
        
        
select @type=type from batchdata where batchid=@batchId              
select @tenantId=tenantId from batchdata where batchid=@batchId              
declare @module nvarchar(50)              
SET @module = CASE               
                WHEN @type <> 'Payment' THEN 'VAT'              
                ELSE 'WHT'              
              END              
              
 DECLARE @cols nvarchar(max),              
        @query nvarchar(max),              
  @mappingType nvarchar(50) = 'FieldMapping',              
  @transactionType nvarchar(50) = @type              
                
Drop table If Exists #TempImportBatchData
SELECT *
INTO #TempImportBatchData
FROM ImportBatchData where BatchId = @batchId and TenantId =@tenantId
    
        
  if (@status <> 'Success')            
  begin            
SET @query = ' DECLARE @combinedString VARCHAR(MAX)         
SELECT {statement},ie.Error FROM         
#TempImportBatchData ib         
INNER JOIN (( select uniqueIdentifier,STRING_AGG(COALESCE(@combinedString + '';'', '''') + cast(ErrorType as varchar)+ ''-''+ ErrorMessage,'','')as error  from          
importstandardfiles_ErrorLists         
where BatchId = '+ cast(@batchId as varchar(10)) + ' and TenantId='+ cast(@tenantId as varchar(10))+'   and          
 Status =0 group by uniqueIdentifier)) as IE on ie.uniqueIdentifier = ib.UniqueIdentifier'  --TODO : WRITE the full SQL Statement              
  end            
  else            
  begin            
  SET @query = ' DECLARE @combinedString VARCHAR(MAX)        
  SELECT {statement},ie.Error FROM         
#TempImportBatchData ib         
INNER JOIN (( select uniqueIdentifier,'''' as error  from          
importstandardfiles_ErrorLists         
where BatchId = '+ cast(@batchId as varchar(10)) + ' and TenantId='+ cast(@tenantId as varchar(10))+'   and          
 Status =1 group by uniqueIdentifier)) as IE on ie.uniqueIdentifier = ib.UniqueIdentifier' --TODO : WRITE the full SQL Statement             
  end      
  

              
              
Declare @MappingId int              
Declare @CommonMappingId int              
select @MappingId =  Id , @CommonMappingId = MappingId             
FROM MappingConfiguration MT              
 WHERE              
  MT.TenantId = @tenantId AND              
  MT.Module = @module AND              
  MT.TransactionType = @transactionType AND              
  MT.MappingType = @mappingType AND      
  MT.IsActive = 1      
order by Id desc         
    
print @MappingId 


DECLARE @Transjson NVARCHAR(MAX) 

SELECT TOP 1 @Transjson = MappingData 
FROM MappingConfiguration 
WHERE MappingType = 'TransactionalMapping' 
    AND MappingId = @CommonMappingId 
    AND TenantId = @tenantId
	AND IsActive = 1  
ORDER BY id DESC;

Declare @negativeCount int
Declare @negativeTrans nvarchar(max) = null
Declare @negativeTransClause nvarchar(max) = null
              
SELECT
   @negativeCount = count(*), @negativeTrans = COALESCE(@negativeTrans + ', ', '') + '''' + transactionType + ''''
FROM
    OPENJSON(@Transjson)
WITH (
    transactionType NVARCHAR(100),
    valueRule NVARCHAR(100)
) AS json_data
WHERE
    upper(trim(valueRule)) = 'NEGATIVE' group by transactionType,valueRule;

set @negativeTransClause = '(' + @negativeTrans + ')'
     
if @negativeCount > 0
begin
	declare @sqlUpdate nvarchar(max)
	set @sqlUpdate = 'update #TempImportBatchData 
		set TotalTaxableAmount = -abs(TotalTaxableAmount), 
		GrossPrice = -abs(GrossPrice),           
		netprice = -abs(netprice), 
		vatlineamount = -abs(vatlineamount), 
		lineamountinclusivevat = -abs(lineamountinclusivevat), 
		linenetamount = -abs(linenetamount) 
		where batchid = @batchid and Tenantid = @tenantId and upper(trim(TransType)) in ('+ @negativeTransClause +')';

 EXEC sp_executesql @sqlUpdate , N'@tenantId int, @batchid int', @tenantId, @batchId;   
end
              
SELECT               
   -- @cols = STRING_AGG(CONCAT(T.MappedColumns, ' as ''', T.uploadedFields, ''''), ',')              
    @cols = STRING_AGG(CONCAT(REPLACE(T.MappedColumns, '''', ''''''), ' as ''', REPLACE(T.uploadedFields, '''', ''''''), ''''), ',')              
              
from              
  (SELECT                
    TOP 200000 MF.MappedColumns,              
    MF.uploadedFields,              
    MF.SequenceNumber,
	MF.IsCustomerMapped
 FROM               
  MappingConfiguration MC              
  CROSS APPLY OPENJSON(MC.MappingData)               
     WITH (              
       SequenceNumber int '$.sequenceNumber',              
       MappedColumns VARCHAR(100) '$.fieldForMapping',              
       uploadedFields VARCHAR(100) '$.uploadedFields[0]',              
       IsCustomerMapped bit '$.isCustomerMapped'              
       ) AS MF              
 WHERE              
  MC.TenantId = @tenantId AND              
  MC.Module = @module AND    
  (
  (MC.TransactionType <> 'Payment' and MF.IsCustomerMapped in (0,1))
  or
  (MC.TransactionType = 'Payment' and MF.IsCustomerMapped in (1))
  ) 
  and          
  MC.MappingType = @mappingType AND              
  MC.id = @MappingId AND      
  MC.IsActive = 1

 ORDER BY              
  MF.SequenceNumber ASC              
 ) T              
        
        
              
 SELECT @query = REPLACE(@query,'{statement}',  @cols)              
               
   print @query        
        
  EXEC sp_executesql @query    
  

  Drop table If Exists #TempImportBatchData
              
                   
END                 
                    
--//pending debit-purchase 
GO
