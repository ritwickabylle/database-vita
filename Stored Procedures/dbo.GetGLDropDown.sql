SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE          PROCEDURE [dbo].[GetGLDropDown]    -- exec GetGLDropDown 172, '1/1/2023','12/31/2023'  
(@tenantId int=172,  
@fromDate datetime = '2024-01-01',  
@toDate datetime =  '2024-12-31')  
AS  
BEGIN  
	SELECT GLName from CIT_TrialBalanceTransactions WHERE taxcode in--(10508,10903,10904,11304)
	(SELECT taxcode from CIT_GLTaxCodeMaster where ScheduleNo='5')
	and tenantid=@tenantId and FinancialStartDate=@fromDate and FinancialEndDate=@toDate;
END
GO
