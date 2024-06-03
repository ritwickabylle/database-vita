SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[MaptaxcodetoGlcode]
(
	@json nvarchar(max)=N'[{"taxcode":"10101","glcode":"41051003","glname":"Rent-EmployeeAccomodation"},{"taxcode":"10101","glcode":"41051003","glname":"Rent-EmployeeAccomodation"}]',
	@tenantid int=148 ,
	@fromdate DATETIME ='2024-01-01',
	@todate DATETIME ='2024-12-31'
)
as
begin
INSERT INTO CIT_GLTaxCodeMapping (tenantid,UniqueIdentifier,glcode, glname, taxcode,CreationTime,isActive,FinancialStartDate,FinancialEndDate)
SELECT 
	@tenantid,
	newid(),
    glcode = glcode,
    glname = glname,
    taxcode = taxcode,
	GETDATE(),
	1,
	@fromdate,
	@todate
FROM OPENJSON(@json)                              
WITH (
    taxcode NVARCHAR(100) '$.taxcode',
    glcode NVARCHAR(100) '$.glcode',
    glname NVARCHAR(100) '$.glname'
);
 
 end
GO
