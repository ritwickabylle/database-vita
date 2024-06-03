CREATE TABLE [dbo].[VendorForeignEntity]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[VendorID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorUniqueIdentifier] [uniqueidentifier] NOT NULL,
[ForeignEntityName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForeignEntityAddress] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalRepresentative] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VendorForeignEntity] ADD CONSTRAINT [PK_VendorForeignEntity] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VendorForeignEntity_TenantId] ON [dbo].[VendorForeignEntity] ([TenantId]) ON [PRIMARY]
GO
