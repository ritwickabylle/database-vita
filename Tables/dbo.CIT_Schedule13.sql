CREATE TABLE [dbo].[CIT_Schedule13]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[SrNo] [int] NULL,
[LenderName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocalorForeign] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BeginningOfPeriodBalance] [decimal] (18, 2) NULL,
[AmountClearedFromTheLoanDuringTheCurrentYear] [decimal] (18, 2) NULL,
[AdditionsToTheLoanDuringTheYear] [decimal] (18, 2) NULL,
[EndOfPeriodBalance] [decimal] (18, 2) NULL,
[UtilizedInDeductedItem] [decimal] (18, 2) NULL,
[DateOfLoansStart] [datetime2] NULL,
[DateOfLoanCleared] [datetime2] NULL,
[LoansAddedToZakatBaseComponents] [decimal] (18, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule13] ADD CONSTRAINT [PK_CIT_Schedule13] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
