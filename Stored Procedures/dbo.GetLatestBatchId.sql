SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[GetLatestBatchId](
@tenantId int =127
)    
as     
begin    
select isnull(max(batchId),0) as BatchId from BatchData where TenantId=@tenantId     
end
GO
