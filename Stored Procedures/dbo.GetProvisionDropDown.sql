SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE        PROCEDURE [dbo].[GetProvisionDropDown]    -- exec GetProvisionDropDown 172, '1/1/2023','12/31/2023'  
(@tenantId int=172,  
@fromDate datetime = '2024-01-01',  
@toDate datetime =  '2024-12-31')  
AS  
BEGIN  
	SELECT ProvisionName from cit_schedule5  WHERE ProvisionName NOT IN
	(SELECT GLNAME FROM CIT_GLMaster WHERE tenantid=@tenantId and FinancialStartDate=@fromDate and FinancialEndDate=@toDate)
	AND  ProvisionName NOT IN ( select GLNameAlias from GLNameAlias WHERE tenantid=@tenantId and finstartdate=@fromdate and FinEndDate=@todate)
	AND tenantid=@tenantid and financialstartdate=@fromdate and financialenddate=@todate

END
GO
