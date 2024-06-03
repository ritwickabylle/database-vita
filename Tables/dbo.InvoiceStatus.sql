CREATE TABLE [dbo].[InvoiceStatus]
(
[invoiceType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[irnno] [int] NULL,
[batchId] [int] NULL,
[invoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isXmlSigned] [bit] NULL CONSTRAINT [DF__InvoiceSt__isXml__4F52B2DB] DEFAULT ((0)),
[inputData] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isPdfGenerated] [bit] NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
