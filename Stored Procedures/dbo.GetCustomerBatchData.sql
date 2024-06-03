SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                PROCEDURE [dbo].[GetCustomerBatchData]  
(  
@fileName nvarchar(max)='' ,
@tenantId int = null
)  
AS  
BEGIN  
  
select TOP 1 BatchId,FileName,TotalRecords,SuccessRecords,FailedRecords,Status from BatchMasterData 
WHERE FileName = SUBSTRING(@fileName, CHARINDEX('_', @fileName) + 1, LEN(@fileName)) and ISNULL(TenantId,0)=ISNULL(@tenantId,0) order by CreationTime desc  
   
END
GO
