CREATE TABLE [dbo].[CIT_Schedule15]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[Investmenttype] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TIN] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameofentityinvestee] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [decimal] (10, 2) NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_Schedule15] ADD CONSTRAINT [PK_CIT_Schedule15] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
