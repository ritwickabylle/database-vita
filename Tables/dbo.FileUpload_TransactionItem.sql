CREATE TABLE [dbo].[FileUpload_TransactionItem]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[BatchId] [int] NULL,
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Identifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BuyerIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellerIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandardIdentifier] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 2) NOT NULL,
[UOM] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitPrice] [decimal] (18, 2) NOT NULL,
[CostPrice] [decimal] (18, 2) NOT NULL,
[DiscountPercentage] [decimal] (18, 2) NOT NULL,
[DiscountAmount] [decimal] (18, 2) NOT NULL,
[GrossPrice] [decimal] (18, 2) NOT NULL,
[NetPrice] [decimal] (18, 2) NOT NULL,
[VATRate] [decimal] (18, 2) NOT NULL,
[VATCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATAmount] [decimal] (18, 2) NOT NULL,
[LineAmountInclusiveVAT] [decimal] (18, 2) NOT NULL,
[CurrencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxSchemeId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcemptionReasonCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcemptionReasonText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[AdditionalData1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isOtherCharges] [bit] NULL CONSTRAINT [DF__FileUploa__isOth__4E5E8EA2] DEFAULT ((0))
) ON [PRIMARY]
GO