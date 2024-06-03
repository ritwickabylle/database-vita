CREATE TABLE [dbo].[VendorTaxDetails]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[VendorID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorUniqueIdentifier] [uniqueidentifier] NOT NULL,
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
ALTER TABLE [dbo].[VendorTaxDetails] ADD CONSTRAINT [PK_VendorTaxDetails] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VendorTaxDetails_TenantId] ON [dbo].[VendorTaxDetails] ([TenantId]) ON [PRIMARY]
GO
