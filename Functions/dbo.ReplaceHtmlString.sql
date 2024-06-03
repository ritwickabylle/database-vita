SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create function [dbo].[ReplaceHtmlString](@html nvarchar(max),@find nvarchar(max),@value nvarchar(max)) 
returns  nvarchar(max)
as
begin
declare @replaced nvarchar(max)= ( SELECT
    REPLACE(@html, @find, ISNULL(@value, '')));
RETURN @replaced
END
GO
