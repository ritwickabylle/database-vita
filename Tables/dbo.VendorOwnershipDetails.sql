CREATE TABLE [dbo].[VendorOwnershipDetails]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[VendorID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorUniqueIdentifier] [uniqueidentifier] NOT NULL,
[PartnerName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerConstitution] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartnerNationality] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CapitalAmount] [decimal] (18, 2) NOT NULL,
[CapitalShare] [decimal] (18, 2) NOT NULL,
[ProfitShare] [decimal] (18, 2) NOT NULL,
[RepresentativeName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VendorOwnershipDetails] ADD CONSTRAINT [PK_VendorOwnershipDetails] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_VendorOwnershipDetails_TenantId] ON [dbo].[VendorOwnershipDetails] ([TenantId]) ON [PRIMARY]
GO
