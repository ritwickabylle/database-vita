SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[getBankDetails]   --exec getBankDetails 131  
(  
@tenantid int  
)  
as  
begin  
  
select * into #bankinfo from(select AccountName as AccountName,AccountNumber as AccountNumber,BankName as BankName,IBAN as IBAN,SwiftCode as SwiftCode from TenantBankDetail where TenantId=@tenantid ) AS b;  
  
select concat('Bank Name:',BankName,' Account Name:',AccountName,' Account Number:',AccountNumber,' IBAN:', IBAN,' SwiftCode:',SwiftCode) as bank_information from #bankinfo  
  
--select * into #bankinfo1 from(select concat('Account Name:',AccountName) as bank_information from #bankinfo  
--union  
--select concat('Account Number:',AccountNumber) as bank_information from #bankinfo  
--union  
--select concat('Bank Name:',BankName) as bank_information from #bankinfo  
--union  
--select concat('IBAN:', IBAN) as bank_information from #bankinfo  
--union  
--select concat('SwiftCode:',SwiftCode) as bank_information from #bankinfo) as hh;  
  
--select bank_information from #bankinfo1  
  
end
GO
