CREATE TABLE [dbo].[CustomerOwnershipDetails]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[CustomerID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerUniqueIdentifier] [uniqueidentifier] NOT NULL,
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
ALTER TABLE [dbo].[CustomerOwnershipDetails] ADD CONSTRAINT [PK_CustomerOwnershipDetails] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CustomerOwnershipDetails_TenantId] ON [dbo].[CustomerOwnershipDetails] ([TenantId]) ON [PRIMARY]
GO
