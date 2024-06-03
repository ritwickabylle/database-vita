SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[CreateBatchIdImportBatchData] (              
     @dbName nvarchar(max)= null,  
     @tenantId nvarchar(max) = null,          
	  @fileName nvarchar(max)='',          
	  @fromDate datetime = null,             
	  @toDate datetime = null,
	  @totalRecords int = null
) AS BEGIN Declare @MaxBatchId int               
              
   Insert into Logs( [json],[date],[batchid])      
   Values('Batch Creation started', GetDate(),0)
              
Select               
  @MaxBatchId = isnull(max(batchId),0)               
  from               
  ImportBatchData;              
Declare @batchId int = @MaxBatchId + 1;   

INSERT INTO [dbo].[BatchData] (            
  [TenantId], [BatchId], [FileName],             
  [TotalRecords],             
  [SuccessRecords],              
  [FailedRecords],[Status], [Type],             
  [CreationTime], [IsDeleted], fromDate, toDate            
)             
VALUES             
  (            
    @tenantId,             
    @batchId,             
    @fileName,             
    @totalRecords,   
	@totalRecords, 
	0,
    'Unprocessed',             
    '',             
    GETDATE(),             
    0,            
 @fromDate,            
 @toDate            
  )  

select @batchId as BatchId  
  
   Insert into Logs( [json],[date],[batchid])      
   Values('Batch Creation end', GetDate(),@batchId)
      Insert into Logs( [json],[date],[batchid])      
   Values('Insertion Started', GetDate(),@batchId)
end
GO
