CREATE TABLE [dbo].[TaxSubCategory]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TaxSubCategory] ADD CONSTRAINT [PK_TaxSubCategory] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
