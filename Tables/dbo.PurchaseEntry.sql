CREATE TABLE [dbo].[PurchaseEntry]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IssueDate] [datetime2] NOT NULL,
[DateOfSupply] [datetime2] NOT NULL,
[InvoiceCurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyCodeOriginatingCountry] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurchaseOrderId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingReferenceId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LatestDeliveryDate] [datetime2] NOT NULL,
[Location] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Info] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PdfUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QrCodeUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XMLUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArchivalUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviousInvoiceHash] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PerviousXMLHash] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XMLHash] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PdfHash] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XMLbase64] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PdfBase64] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsArchived] [bit] NOT NULL,
[TransTypeCode] [int] NOT NULL,
[TransTypeDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdvanceReferenceNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Invoicetransactioncode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessProcessType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceNotes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurchaseNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierInvoiceDate] [datetime2] NOT NULL,
[BillOfEntry] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillOfEntryDate] [datetime2] NOT NULL,
[CustomsPaid] [decimal] (18, 2) NOT NULL,
[CustomTax] [decimal] (18, 2) NOT NULL,
[IsWHT] [bit] NOT NULL,
[VATDeffered] [bit] NOT NULL,
[PlaceofSupply] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurchaseEntry] ADD CONSTRAINT [PK_PurchaseEntry] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PurchaseEntry_TenantId] ON [dbo].[PurchaseEntry] ([TenantId]) ON [PRIMARY]
GO