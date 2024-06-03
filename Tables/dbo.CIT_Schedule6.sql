CREATE TABLE [dbo].[CIT_Schedule6]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IDType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IDNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BeneficiaryName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocalorForeign] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Beginningoftheyearbalance] [decimal] (18, 2) NULL,
[Chargedtotheaccounts] [decimal] (18, 2) NULL,
[Paidduringtheyear] [decimal] (18, 2) NULL,
[EndoftheyearBalance] [decimal] (18, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL,
[GLCoderelatingtoBS] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule6] ADD CONSTRAINT [PK_CIT_Schedule6] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
