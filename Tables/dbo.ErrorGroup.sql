CREATE TABLE [dbo].[ErrorGroup]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ErrorGroup] ADD CONSTRAINT [PK_ErrorGroup] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
