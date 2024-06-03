SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create     FUNCTION [dbo].[fnDecimalToWords](@Number AS DECIMAL(18, 2))
RETURNS VARCHAR(1024)
AS
BEGIN
    DECLARE @WholePart BIGINT
    DECLARE @FractionalPart DECIMAL(18, 2)
    SET @WholePart = FLOOR(@Number)
    SET @FractionalPart = (@Number - @WholePart) * 100  -- Multiply by 100 to get two decimal places

    DECLARE @English VARCHAR(1024)

    -- Handle the whole part
    SET @English = dbo.fnNumberToWords(@WholePart)
    SET @English = RTRIM(@English)
    
    -- Handle the fractional part if it exists
    IF @FractionalPart > 0
    BEGIN
        SET @English = @English + ' point ' + dbo.fnNumberToWords(CAST(@FractionalPart AS BIGINT))
    END

    RETURN @English
END
GO
