CREATE TABLE [dbo].[VendorDocuments]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[VendorID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorUniqueIdentifier] [uniqueidentifier] NOT NULL,
[DocumentTypeCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoumentDate] [datetime2] NOT NULL,
[Status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VendorDocuments] ADD CONSTRAINT [PK_VendorDocuments] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VendorDocuments_TenantId] ON [dbo].[VendorDocuments] ([TenantId]) ON [PRIMARY]
GO
