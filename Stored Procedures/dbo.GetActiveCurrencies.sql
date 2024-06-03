SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    procedure [dbo].[GetActiveCurrencies]  --exec GetActiveCurrencies 'MF' 
(@alpha3code as nvarchar(10)) 
AS  
BEGIN     
--SELECT DISTINCT AlphabeticCode,NumericCode,Entity from activecurrency where IsActive=1 and Entity IN (@alpha3code,'SA','US') ;  
SELECT AlphabeticCode, NumericCode, Entity
FROM (
    SELECT AlphabeticCode, NumericCode, Entity,
    ROW_NUMBER() OVER (PARTITION BY AlphabeticCode ORDER BY AlphabeticCode) AS RowNum
    FROM activecurrency
    WHERE IsActive = 1 AND AlphabeticCode IS NOT NULL AND LEN(AlphabeticCode)>0
) AS SubQuery
WHERE RowNum = 1;
END
GO
