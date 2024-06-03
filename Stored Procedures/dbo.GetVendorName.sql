SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create        Procedure [dbo].[GetVendorName]      
(      
@Name nvarchar(max),    
@tenantId int=null)      
as        
Begin        
select id,name,TenantType,ConstitutionType,Nationality,ContactNumber from  vendors      
where name lIKE concat('%',@Name,'%')  and  TenantId=@tenantId    
end
GO
