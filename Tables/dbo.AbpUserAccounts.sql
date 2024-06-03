CREATE TABLE [dbo].[AbpUserAccounts]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[EmailAddress] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL,
[UserLinkId] [bigint] NULL,
[UserName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserAccounts] ADD CONSTRAINT [PK_AbpUserAccounts] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserAccounts_EmailAddress] ON [dbo].[AbpUserAccounts] ([EmailAddress]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserAccounts_TenantId_EmailAddress] ON [dbo].[AbpUserAccounts] ([TenantId], [EmailAddress]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserAccounts_TenantId_UserId] ON [dbo].[AbpUserAccounts] ([TenantId], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserAccounts_TenantId_UserName] ON [dbo].[AbpUserAccounts] ([TenantId], [UserName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserAccounts_UserName] ON [dbo].[AbpUserAccounts] ([UserName]) ON [PRIMARY]
GO
