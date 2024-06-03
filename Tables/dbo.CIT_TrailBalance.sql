CREATE TABLE [dbo].[CIT_TrailBalance]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[GLCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLGroup] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OPBalance] [decimal] (18, 2) NULL,
[OpBalanceType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debit] [decimal] (18, 2) NULL,
[Credit] [decimal] (18, 2) NULL,
[CIBalance] [decimal] (18, 2) NULL,
[CIBalanceType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISBS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_TrailBalance] ADD CONSTRAINT [PK_CIT_TrailBalance] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
