SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create     procedure [dbo].[DeletetaxcodetoGlcode] ---  exec DeletetaxcodetoGlcode
(
	@json nvarchar(Max)='{"taX_CODE":"10101","gL_CODE":"895135","gL_NAME":"Revenue - Intercompany Stock Transfer","gL_GROUP":"Net Sales"}',
	@tenantid int=148 
)
as
begin
declare @taxcode nvarchar(100)
declare @glcode nvarchar(100)

SELECT 
    @taxcode = taxcode,
    @glcode = glcode
	FROM OPENJSON(@json)                              
WITH (
    taxcode NVARCHAR(100) '$.taX_CODE',
    glcode NVARCHAR(100) '$.gL_CODE',
    glname NVARCHAR(100) '$.gL_NAME'
);

delete from CIT_GLTaxCodeMapping where tenantid=@tenantid and taxcode=@taxcode and GLCode=@glcode
 
 end

 select * from CIT_GLTaxCodeMapping
GO
