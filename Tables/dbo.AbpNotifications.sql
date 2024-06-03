CREATE TABLE [dbo].[AbpNotifications]
(
[Id] [uniqueidentifier] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[Data] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataTypeName] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityId] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityTypeAssemblyQualifiedName] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityTypeName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcludedUserIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NotificationName] [nvarchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Severity] [tinyint] NOT NULL,
[TenantIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserIds] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetNotifiers] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpNotifications] ADD CONSTRAINT [PK_AbpNotifications] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
