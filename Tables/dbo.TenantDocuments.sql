CREATE TABLE [dbo].[TenantDocuments]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[BranchId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BranchName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistrationDate] [datetime2] NULL,
[DocumentPath] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TenantDocuments] ADD CONSTRAINT [PK_TenantDocuments] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TenantDocuments_TenantId] ON [dbo].[TenantDocuments] ([TenantId]) ON [PRIMARY]
GO
