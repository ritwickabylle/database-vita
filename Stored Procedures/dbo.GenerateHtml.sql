SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
                                    
create     procedure [dbo].[GenerateHtml]                                                 
(@tenantId int null=127,                         
@isqrCode bit=0,                        
@reportName nvarchar(100)='Sales',                        
@json nvarchar(max)=null)        
as    
begin

DECLARE @tenancyname NVARCHAR(MAX)

SET @tenancyname = (SELECT name FROM AbpTenants WHERE id = @tenantId)

 IF (UPPER(@tenancyname) LIKE 'SAUDI ARABIAN GLASS%')
BEGIN
    EXEC GenerateHtmlSAGCO @tenantId, @isqrCode, @reportName, @json
END
ELSE
BEGIN
    EXEC GenerateHtmlUnicore @tenantId, @isqrCode, @reportName, @json
END

end
GO
