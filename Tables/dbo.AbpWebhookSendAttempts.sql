CREATE TABLE [dbo].[AbpWebhookSendAttempts]
(
[Id] [uniqueidentifier] NOT NULL,
[WebhookEventId] [uniqueidentifier] NOT NULL,
[WebhookSubscriptionId] [uniqueidentifier] NOT NULL,
[Response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseStatusCode] [int] NULL,
[CreationTime] [datetime2] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpWebhookSendAttempts] ADD CONSTRAINT [PK_AbpWebhookSendAttempts] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpWebhookSendAttempts_WebhookEventId] ON [dbo].[AbpWebhookSendAttempts] ([WebhookEventId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpWebhookSendAttempts] ADD CONSTRAINT [FK_AbpWebhookSendAttempts_AbpWebhookEvents_WebhookEventId] FOREIGN KEY ([WebhookEventId]) REFERENCES [dbo].[AbpWebhookEvents] ([Id]) ON DELETE CASCADE
GO
