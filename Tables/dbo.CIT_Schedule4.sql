CREATE TABLE [dbo].[CIT_Schedule4]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IDType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IDNumber] [int] NULL,
[BeneficiaryName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocalorForeign] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BeginningoftheyearBalance] [decimal] (18, 2) NULL,
[ChargetotheAccounts] [decimal] (18, 2) NULL,
[PaidAmount] [decimal] (18, 2) NULL,
[EndoftheyearBalance] [decimal] (18, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule4] ADD CONSTRAINT [PK_CIT_Schedule4] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
