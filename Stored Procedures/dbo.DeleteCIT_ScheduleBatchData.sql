SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[DeleteCIT_ScheduleBatchData] (   @tenantid  int ) AS BEGIN   Declare @maxBatchNo Int   SELECT @maxBatchNo = MAX(BatchNo)  FROM CITScheduleBatchData   delete   from CITScheduleBatchData where TenantId=@tenantid  and BatchNo=@maxBatchNo   END
GO
