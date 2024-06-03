SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        procedure [dbo].[GetMasterBatchData]  
(  
@fromdate datetime,  
@todate datetime,
@tenantId int=null
)  
AS  
SET NOCOUNT ON
BEGIN  
select BatchId,FileName,TotalRecords,SuccessRecords,FailedRecords,Status,CreationTime as CreatedDate from BatchMasterData with (nolock)  
where CAST(CreationTime AS DATE)  BETWEEN cast(@fromdate as date) AND cast(@todate as date) 
and ISNULL(TenantId,0)=ISNULL(@tenantId,0) order by CreationTime desc  
END
GO
