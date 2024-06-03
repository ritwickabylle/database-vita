SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- exec [GetCustomerById] 113, 2
create             Procedure [dbo].[GetVendorById]            
(            
	@Id INT,      
	@tenantId INT      
)            
as            
begin        

	select c.id,c.TenantId,Name,Nationality,ContactPerson,ContactNumber,            
	isnull(BuildingNo,'') BuildingNo, isnull(AdditionalNo,'') AdditionalNo, isnull(Street,'') Street, isnull(AdditionalStreet,'') AdditionalStreet,
	isnull(Neighbourhood,'') Neighbourhood, isnull(city,'') city, isnull(State,'') State, isnull(PostalCode,'')  PostalCode, isnull(EmailID,'') EmailID, isnull(cd.DocumentNumber,'') DocumentNumber        
	from Vendors c            
	--inner join CustomerAddress ca on c.id=ca.CustomerID and c.TenantId=ca.TenantId
	left outer join VendorAddress ca on c.id=ca.VendorID and c.TenantId=ca.TenantId    
	--inner join CustomerDocuments cd on c.id=cd.CustomerID and c.TenantId=cd.TenantId  
	left outer join VendorDocuments cd on c.id=cd.VendorID and c.TenantId=cd.TenantId    
	where c.id=@Id and c.TenantId=@tenantId    
	--and cd.DocumentTypeCode = 'VAT'  

end
GO
