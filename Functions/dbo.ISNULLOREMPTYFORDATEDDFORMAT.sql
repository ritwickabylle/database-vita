SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[ISNULLOREMPTYFORDATEDDFORMAT]  
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
SET @output =TRY_CONVERT(DATETIME, @value,103)    
return @output  
END
GO
