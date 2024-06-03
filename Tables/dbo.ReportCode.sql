CREATE TABLE [dbo].[ReportCode]
(
[SlNo] [int] NOT NULL IDENTITY(1, 1),
[ReportName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Module] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPname] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueryString] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [int] NULL
) ON [PRIMARY]
GO
