SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE PROCEDURE [dbo].[GetTenantBankDetails]     
(    
@currencycode nvarchar(max),    
@tenantid int=null    
)    
AS    
BEGIN    
if((select count(*) from TenantBankDetail where TenantId=@tenantid and CurrencyCode=@currencycode)>0)  
begin  
select    
tbd.AccountName,    
tbd.AccountNumber,    
tbd.BankName,    
tbd.BranchAddress,    
tbd.BranchName,    
tbd.IBAN,    
tbd.SwiftCode,  
CONCAT('Account Name: ', tbd.AccountName, ' ',  
           'Account Number: ', tbd.AccountNumber, ' ',  
           'Bank Name: ', tbd.BankName, ' ',  
           'Branch Address: ', tbd.BranchAddress, ' ',  
           'Branch Name: ', tbd.BranchName, ' ',  
           'IBAN: ', tbd.IBAN, ' ',  
           'SWIFT Code: ', tbd.SwiftCode, ' '
           ) AS bankinfo,  
tbd.TenantId from TenantBankDetail tbd where TenantId=@tenantid and currencycode=@currencycode    
end  
else  
begin  
select    
tbd.AccountName,    
tbd.AccountNumber,    
tbd.BankName,    
tbd.BranchAddress,    
tbd.BranchName,    
tbd.IBAN,    
tbd.SwiftCode,   
CONCAT('Account Name: ', tbd.AccountName, ' ',  
           'Account Number: ', tbd.AccountNumber, ' ',  
           'Bank Name: ', tbd.BankName, ' ',  
           'Branch Address: ', tbd.BranchAddress, ' ',  
           'Branch Name: ', tbd.BranchName, ' ',  
           'IBAN: ', tbd.IBAN, ' ',  
           'SWIFT Code: ', tbd.SwiftCode, ' '
           ) AS bankinfo,  
tbd.TenantId from TenantBankDetail tbd where TenantId=@tenantid and IsDefault=1   
end  
end
GO
