SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   function [dbo].[ConvertStringToDecimal](@input nvarchar(max)) 
returns DECIMAL(18, 2)
as
begin
return PARSE(@input AS DECIMAL(18, 2) USING 'en-US')
end
GO
