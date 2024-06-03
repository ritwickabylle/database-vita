CREATE TABLE [dbo].[AbpUserNotifications]
(
[Id] [uniqueidentifier] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[State] [int] NOT NULL,
[TenantId] [int] NULL,
[TenantNotificationId] [uniqueidentifier] NOT NULL,
[UserId] [bigint] NOT NULL,
[TargetNotifiers] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserNotifications] ADD CONSTRAINT [PK_AbpUserNotifications] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserNotifications_UserId_State_CreationTime] ON [dbo].[AbpUserNotifications] ([UserId], [State], [CreationTime]) ON [PRIMARY]
GO
