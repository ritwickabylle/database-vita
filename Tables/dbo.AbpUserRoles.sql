CREATE TABLE [dbo].[AbpUserRoles]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserRoles] ADD CONSTRAINT [PK_AbpUserRoles] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserRoles_TenantId_RoleId] ON [dbo].[AbpUserRoles] ([TenantId], [RoleId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserRoles_TenantId_UserId] ON [dbo].[AbpUserRoles] ([TenantId], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserRoles_UserId] ON [dbo].[AbpUserRoles] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserRoles] ADD CONSTRAINT [FK_AbpUserRoles_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AbpUsers] ([Id]) ON DELETE CASCADE
GO
