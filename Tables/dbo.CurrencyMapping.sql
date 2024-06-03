CREATE TABLE [dbo].[CurrencyMapping]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[LocalCountryCode] [int] NOT NULL,
[Alphacode2] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alphacode3] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceCurrency] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceCurrencyCountryCode] [int] NOT NULL,
[AccountingCurrency] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NationalCurrency] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__CurrencyM__IsAct__1F398B65] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CurrencyMapping] ADD CONSTRAINT [PK_CurrencyMapping] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
