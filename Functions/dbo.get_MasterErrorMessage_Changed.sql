SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      FUNCTION [dbo].[get_MasterErrorMessage_Changed] (@uuid UNIQUEIDENTIFIER)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @combinedString VARCHAR(MAX)
    SELECT DISTINCT @combinedString = COALESCE(@combinedString + ';', '') + CAST(ErrorType AS VARCHAR) + '-' + ErrorMessage
    FROM importMaster_ErrorLists
    WHERE uniqueIdentifier = @uuid AND Status = 0
    RETURN @combinedString
END;
GO
