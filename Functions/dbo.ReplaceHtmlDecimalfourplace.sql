SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create   function [dbo].[ReplaceHtmlDecimalfourplace](@html nvarchar(max),@find nvarchar(max),@value decimal(18,4)) 
returns  nvarchar(max)
as
begin
declare @replaced nvarchar(max)= ( SELECT
    REPLACE(@html, @find, FORMAT(ISNULL(@value, 0), '#,0.0000')));
RETURN @replaced
END
GO
