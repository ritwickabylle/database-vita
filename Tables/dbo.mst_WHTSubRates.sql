CREATE TABLE [dbo].[mst_WHTSubRates]
(
[id] [int] NOT NULL,
[ServiceName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FromDate] [datetime] NULL,
[Todate] [datetime] NULL,
[StandardRate] [decimal] (5, 2) NULL,
[AffiliationRate] [decimal] (5, 2) NULL,
[Standardrate_OOK] [decimal] (18, 0) NULL,
[AffiliationRate_OOK] [decimal] (18, 0) NULL,
[natureofservice] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__mst_WHTSu__IsAct__1B68FA81] DEFAULT ((0))
) ON [PRIMARY]
GO
