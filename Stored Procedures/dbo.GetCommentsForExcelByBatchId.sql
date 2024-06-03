SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          PROCEDURE [dbo].[GetCommentsForExcelByBatchId]            
(            
@batchId int ,          
@tenantId int = null          
)            
AS            
BEGIN         
declare @type nvarchar(20)      
select @type=type from batchdata where batchid=@batchId
select @tenantId = tenantId from batchdata where batchid=@batchId


 DECLARE @cols nvarchar(max),
        @query nvarchar(max),
		@module nvarchar(50) = 'VAT',
		@mappingType nvarchar(50) = 'FieldMapping',
		@transactionType nvarchar(50) = @type
		

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
	    DF.Helptext as 'comments'
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
	inner Join DynamicFileMapping DF
	on DF.Field = T.MappedColumns
	where 
		DF.Module = @module AND
		DF.TransactionType = @transactionType AND
		DF.Country = 'SA'




end
GO
