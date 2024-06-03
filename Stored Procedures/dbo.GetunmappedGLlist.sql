SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     Procedure [dbo].[GetunmappedGLlist]   --  EXEC GetunmappedGLlist '10501',148
(    
@taxcode nvarchar(max)='null',    
@tenantid int    
)    
as    
begin IF( @taxcode <> 'null')    
  begin 
select distinct
c.GLCode as gl_code,
c.GLName as gl_name,
c.GLGroup as gl_Group,
s.MappedTaxCodes as Mapped_Tax_Codes
from CIT_GLMaster c 
left join 
(SELECT
    GLCode,
    STRING_AGG(taxcode, ',') AS MappedTaxCodes
FROM (
    SELECT DISTINCT GLCode, taxcode
    FROM CIT_GLTaxCodeMapping
    WHERE tenantid = @tenantid
) AS subquery
GROUP BY GLCode)s on s.GLCode = c.glcode 
WHERE c.GLCode NOT IN (select GLCode  from CIT_GLTaxCodeMapping where tenantid=@tenantid and taxcode=@taxcode  )  
and c.TenantId=@tenantid

end    
 else    
  begin    
   select distinct GLCode as gl_code,GLName as gl_name,GLGroup as gl_Group from CIT_GLMaster WHERE GLCode NOT IN (select  GLCode  from CIT_GLTaxCodeMapping where tenantid=@tenantid)   
   and TenantId=@tenantid
  end    
end
GO
