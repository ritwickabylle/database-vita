SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE            Procedure [dbo].[GetVendorData]        
(      
@tenantId int=null      
)      
AS          
BEGIN          
SELECT id,
       name,
       TenantType,
       ConstitutionType,
       Nationality,
       ContactNumber
FROM (
    SELECT id,
           name,
           TenantType,
           ConstitutionType,
           Nationality,
           ContactNumber,
           ROW_NUMBER() OVER (PARTITION BY name, TenantType, ConstitutionType, Nationality, ContactNumber ORDER BY id DESC) AS row_num
    FROM vendors
    WHERE TenantId = @tenantId
) AS sub
WHERE row_num = 1;  
end
GO
