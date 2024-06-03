CREATE TABLE [dbo].[AbpUserLogins]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[LoginProvider] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProviderKey] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserLogins] ADD CONSTRAINT [PK_AbpUserLogins] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AbpUserLogins_ProviderKey_TenantId] ON [dbo].[AbpUserLogins] ([ProviderKey], [TenantId]) WHERE ([TenantId] IS NOT NULL) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserLogins_TenantId_LoginProvider_ProviderKey] ON [dbo].[AbpUserLogins] ([TenantId], [LoginProvider], [ProviderKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserLogins_TenantId_UserId] ON [dbo].[AbpUserLogins] ([TenantId], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserLogins_UserId] ON [dbo].[AbpUserLogins] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserLogins] ADD CONSTRAINT [FK_AbpUserLogins_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AbpUsers] ([Id]) ON DELETE CASCADE
GO
