SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[InsertIntoLogs]
@text nvarchar(max),
@date nvarchar(max),
@tenantid int=null
as
begin
insert into logs(json,date,batchid)values(@text,@date,@tenantid)
end
GO
