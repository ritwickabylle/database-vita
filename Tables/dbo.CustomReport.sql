CREATE TABLE [dbo].[CustomReport]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[ReportName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoredProcedureName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomReport] ADD CONSTRAINT [PK_CustomReport] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CustomReport_TenantId] ON [dbo].[CustomReport] ([TenantId]) ON [PRIMARY]
GO
