CREATE TABLE [dbo].[CompanyProfiles]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfIncorporation] [datetime2] NOT NULL,
[ConstitutionTypeUuid] [uniqueidentifier] NOT NULL,
[ConstitutionType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentId] [int] NULL,
[ParentUuid] [uniqueidentifier] NOT NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TelephoneNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Website] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VatId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupVatId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[TenantType] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPerson] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactNO] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nationality] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Designation] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentEntityName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalRep] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[countryofParententity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UUID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyProfiles] ADD CONSTRAINT [PK_CompanyProfiles] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
