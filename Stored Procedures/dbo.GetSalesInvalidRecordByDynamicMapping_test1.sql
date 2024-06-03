SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetSalesInvalidRecordByDynamicMapping_test1]           
(          
	@batchId int = null ,        
	@tenantId int = null        
)          
AS          
BEGIN   
Set @batchId = 6858
declare @type nvarchar(20)      
select @type=type from batchdata where batchid=@batchId
 

 DECLARE @cols nvarchar(max),
        @query nvarchar(max),
		@module nvarchar(50) = 'VAT',
		@mappingType nvarchar(50) = 'FieldMapping',
		@transactionType nvarchar(50) = @type
		


SET @query = 'SELECT {statement} FROM [dbo].[ImportBatchData] 
				where BatchId = '+ cast(@batchId as varchar(10)) + ' and TenantId='+ cast(@tenantId as varchar(10))+'  
				and dbo.get_errormessage(UniqueIdentifier) <> ''''  
				 order by CreationTime desc' --TODO : WRITE the full SQL Statement


Declare @MappingId int
select @MappingId =  Id
FROM MappingConfiguration MT
	WHERE
		MT.TenantId = @tenantId AND
		MT.Module = @module AND
		MT.TransactionType = @transactionType AND
		MT.MappingType = @mappingType
order by Id desc

SELECT 
	   @cols = STRING_AGG(T.MappedColumns,',') 
from
  (SELECT		
		  TOP 200000 MF.MappedColumns,
		  MF.SequenceNumber
	FROM 
		MappingConfiguration MC
		CROSS APPLY OPENJSON(MC.MappingData) 
					WITH (
							SequenceNumber int '$.sequenceNumber',
							MappedColumns VARCHAR(100) '$.fieldForMapping',
							IsCustomerMapped bit '$.isCustomerMapped'
						 ) AS MF
	WHERE
		MC.TenantId = @tenantId AND
		MC.Module = @module AND
		MC.TransactionType = @transactionType AND
		MC.MappingType = @mappingType 
	ORDER BY
		MF.SequenceNumber ASC
	) T

	SELECT @query = REPLACE(@query,'{statement}',  @cols)
	

  EXEC sp_executesql @query

     
END   
      
--//pending debit-purchase 
GO
