SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ReplaceHtmlDecimal](@html nvarchar(max),@find nvarchar(max),@value decimal(15,2)) 
returns  nvarchar(max)
as
begin
declare @replaced nvarchar(max)= ( SELECT
    REPLACE(@html, @find, FORMAT(ISNULL(@value, 0), '#,0.00')));
RETURN @replaced
END
GO
