SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[GetMasterTypeFromBatchId]( @batchId int)
as
begin
select top 1 ISNULL(Type,'') as masterType from BatchMasterData where BatchId=@batchId
end
GO
