CREATE TABLE [dbo].[TenantPurchaseVatCateory]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[VATCategoryID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATCategoryName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TenantPurchaseVatCateory] ADD CONSTRAINT [PK_TenantPurchaseVatCateory] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TenantPurchaseVatCateory_TenantId] ON [dbo].[TenantPurchaseVatCateory] ([TenantId]) ON [PRIMARY]
GO
