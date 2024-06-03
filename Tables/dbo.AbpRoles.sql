CREATE TABLE [dbo].[AbpRoles]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyStamp] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[DisplayName] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDefault] [bit] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[IsStatic] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[Name] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NormalizedName] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpRoles] ADD CONSTRAINT [PK_AbpRoles] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpRoles_CreatorUserId] ON [dbo].[AbpRoles] ([CreatorUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpRoles_DeleterUserId] ON [dbo].[AbpRoles] ([DeleterUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpRoles_LastModifierUserId] ON [dbo].[AbpRoles] ([LastModifierUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpRoles_TenantId_NormalizedName] ON [dbo].[AbpRoles] ([TenantId], [NormalizedName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpRoles] ADD CONSTRAINT [FK_AbpRoles_AbpUsers_CreatorUserId] FOREIGN KEY ([CreatorUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
ALTER TABLE [dbo].[AbpRoles] ADD CONSTRAINT [FK_AbpRoles_AbpUsers_DeleterUserId] FOREIGN KEY ([DeleterUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
ALTER TABLE [dbo].[AbpRoles] ADD CONSTRAINT [FK_AbpRoles_AbpUsers_LastModifierUserId] FOREIGN KEY ([LastModifierUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
