SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create      procedure [dbo].[CheckIfvatExists]  
(  
@vat nvarchar(200) ,  
@checkInAllTenants char(1) = 1  
)  
as  
begin  
select count(*) as count from TenantBasicDetails with(nolock) where VATID=@vat  
end
GO
