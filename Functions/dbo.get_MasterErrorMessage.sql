SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   FUNCTION [dbo].[get_MasterErrorMessage] (@uuid uniqueidentifier)
RETURNS varchar(max) AS
BEGIN
    DECLARE @combinedString VARCHAR(MAX)
SELECT @combinedString =COALESCE(@combinedString + ';', '') + cast(ErrorType as varchar)+ '-'+ ErrorMessage 
from
importMaster_ErrorLists
where uniqueIdentifier=@uuid and Status =0
RETURN @combinedString
END;
GO
