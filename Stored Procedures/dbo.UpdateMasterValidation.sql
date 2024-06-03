SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[UpdateMasterValidation]    --exec UpdateMasterValidation null,55
(
@status nvarchar(max) = null,
@tenantid int
)
as
begin
if exists(select * from ValidationStatus where TenantId=@tenantid)
begin
if(@status is not null)
begin
  if (@status = 'Active')
  begin
	update ValidationStatus set ValidStat = 1 where TenantId = @tenantid
  end
  else
  begin
	update ValidationStatus set ValidStat = 0 where TenantId = @tenantid
  end
end
select ValidStat as ValidStat from ValidationStatus where TenantId = @tenantid
end
else
insert into ValidationStatus
select case when @status = 'Active' then 1 else 0 end , @tenantid

select ValidStat as ValidStat from ValidationStatus where TenantId = @tenantid
end
GO
