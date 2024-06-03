CREATE TABLE [dbo].[FileUpload_TransactionHeader]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[BatchId] [int] NULL,
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IssueDate] [datetime2] NOT NULL,
[DateOfSupply] [datetime2] NULL,
[InvoiceCurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyCodeOriginatingCountry] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurchaseOrderId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingReferenceId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LatestDeliveryDate] [datetime2] NULL,
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
[CreationTime] [datetime2] NOT NULL,
[InvoiceNotes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XmlUuid] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData3] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData4] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceTypeCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Errors] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IBAN] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SwiftCode] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
