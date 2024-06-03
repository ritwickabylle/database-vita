SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 

create   function [dbo].[ValidateIfStringIsNullOrEmpty](@input nvarchar(max)) 
returns bit
as
begin
set @input = isnull(@input,'')
if(trim(@input)='')
begin
return 0
end
return 1
end
GO
