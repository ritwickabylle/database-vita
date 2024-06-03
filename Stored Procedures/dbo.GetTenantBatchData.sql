SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create                PROCEDURE [dbo].[GetTenantBatchData]  
(  
@fileName nvarchar(max)='' ,
@tenantId int = null
)  
AS  
BEGIN  
  
select BatchId,FileName,TotalRecords,SuccessRecords,FailedRecords,Status from BatchMasterData  where FileName = @fileName and ISNULL(TenantId,0)=ISNULL(@tenantId,0) order by CreationTime desc  
   
END
GO
