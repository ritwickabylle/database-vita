CREATE TABLE [dbo].[AbpSettings]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpSettings] ADD CONSTRAINT [PK_AbpSettings] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AbpSettings_TenantId_Name_UserId] ON [dbo].[AbpSettings] ([TenantId], [Name], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpSettings_UserId] ON [dbo].[AbpSettings] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpSettings] ADD CONSTRAINT [FK_AbpSettings_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
