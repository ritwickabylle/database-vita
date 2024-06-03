CREATE TABLE [dbo].[VI_PaymentWHTRate]
(
[UniqueIdentifier] [uniqueidentifier] NULL,
[StandardRate] [decimal] (5, 2) NULL,
[Batchid] [int] NULL,
[RateSlno] [int] NULL,
[LawRate] [numeric] (5, 2) NULL,
[EffRate] [numeric] (5, 2) NULL,
[ServiceName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
