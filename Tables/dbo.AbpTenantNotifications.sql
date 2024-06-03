CREATE TABLE [dbo].[AbpTenantNotifications]
(
[Id] [uniqueidentifier] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[Data] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataTypeName] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityId] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityTypeAssemblyQualifiedName] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityTypeName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NotificationName] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Severity] [tinyint] NOT NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpTenantNotifications] ADD CONSTRAINT [PK_AbpTenantNotifications] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpTenantNotifications_TenantId] ON [dbo].[AbpTenantNotifications] ([TenantId]) ON [PRIMARY]
GO
