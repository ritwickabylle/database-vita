SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
              
CREATE      procedure [dbo].[DeleteFileUploadRecord]  --  exec DeleteFileUploadRecord 7023,148                      
(                          
@batchId int,               
@tenantId int    
)                          
AS                          
BEGIN                          
      DELETE FROM BatchData where TenantId = @tenantId AND BatchId = @batchId    
   DELETE FROM ImportBatchData Where TenantId = @tenantId AND BatchId = @batchId  
END
GO
