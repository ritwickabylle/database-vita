CREATE TABLE [dbo].[logs_xml]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[uuid] [uniqueidentifier] NULL,
[createdOn] [datetime] NULL,
[createdBy] [int] NULL,
[tenantId] [int] NULL,
[signature] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[certificate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[xml64] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoiceHash64] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[csid] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[complianceInvoiceResponse] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reportInvoiceResponse] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clearanceResponse] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qrBase64] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[irnno] [int] NULL,
[errors] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[totalAmount] [decimal] (18, 2) NULL,
[vatAmount] [decimal] (18, 2) NULL,
[status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
