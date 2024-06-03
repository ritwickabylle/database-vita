SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OverrideErrors]         -- EXEC overrideerrors 454,'dd4c2fa3-739f-4214-a523-b5044f300a1a'

@batchId int,
@json nvarchar(max)

AS       
declare @batchno int      

begin

--insert into logs(json,date,batchid) values('List123 '+@json,getdate(),@batchid)

--select * from logs where batchid=454 order by id desc

 insert into Transactionoverride(uniqueidentifier,tenantid,batchid,errortype,creationtime,errormsg) select uniqueIdentifier,tenantid,batchid,errortype,getdate() ,ErrorMessage
 from importstandardfiles_ErrorLists  where uniqueIdentifier in (
 select uuid from 
 openjson(@json) with
( [uuid] nvarchar(max) '$."uniqueId"'
))

--insert into logs(json,date,batchid) values('1',getdate(),@batchid)

exec overrideTransactionsRefresh null,@batchId

end
GO
