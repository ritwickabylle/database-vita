SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[get_errormessage_v2] (@uuid uniqueidentifier, @TenantId int )  
RETURNS varchar(max) AS  
BEGIN  
    DECLARE @combinedString VARCHAR(MAX)  
SELECT @combinedString =COALESCE(@combinedString + ';', '') + cast(ErrorType as varchar)+ '-'+ ErrorMessage   
from  
importstandardfiles_ErrorLists  with(nolock)
where uniqueIdentifier=@uuid and Status =0  and TenantId=@TenantId
RETURN @combinedString  
END;
GO
