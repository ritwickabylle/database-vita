CREATE TABLE [dbo].[mst_WHTMultipleRates]
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
[slno] [numeric] (3, 0) NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__mst_WHTMu__IsAct__1C5D1EBA] DEFAULT ((0))
) ON [PRIMARY]
GO
