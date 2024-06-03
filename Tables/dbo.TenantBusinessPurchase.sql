CREATE TABLE [dbo].[TenantBusinessPurchase]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[BusinessTypeID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPurchase] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [dbo].[TenantBusinessPurchase] ADD CONSTRAINT [PK_TenantBusinessPurchase] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TenantBusinessPurchase_TenantId] ON [dbo].[TenantBusinessPurchase] ([TenantId]) ON [PRIMARY]
GO
