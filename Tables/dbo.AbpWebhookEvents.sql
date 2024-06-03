CREATE TABLE [dbo].[AbpWebhookEvents]
(
[Id] [uniqueidentifier] NOT NULL,
[WebhookName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Data] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[TenantId] [int] NULL,
[IsDeleted] [bit] NOT NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpWebhookEvents] ADD CONSTRAINT [PK_AbpWebhookEvents] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
