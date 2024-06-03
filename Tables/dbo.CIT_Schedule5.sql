CREATE TABLE [dbo].[CIT_Schedule5]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[ProvisionName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProvisionsBalanceAtBeginningOfPeriod] [decimal] (18, 2) NULL,
[ProvisionsMadeDuringTheYear] [decimal] (18, 2) NULL,
[ProvisionsUtilizedDuringTheYear] [decimal] (18, 2) NULL,
[Adjustments] [decimal] (18, 2) NULL,
[ProvisionsBalanceAtTheEndOfThePeriod] [decimal] (18, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule5] ADD CONSTRAINT [PK_CIT_Schedule5] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
