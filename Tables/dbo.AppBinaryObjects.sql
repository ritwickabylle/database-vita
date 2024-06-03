CREATE TABLE [dbo].[AppBinaryObjects]
(
[Id] [uniqueidentifier] NOT NULL,
[Bytes] [varbinary] (max) NOT NULL,
[TenantId] [int] NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppBinaryObjects] ADD CONSTRAINT [PK_AppBinaryObjects] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppBinaryObjects_TenantId] ON [dbo].[AppBinaryObjects] ([TenantId]) ON [PRIMARY]
GO
