CREATE TABLE [dbo].[tmp_items]
(
[Identifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellerIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandardIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 2) NULL,
[UOM] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitPrice] [decimal] (18, 2) NULL,
[CostPrice] [decimal] (18, 2) NULL,
[DiscountPercentage] [decimal] (18, 2) NULL,
[DiscountAmount] [decimal] (18, 2) NULL,
[GrossPrice] [decimal] (18, 2) NULL,
[NetPrice] [decimal] (18, 2) NULL,
[VATRate] [decimal] (18, 2) NULL,
[VATCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATAmount] [decimal] (18, 2) NULL,
[LineAmountInclusiveVAT] [decimal] (18, 2) NULL,
[CurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxSchemeId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcemptionReasonCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcemptionReasonText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uuid] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isOtherCharges] [bit] NULL CONSTRAINT [DF__tmp_items__isOth__58DC1D15] DEFAULT ((0)),
[isDeleted] [bit] NULL CONSTRAINT [DF__tmp_items__isDel__57E7F8DC] DEFAULT ((0))
) ON [PRIMARY]
GO
