CREATE TABLE [dbo].[ReportTemplate]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[Html] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowHtml] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[orientation] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__ReportTem__orien__513AFB4D] DEFAULT ('P'),
[ChargesRow] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
