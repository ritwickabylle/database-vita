CREATE TABLE [dbo].[Mst_WHTRates]
(
[id] [int] NOT NULL,
[ServiceName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FromDate] [datetime] NULL,
[Todate] [datetime] NULL,
[StandardRate] [decimal] (5, 2) NULL,
[AffiliationRate] [decimal] (5, 2) NULL,
[Standardrate_OOK] [decimal] (18, 0) NULL,
[AffiliationRate_OOK] [decimal] (18, 0) NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__Mst_WHTRa__IsAct__1D5142F3] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Mst_WHTRates] ADD CONSTRAINT [PK__Mst_WHTR__3213E83F18E8A9EE] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
