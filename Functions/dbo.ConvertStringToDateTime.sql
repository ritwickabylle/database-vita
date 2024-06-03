SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


 

create   function [dbo].[ConvertStringToDateTime](@input nvarchar(max)) 
returns datetime
as
begin
return Parse(@input as datetime)
end
GO
