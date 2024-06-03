CREATE TABLE [dbo].[CIT_SchemeFinYear]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[SchemeNo] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemeName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemeType] [int] NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_SchemeFinYear] ADD CONSTRAINT [CIT_SchemeFinancialYear] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
