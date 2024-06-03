CREATE TABLE [dbo].[CIT_Schedule2]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IDType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IDNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractingParty] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractDate] [datetime2] NULL,
[OriginalValue] [decimal] (18, 2) NULL,
[AmendmentsToOriginalValue] [decimal] (18, 2) NULL,
[ContractValueAfterAmendments] [decimal] (18, 2) NULL,
[TotalActualCostsIncurred] [decimal] (18, 2) NULL,
[ContractEstimatedCost] [decimal] (18, 2) NULL,
[CompletionPercentage] [decimal] (18, 4) NULL,
[RevenuesAccordingToCompletionToDate] [decimal] (18, 2) NULL,
[RevenuesAccordingToCompletionPriorYear] [decimal] (18, 2) NULL,
[RevenuesAccordingToCompletionDuringCurrentYear] [decimal] (18, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule2] ADD CONSTRAINT [PK_CIT_Schedule2] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
