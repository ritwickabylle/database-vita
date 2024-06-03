SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[ConvertAndReplaceStringToDecimal](@stringValue NVARCHAR(MAX))
RETURNS DECIMAL(18, 4)
AS
BEGIN
    DECLARE @charactersToRemove NVARCHAR(MAX);
    DECLARE @cleanedValue NVARCHAR(MAX);
    DECLARE @charIndex INT;
    DECLARE @charToRemove NVARCHAR(1);

    -- Define characters to remove
    SET @charactersToRemove = ',()%';

    -- Initialize cleaned value
    SET @cleanedValue = ISNULL(@stringValue, '');

    -- If the input string is empty, return NULL
    IF LEN(@cleanedValue) = 0
    BEGIN
        RETURN 0;
    END;

    -- Remove characters from the string
    SET @charIndex = 1;
    WHILE @charIndex <= LEN(@charactersToRemove)
    BEGIN
        SET @charToRemove = SUBSTRING(@charactersToRemove, @charIndex, 1);
        SET @cleanedValue = REPLACE(@cleanedValue, @charToRemove, '');
        SET @charIndex = @charIndex + 1;
    END;

    -- Remove percentage sign separately
    SET @cleanedValue = REPLACE(@cleanedValue, '%', '');
    -- Trim leading and trailing spaces
    SET @cleanedValue = LTRIM(RTRIM(@cleanedValue));

    -- Attempt to convert the cleaned string to decimal
    IF ISNUMERIC(@cleanedValue) = 1
    BEGIN
        RETURN CONVERT(DECIMAL(18, 4), @cleanedValue);
    END
    ELSE
    BEGIN
        RETURN 0; -- Return NULL if conversion fails
    END;
	return 0
END;
GO
