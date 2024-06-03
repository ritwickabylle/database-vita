SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
create      PROCEDURE [dbo].[GetCITGLMaster]    -- exec [GetCITGLMaster] 148, '1/1/2023','12/31/2023'  
(@tenantId int,  
@fromDate datetime = null,  
@toDate datetime = null)  
AS  
BEGIN  
 SELECT   
 GLM.GLCode as 'GL Code',  
 GLM.GLName as 'GL Name',  
 GLM.GLGroup as 'GL Group',  
  GLT.TaxCode as 'TaxCode' FROM [dbo].[CIT_GLMaster] GLM
  LEFT JOIN  CIT_GLTaxCodeMapping GLT on GLT.GLName = GLM.GLName AND GLT.GLCode = GLM.GLCode AND GLT.TenantId = @tenantId
  where GLM.isActive = 1 and GLM.Tenantid = @tenantId
  and TRY_CAST(GLM.FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)    
  and TRY_CAST(GLM.FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE);  
END
GO
