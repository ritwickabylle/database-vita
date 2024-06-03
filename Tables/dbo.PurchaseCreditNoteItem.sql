CREATE TABLE [dbo].[PurchaseCreditNoteItem]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Identifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellerIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandardIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 2) NOT NULL,
[UOM] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitPrice] [decimal] (18, 2) NOT NULL,
[CostPrice] [decimal] (18, 2) NOT NULL,
[DiscountPercentage] [decimal] (18, 2) NOT NULL,
[DiscountAmount] [float] NOT NULL,
[GrossPrice] [decimal] (18, 2) NOT NULL,
[NetPrice] [decimal] (18, 2) NOT NULL,
[VATRate] [decimal] (18, 2) NOT NULL,
[VATCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATAmount] [decimal] (18, 2) NOT NULL,
[LineAmountInclusiveVAT] [decimal] (18, 2) NOT NULL,
[CurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxSchemeId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcemptionReasonCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcemptionReasonText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurchaseCreditNoteItem] ADD CONSTRAINT [PK_PurchaseCreditNoteItem] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PurchaseCreditNoteItem_TenantId] ON [dbo].[PurchaseCreditNoteItem] ([TenantId]) ON [PRIMARY]
GO
