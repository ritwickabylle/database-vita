CREATE TABLE [dbo].[FileUpload_TransactionSummary]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[BatchId] [int] NULL,
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
[AdditionalData1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
