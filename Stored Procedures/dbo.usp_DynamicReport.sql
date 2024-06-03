SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[usp_DynamicReport]
@SchemaName VARCHAR(128),
@TableName VARCHAR(128),
@ColumnList VARCHAR(MAX)

AS 
BEGIN 


DECLARE @ColumnNames VARCHAR(MAX) 
DECLARE @ColumnNamesVAR VARCHAR(MAX)

--drop ##Temp_Data Table
IF OBJECT_ID('tempdb..##Temp_Data') IS NOT NULL
    DROP TABLE ##Temp_Data
	
	
	--drop ##Temp_Data_Final Table
IF OBJECT_ID('tempdb..##Temp_Data_Final') IS NOT NULL
    DROP TABLE ##Temp_Data_Final

--drop #Temp_Columns Table
IF OBJECT_ID('tempdb..#Temp_Columns') IS NOT NULL
    DROP TABLE #Temp_Columns

Create table #ColumnList (Data NVARCHAR(MAX))
insert into #ColumnList values (@ColumnList)

--convert all column list to VARCHAR(1000) for unpivot

;with Cte_ColumnList as (
SELECT 
'['+LTRIM(RTRIM(m.n.value('.[1]','varchar(8000)')))+']'  AS ColumnList
FROM
(
SELECT CAST('<XMLRoot><RowData>' + REPLACE(Data,',','</RowData><RowData>') 
+ '</RowData></XMLRoot>' AS XML) AS x
FROM   #ColumnList
)t
CROSS APPLY x.nodes('/XMLRoot/RowData')m(n))
,CTE_ColumnListVarchar  as
(Select 'CAST('+ColumnList+' as VARCHAR(1000)) AS '+ColumnList AS ColumnListVAR,ColumnList from Cte_ColumnList)

SELECT @ColumnNamesVAR = COALESCE(@ColumnNamesVAR + ', ', '') + ColumnListVAR,
@ColumnNames = COALESCE(@ColumnNames + ', ', '') + ColumnList 
FROM  CTE_ColumnListVarchar

--Insert data into ##Temp_Data Table
DECLARE @SQL NVARCHAR(MAX)
DECLARE @TempTbleSQL NVARCHAR(MAX)
SET @TempTbleSQL='Select ROW_NUMBER() 
        OVER (order by (Select 1)) AS R,'+@ColumnNames +' into ##Temp_Data from ['+@SchemaName+'].['+@TableName+']'

--Print @TempTbleSQL
EXEC(@TempTbleSQL)

SET @SQL='

select 
R,columnname,value into ##Temp_Data_Final from 
(select R,'+@ColumnNamesVAR+' from ##Temp_Data )u
unpivot
(value for columnname  in ('+@ColumnNames+'))v'
--Print @SQL
EXEC(@SQL)

Select * From ##Temp_Data_Final

END
GO
