SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
create   procedure [dbo].[getNaturofServiceList](   --getNaturofServiceList 7886,148  
@tenantid int  
)as  
begin  
select Name from natureofservices where tenantid is null  
end
GO
