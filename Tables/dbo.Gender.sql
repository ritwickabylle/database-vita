CREATE TABLE [dbo].[Gender]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Gender] ADD CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
