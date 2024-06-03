SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[GetCountriesList]    
as     
begin      
select DISTINCT Name,AlphaCode from country where IsActive=1  ORDER BY Name asc;      
end
GO
