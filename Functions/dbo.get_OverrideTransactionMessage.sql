SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create     FUNCTION [dbo].[get_OverrideTransactionMessage] (@uuid uniqueidentifier)
RETURNS varchar(max) AS
BEGIN
    DECLARE @combinedString VARCHAR(MAX)
SELECT @combinedString =COALESCE(@combinedString + ';', '') + errormsg 
from
Transactionoverride
where uniqueIdentifier=@uuid 
RETURN @combinedString
END;
GO
