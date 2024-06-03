SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[Dateconverter](@date nvarchar(max) null)
returns  nvarchar(max)
as
begin
declare @converteddate nvarchar(max)
if (@date is not null)
	begin
		if(select top 1 len(value) from string_split(@date,'-'))=2
		begin
			if(try_convert(datetime,@date,105) is null)
			begin
				
				set @converteddate=( select format(convert(datetime,@date,101),'dd-MM-yyyy'))
			end
			else 
			begin
				set @converteddate= (select format(convert(datetime,try_convert(datetime,@date,105),101),'dd-MM-yyyy'))
			end
		end
		else
		begin
			if(try_convert(datetime,@date,101) is null)
			begin
				--declare @converteddate nvarchar(max)
				set @converteddate=( select format(convert(datetime,@date,105),'dd-MM-yyyy'))
			end
			else 
			begin
				set @converteddate= (select format(convert(datetime,try_convert(datetime,@date,101),105),'dd-MM-yyyy'))
			end
		end
	end
else
	begin
		set @converteddate = null
	end
return @converteddate
end
GO
