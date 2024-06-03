CREATE TABLE [dbo].[Vendors]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[TenantType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConstitutionType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPerson] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nationality] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Designation] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vendors] ADD CONSTRAINT [PK_Vendors] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Vendors_TenantId] ON [dbo].[Vendors] ([TenantId]) ON [PRIMARY]
GO
