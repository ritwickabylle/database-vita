CREATE TABLE [dbo].[CountryAlias]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[AliasName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlphaCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CountryAlias] ADD CONSTRAINT [PK_CountryAlias] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
