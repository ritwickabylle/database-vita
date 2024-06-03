CREATE TABLE [dbo].[CustomerRegDetail]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UUID] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantID] [int] NULL,
[REFUUID] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentType] [nvarchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentId] [nvarchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegNo] [nvarchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegDate] [datetime] NULL,
[DocumentStatus] [bit] NULL
) ON [PRIMARY]
GO
