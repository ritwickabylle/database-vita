SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[ISNULLOREMPTYFORDATE]  
(     
    @value NVARCHAR(max)  
)  
RETURNS NVARCHAR(MAX)  
AS  
BEGIN   
Declare @output NVARCHAR(MAX)  
  
IF (@value IS NULL)  
BEGIN  
   SET @output =null  
END  
ELSE  
BEGIN  
    IF (LEN(LTRIM(@value)) = 0)  
    BEGIN   
        SET @output =null  
    END   
END  
If(ISDATE(@value))=1  
begin  
SET @output =CONVERT(DATETIME, @value)  
end  
else  
begin  
SET @output =null  
end  
return @output  
END
GO
