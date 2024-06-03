CREATE TABLE [dbo].[AbpPermissions]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[Discriminator] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsGranted] [bit] NOT NULL,
[Name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL,
[RoleId] [int] NULL,
[UserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpPermissions] ADD CONSTRAINT [PK_AbpPermissions] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpPermissions_RoleId] ON [dbo].[AbpPermissions] ([RoleId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpPermissions_TenantId_Name] ON [dbo].[AbpPermissions] ([TenantId], [Name]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpPermissions_UserId] ON [dbo].[AbpPermissions] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpPermissions] ADD CONSTRAINT [FK_AbpPermissions_AbpRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AbpRoles] ([Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AbpPermissions] ADD CONSTRAINT [FK_AbpPermissions_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AbpUsers] ([Id]) ON DELETE CASCADE
GO
