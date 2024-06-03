CREATE TABLE [dbo].[PurchaseDebitNoteSummary]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NetInvoiceAmount] [decimal] (18, 2) NOT NULL,
[NetInvoiceAmountCurrency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SumOfInvoiceLineNetAmount] [decimal] (18, 2) NOT NULL,
[SumOfInvoiceLineNetAmountCurrency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalAmountWithoutVAT] [decimal] (18, 2) NOT NULL,
[TotalAmountWithoutVATCurrency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalVATAmount] [decimal] (18, 2) NOT NULL,
[CurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalAmountWithVAT] [decimal] (18, 2) NOT NULL,
[PaidAmount] [decimal] (18, 2) NOT NULL,
[PaidAmountCurrency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayableAmount] [decimal] (18, 2) NOT NULL,
[PayableAmountCurrency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdvanceAmountwithoutVat] [decimal] (18, 2) NOT NULL,
[AdvanceVat] [decimal] (18, 2) NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurchaseDebitNoteSummary] ADD CONSTRAINT [PK_PurchaseDebitNoteSummary] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PurchaseDebitNoteSummary_TenantId] ON [dbo].[PurchaseDebitNoteSummary] ([TenantId]) ON [PRIMARY]
GO
