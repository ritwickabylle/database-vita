CREATE TABLE [dbo].[CIT_TrialBalanceTransactions]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NULL,
[GLCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISBS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[OpBalance] [decimal] (18, 2) NULL,
[Debit] [decimal] (18, 2) NULL,
[Credit] [decimal] (18, 2) NULL,
[CIBalance] [decimal] (18, 2) NULL,
[CreationTime] [datetime2] NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NULL,
[GLGroup] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OpBalanceType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIBalanceType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_TrialBalanceTransactions] ADD CONSTRAINT [PK__CIT_Tria__3214EC07B54D263F] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
