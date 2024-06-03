CREATE TABLE [dbo].[invoiceindicators]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Invoice_flags] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransTypePositionFm] [int] NOT NULL,
[TransTypePositionTo] [int] NOT NULL,
[TranstypeValue] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salestype] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Purchasetype] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__invoicein__IsAct__202DAF9E] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[invoiceindicators] ADD CONSTRAINT [PK_mst_invoiceindicators] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
