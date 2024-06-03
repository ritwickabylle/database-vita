SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[getGlDatabyTaxcode]      
(      
 @taxcode nvarchar(max)='10513',      
 @tenantid nvarchar(max)=172      
)      
as      
begin      
if(@taxcode not like 'All')  
begin  
  select distinct TaxCode AS TAX_CODE,glt.GLCode as GL_CODE,glt.GLName AS GL_NAME,glm.GLGroup AS GL_GROUP     
  from CIT_GLTaxCodeMapping glt     
  inner join CIT_GLMaster glm on glm.GLCode=glt.GLCode    
  where glt.tenantid=@tenantid and taxcode=@taxcode     
    order by TaxCode  
  end  
  else  
  begin  
    select  distinct TaxCode AS TAX_CODE,glt.GLCode as GL_CODE,glt.GLName AS GL_NAME,glm.GLGroup AS GL_GROUP     
  from CIT_GLTaxCodeMapping glt     
  inner join CIT_GLMaster glm on glm.GLCode=glt.GLCode    
  where glt.tenantid=@tenantid    and taxcode in (select distinct TaxCode CIT_GLTaxCodeMapping)  
  order by TaxCode   
  end  
  end
GO
