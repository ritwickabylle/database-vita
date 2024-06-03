SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[masterReport](      --exec masterReport 'VENDOR',24
@code nvarchar(max),  
@tenantid int  
)  
as   
begin  

 

 

 

if @code='TENANT'
begin
select t.Name as Name,  
v.ConstitutionType,v.BusinessCategory,  
case when @code like 'TENANT%' and (v.ParententityCountryCode is not null or len(v.ParententityCountryCode)>0) then v.ParententityCountryCode  
when @code not like 'TENANT%' then v.Nationality  
else v.Nationality end as Country,
v.ContactNumber,v.OrgType,v.DocumentNumber,v.VATReturnFillingFrequency,v.EmailID,v.ContactPerson,v.BusinessSupplies,v.SalesVATCategory,v.PurchaseVATCategory,v.BusinessPurchase  
from VI_ImportMasterFiles_Processed v with(nolock) 
left join AbpTenants t with(nolock) on v.TenantId=t.id and t.isactive=1
--left join customers c with(nolock) on c.tenantid=v.tenantid and c.isdeleted=0
--left join vendors ve with(nolock) on ve.tenantid=v.tenantid and ve.isdeleted=0
where upper(v.MasterType)=@code and v.tenantid=@tenantid and t.isactive=1
end
if @code='CUSTOMER'
begin
select distinct c.Name as Name,  
v.ConstitutionType,v.BusinessCategory,  
v.Nationality as Country,
v.ContactNumber,v.OrgType,v.DocumentNumber,v.VATReturnFillingFrequency,v.EmailID,v.ContactPerson,v.BusinessSupplies,v.SalesVATCategory,v.PurchaseVATCategory,v.BusinessPurchase  
from VI_ImportMasterFiles_Processed v with(nolock) 
--left join AbpTenants t with(nolock) on v.TenantId=t.id and t.isactive=1
left join customers c with(nolock) on c.tenantid=v.tenantid and c.isdeleted=0 and c.name=v.name
--left join vendors ve with(nolock) on ve.tenantid=v.tenantid and ve.isdeleted=0
where upper(v.MasterType)=@code and v.tenantid=@tenantid and c.tenantid=@tenantid
end
if @code='VENDOR'
begin
select distinct ve.Name as Name,  
v.ConstitutionType,v.BusinessCategory,  
  v.Nationality as Country,
v.ContactNumber,v.OrgType,v.DocumentNumber,v.VATReturnFillingFrequency,v.EmailID,v.ContactPerson,v.BusinessSupplies,v.SalesVATCategory,v.PurchaseVATCategory,v.BusinessPurchase  
from VI_ImportMasterFiles_Processed v with(nolock) 
--left join AbpTenants t with(nolock) on v.TenantId=t.id and t.isactive=1
--left join customers c with(nolock) on c.tenantid=v.tenantid and c.isdeleted=0
left join vendors ve with(nolock) on ve.tenantid=v.tenantid and ve.isdeleted=0 and v.name=ve.name
where upper(v.MasterType)=@code and v.tenantid=@tenantid and ve.tenantid=@tenantid
end
end
GO
