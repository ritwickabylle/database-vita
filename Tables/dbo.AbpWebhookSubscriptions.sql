CREATE TABLE [dbo].[AbpWebhookSubscriptions]
(
[Id] [uniqueidentifier] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[TenantId] [int] NULL,
[WebhookUri] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Secret] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[Webhooks] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Headers] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpWebhookSubscriptions] ADD CONSTRAINT [PK_AbpWebhookSubscriptions] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
