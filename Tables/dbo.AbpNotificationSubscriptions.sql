CREATE TABLE [dbo].[AbpNotificationSubscriptions]
(
[Id] [uniqueidentifier] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[EntityId] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityTypeAssemblyQualifiedName] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityTypeName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NotificationName] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpNotificationSubscriptions] ADD CONSTRAINT [PK_AbpNotificationSubscriptions] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpNotificationSubscriptions_NotificationName_EntityTypeName_EntityId_UserId] ON [dbo].[AbpNotificationSubscriptions] ([NotificationName], [EntityTypeName], [EntityId], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpNotificationSubscriptions_TenantId_NotificationName_EntityTypeName_EntityId_UserId] ON [dbo].[AbpNotificationSubscriptions] ([TenantId], [NotificationName], [EntityTypeName], [EntityId], [UserId]) ON [PRIMARY]
GO
