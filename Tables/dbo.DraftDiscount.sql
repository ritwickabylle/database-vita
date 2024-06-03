CREATE TABLE [dbo].[DraftDiscount]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[IRNNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DiscountPercentage] [decimal] (18, 2) NOT NULL,
[DiscountAmount] [decimal] (18, 2) NOT NULL,
[VATCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATRate] [decimal] (18, 2) NOT NULL,
[TaxSchemeId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DraftDiscount] ADD CONSTRAINT [PK_DraftDiscount] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DraftDiscount_TenantId] ON [dbo].[DraftDiscount] ([TenantId]) ON [PRIMARY]
GO
