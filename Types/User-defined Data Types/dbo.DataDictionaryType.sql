CREATE TYPE [dbo].[DataDictionaryType] AS TABLE
(
[key] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [int] NULL
)
GO
