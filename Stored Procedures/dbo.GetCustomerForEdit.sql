SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE        Procedure [dbo].[GetCustomerForEdit]       --   exec [GetCustomerForEdit] 12928,148   
(            
@id int,        
@tenantid int        
)            
as            
begin            
select *,cd.UniqueIdentifier as docunique,format(cd.DoumentDate,'dd-MM-yyyy') as DocumentDate            
from (select * from customers where tenantid=@tenantid and Id=@id )c            
inner join (select * from CustomerAddress where IsDeleted=0 )ca  on c.id=ca.CustomerID and c.TenantId=ca.TenantId     
left join (select * from CustomerDocuments where IsDeleted=0) cd on c.id=cd.CustomerID and c.TenantId=cd.TenantId     
left join (select * from CustomerTaxDetails where IsDeleted=0)ct on c.id=ct.CustomerID and c.TenantId=ct.TenantId   
left join (select * from CustomerForeignEntity where IsDeleted=0) cf on c.id=cf.CustomerID and c.TenantId=cf.TenantId  
end


GO
