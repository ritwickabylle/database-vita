SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE          PROCEDURE [dbo].[OverrideErrorsMasters]         -- EXEC overrideerrorsMasters 'F92F29F0-5D22-433F-B9AE-7E146FE7F514'

--Create table Masteroverride(uniqueidentifier uniqueidentifier,tenantid int, batchid int,errortype  bigint,  creationtime datetime2)
  --SELECT * FROM importmaster_ErrorLists WHERE BATCHID = 228
  -- select * from masteroverride
--@uuid uniqueidentifier
@batchId int,
@json nvarchar(max)

AS       
declare @batchno int      

begin

insert into logs (json,date,batchid) values(@json,GETDATE(),@batchId)

 insert into masteroverride(uniqueidentifier,tenantid,batchid,errortype,creationtime,ErrorMessage) select uniqueIdentifier,tenantid,batchid,errortype,getdate() ,ErrorMessage
 from importmaster_ErrorLists where uniqueIdentifier in (
 select uuid from 
 openjson(@json) with
( [uuid] nvarchar(max) '$."uniqueId"'
))


--set @batchno = (select batchid from ImportMasterBatchData where UniqueIdentifier = @uuid) 
 
 exec overrideMastersRefresh null,@batchId

end
GO
