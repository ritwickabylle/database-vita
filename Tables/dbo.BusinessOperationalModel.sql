CREATE TABLE [dbo].[BusinessOperationalModel]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BusinessOperationalModel] ADD CONSTRAINT [PK_BusinessOperationalModel] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
