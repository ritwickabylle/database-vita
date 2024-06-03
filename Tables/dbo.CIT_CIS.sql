CREATE TABLE [dbo].[CIT_CIS]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[LineNo] [int] NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmendType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [decimal] (18, 2) NULL,
[SaudiShare1] [decimal] (18, 2) NULL,
[NonSaudiShare1] [decimal] (18, 2) NULL,
[SaudiShare2] [decimal] (18, 2) NULL,
[NonSaudiShare2] [decimal] (18, 2) NULL,
[Total] [decimal] (18, 2) NULL,
[TotalSaudiShare] [decimal] (18, 2) NULL,
[TotalNonSaudiShare] [decimal] (18, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL,
[SaudhiShare_1] [decimal] (18, 2) NULL,
[NonSaudhiShare_1] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_CIS] ADD CONSTRAINT [PK_CIT_CIS] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
