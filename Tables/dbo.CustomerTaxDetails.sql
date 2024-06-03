CREATE TABLE [dbo].[CustomerTaxDetails]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[CustomerID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerUniqueIdentifier] [uniqueidentifier] NOT NULL,
[BusinessCategory] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OperatingModel] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessSupplies] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesVATCategory] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerTaxDetails] ADD CONSTRAINT [PK_CustomerTaxDetails] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CustomerTaxDetails_TenantId] ON [dbo].[CustomerTaxDetails] ([TenantId]) ON [PRIMARY]
GO
