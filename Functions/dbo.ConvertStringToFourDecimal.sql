SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create     function [dbo].[ConvertStringToFourDecimal](@input nvarchar(max)) 
returns DECIMAL(18, 4)
as
begin
return PARSE(@input AS DECIMAL(18, 4) USING 'en-US')
end
GO
