CREATE TABLE [dbo].[AppSubscriptionPayments]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[Amount] [decimal] (18, 2) NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[DayCount] [int] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[EditionId] [int] NOT NULL,
[Gateway] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[SuccessUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentPeriodType] [int] NULL,
[Status] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[InvoiceNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalPaymentId] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsRecurring] [bit] NOT NULL CONSTRAINT [DF__AppSubscr__IsRec__47B19113] DEFAULT (CONVERT([bit],(0))),
[EditionPaymentType] [int] NOT NULL CONSTRAINT [DF__AppSubscr__Editi__48A5B54C] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppSubscriptionPayments] ADD CONSTRAINT [PK_AppSubscriptionPayments] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppSubscriptionPayments_EditionId] ON [dbo].[AppSubscriptionPayments] ([EditionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppSubscriptionPayments_ExternalPaymentId_Gateway] ON [dbo].[AppSubscriptionPayments] ([ExternalPaymentId], [Gateway]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppSubscriptionPayments_Status_CreationTime] ON [dbo].[AppSubscriptionPayments] ([Status], [CreationTime]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppSubscriptionPayments] ADD CONSTRAINT [FK_AppSubscriptionPayments_AbpEditions_EditionId] FOREIGN KEY ([EditionId]) REFERENCES [dbo].[AbpEditions] ([Id]) ON DELETE CASCADE
GO
