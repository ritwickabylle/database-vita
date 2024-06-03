CREATE TABLE [dbo].[TrialBalance_Reclassification]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Tenantid] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NULL,
[EntryNo] [bigint] NULL,
[GlCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAXMAP] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreGLBal] [decimal] (18, 2) NULL,
[Debit] [decimal] (18, 2) NULL,
[Credit] [decimal] (18, 2) NULL,
[FinalGLBal] [decimal] (18, 2) NULL,
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[creationtime] [datetime] NULL,
[CreatorUserId] [int] NULL,
[LastModificationTime] [datetime] NULL,
[LastModifiedUserId] [int] NULL,
[IsActive] [bit] NULL
) ON [PRIMARY]
GO
