CREATE TABLE [dbo].[CIT_Schedule9]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[GroupNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheGroupValueAtEndOfPreviousYear] [decimal] (18, 2) NULL,
[TheCostOfPreviousYearAdditions] [decimal] (18, 2) NULL,
[TheCostOfCurrentAdditions] [decimal] (18, 2) NULL,
[50PercentTotalCostAdditionsDuringCurAndPreYears] [decimal] (18, 2) NULL,
[CompForAssetsNotQualifyDepreciationPreYear] [decimal] (18, 2) NULL,
[CompForAssetsNotQualifyDepreciationCurYear] [decimal] (18, 2) NULL,
[50PercentTotalValueCompForAssetsNotQualifyDepreciationCurAndPreYear] [decimal] (18, 2) NULL,
[TheRemainingValueOfTheGroup] [decimal] (18, 2) NULL,
[DepreciationAmortizationRatioPercentage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepreciationAmortizationValue] [decimal] (18, 2) NULL,
[TheRemainingValueOfTheGroupAtTheEndOfTheCurrentYear] [decimal] (18, 2) NULL,
[RepairAndImprovementCostForTheGroup] [decimal] (18, 2) NULL,
[RepairAndImprovementExpensesExceeding4Percent] [decimal] (18, 2) NULL,
[TheRemainingOfTheGroupAtTheEndOfTheCurrentYear] [decimal] (18, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule9] ADD CONSTRAINT [PK_CIT_Schedule9] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
