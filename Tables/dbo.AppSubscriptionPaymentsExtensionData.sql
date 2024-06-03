CREATE TABLE [dbo].[AppSubscriptionPaymentsExtensionData]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[SubscriptionPaymentId] [bigint] NOT NULL,
[Key] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppSubscriptionPaymentsExtensionData] ADD CONSTRAINT [PK_AppSubscriptionPaymentsExtensionData] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AppSubscriptionPaymentsExtensionData_SubscriptionPaymentId_Key_IsDeleted] ON [dbo].[AppSubscriptionPaymentsExtensionData] ([SubscriptionPaymentId], [Key], [IsDeleted]) WHERE ([IsDeleted]=(0)) ON [PRIMARY]
GO
