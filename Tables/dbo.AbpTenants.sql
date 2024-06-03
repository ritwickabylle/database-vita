CREATE TABLE [dbo].[AbpTenants]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ConnectionString] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[CustomCssId] [uniqueidentifier] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[EditionId] [int] NULL,
[IsActive] [bit] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[LogoFileType] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogoId] [uniqueidentifier] NULL,
[Name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenancyName] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsInTrialPeriod] [bit] NOT NULL CONSTRAINT [DF__AbpTenant__IsInT__43E1002F] DEFAULT (CONVERT([bit],(0))),
[SubscriptionEndDateUtc] [datetime2] NULL,
[SubscriptionPaymentType] [int] NOT NULL CONSTRAINT [DF__AbpTenant__Subsc__44D52468] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpTenants] ADD CONSTRAINT [PK_AbpTenants] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenants_CreationTime] ON [dbo].[AbpTenants] ([CreationTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenants_CreatorUserId] ON [dbo].[AbpTenants] ([CreatorUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenants_DeleterUserId] ON [dbo].[AbpTenants] ([DeleterUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenants_EditionId] ON [dbo].[AbpTenants] ([EditionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenants_LastModifierUserId] ON [dbo].[AbpTenants] ([LastModifierUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenants_SubscriptionEndDateUtc] ON [dbo].[AbpTenants] ([SubscriptionEndDateUtc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenants_TenancyName] ON [dbo].[AbpTenants] ([TenancyName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpTenants] ADD CONSTRAINT [FK_AbpTenants_AbpEditions_EditionId] FOREIGN KEY ([EditionId]) REFERENCES [dbo].[AbpEditions] ([Id])
GO
ALTER TABLE [dbo].[AbpTenants] ADD CONSTRAINT [FK_AbpTenants_AbpUsers_CreatorUserId] FOREIGN KEY ([CreatorUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
ALTER TABLE [dbo].[AbpTenants] ADD CONSTRAINT [FK_AbpTenants_AbpUsers_DeleterUserId] FOREIGN KEY ([DeleterUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
ALTER TABLE [dbo].[AbpTenants] ADD CONSTRAINT [FK_AbpTenants_AbpUsers_LastModifierUserId] FOREIGN KEY ([LastModifierUserId]) REFERENCES [dbo].[AbpUsers] ([Id])
GO
