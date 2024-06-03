SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     procedure [dbo].[getbuyertype]  
as  
begin  
select top 1 Description  from OrganisationType where IsActive = 1 
end
GO
