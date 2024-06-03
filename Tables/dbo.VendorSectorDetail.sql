CREATE TABLE [dbo].[VendorSectorDetail]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[VendorID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorUniqueIdentifier] [uniqueidentifier] NOT NULL,
[SubIndustryCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubIndustryName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VendorSectorDetail] ADD CONSTRAINT [PK_VendorSectorDetail] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VendorSectorDetail_TenantId] ON [dbo].[VendorSectorDetail] ([TenantId]) ON [PRIMARY]
GO
