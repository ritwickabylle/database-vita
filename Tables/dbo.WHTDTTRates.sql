CREATE TABLE [dbo].[WHTDTTRates]
(
[id] [int] NOT NULL,
[UUID] [uniqueidentifier] NULL CONSTRAINT [DF__WHTDTTRate__UUID__5BB889C0] DEFAULT (newid()),
[ServiceName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountryCode] [numeric] (3, 0) NOT NULL,
[AlphaCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FromDate] [datetime] NOT NULL,
[Todate] [datetime] NOT NULL,
[DTTRates] [decimal] (5, 2) NULL,
[SpecialRates] [decimal] (5, 2) NULL,
[Status] [int] NULL,
[RuleID] [int] NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__WHTDTTRat__IsAct__1E45672C] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WHTDTTRates] ADD CONSTRAINT [PK__WHTDTTRa__3213E83F0E726B16] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]
GO
