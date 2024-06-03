CREATE TABLE [dbo].[CitForm]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[Html] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[IsDeleted] [bit] NULL,
[style] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pdftemplate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
