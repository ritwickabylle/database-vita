SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[CheckIfEmailExists]
(
@email nvarchar(200) ,
@checkInAllTenants char(1) = 1
)
as
begin
select count(*) as count from ABpUsers with(nolock) where EmailAddress=@email
end
GO
