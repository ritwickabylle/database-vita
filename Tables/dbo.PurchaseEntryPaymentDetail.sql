CREATE TABLE [dbo].[PurchaseEntryPaymentDetail]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PaymentMeans] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditDebitReasonText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentTerms] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurchaseEntryPaymentDetail] ADD CONSTRAINT [PK_PurchaseEntryPaymentDetail] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PurchaseEntryPaymentDetail_TenantId] ON [dbo].[PurchaseEntryPaymentDetail] ([TenantId]) ON [PRIMARY]
GO
