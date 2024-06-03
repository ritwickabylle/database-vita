CREATE TABLE [dbo].[AppInvoices]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[InvoiceDate] [datetime2] NOT NULL,
[InvoiceNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantAddress] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantLegalName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantTaxNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppInvoices] ADD CONSTRAINT [PK_AppInvoices] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
