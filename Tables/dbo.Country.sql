CREATE TABLE [dbo].[Country]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlphaCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumericCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alpha3Code] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Country] ADD CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
