CREATE TABLE [dbo].[CIT_GLGroupMaster]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[GroupName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISBS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_GLGroupMaster] ADD CONSTRAINT [PK_CIT_GLGroupMaster] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
