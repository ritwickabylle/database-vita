CREATE TABLE [dbo].[CIT_Schedule16]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[Statement] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Beginningbalancefromfinancialstatements] [decimal] (10, 2) NULL,
[Additions] [decimal] (10, 2) NULL,
[Disposalscost] [decimal] (10, 2) NULL,
[Endbalancefromfinancialstatements] [decimal] (10, 2) NULL,
[TotalSales] [decimal] (10, 2) NULL,
[Totaladvancepaymentsreceivedfromcustomers] [decimal] (10, 2) NULL,
[Percentage] [decimal] (10, 2) NULL,
[Deductedfrombase] [decimal] (10, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule16] ADD CONSTRAINT [PK_CIT_Schedule16] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
