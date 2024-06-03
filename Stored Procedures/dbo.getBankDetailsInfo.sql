SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   procedure [dbo].[getBankDetailsInfo] 
(  
@tenantid int  
) 
AS
BEGIN

Select 
       [UniqueIdentifier]
      ,[AccountName]
      ,[AccountNumber]
      ,[IBAN]
      ,[BankName]
      ,[SwiftCode]
      ,[IsActive]
	  ,[BranchName]
	  ,[BranchAddress]
	  ,[CurrencyCode]
      ,[IsDefault]

from TenantBankDetail Where TenantId = @tenantid and IsActive = 1

END
GO
