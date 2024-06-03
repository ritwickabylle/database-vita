SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    PROCEDURE [dbo].[GetSalesBatchDataId]        
(        
@batchid nvarchar(max)='8099' ,      
@tenantId int = 148      
)        
AS        
BEGIN        
        
select format(CreationTime,'dd-MM-yyyy') as CreatedDate,BatchId,FileName,TotalRecords,SuccessRecords,FailedRecords,Status,Type from BatchData  where BatchId = @batchid and ISNULL(TenantId,0)=ISNULL(@tenantId,0) order by CreationTime desc        
         
END
GO
