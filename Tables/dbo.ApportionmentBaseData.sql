CREATE TABLE [dbo].[ApportionmentBaseData]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[EffectiveFromDate] [datetime2] NULL,
[EffectiveTillEndDate] [datetime2] NULL,
[TaxableSupply] [decimal] (18, 2) NULL,
[TotalSupply] [decimal] (18, 2) NULL,
[TaxablePurchase] [decimal] (18, 2) NULL,
[TotalPurchase] [decimal] (18, 2) NULL,
[FinYear] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[TotalExemptPurchase] [decimal] (18, 2) NULL,
[TotalExemptSales] [decimal] (18, 2) NULL,
[ApportionmentPurchases] [decimal] (18, 2) NULL,
[ApportionmentSupplies] [decimal] (18, 2) NULL,
[MixedOverHeads] [decimal] (18, 2) NULL,
[ExemptSupply] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExemptPurchase] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApportionmentBaseData] ADD CONSTRAINT [PK_ApportionmentBaseData] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
