SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[getPurchaseSuggestions]
(
@irrno int,
@tenantId int
)
as
begin
select Id,IssueDate from PurchaseEntry
where id LIKE concat('%',@irrno,'%') and TenantId=@tenantId
end
GO
