CREATE TABLE [dbo].[TenantBasicDetails]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[TenantType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConstitutionType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessCategory] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OperationalModel] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TurnoverSlab] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPerson] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nationality] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Designation] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentEntityName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalRepresentative] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentEntityCountryCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastReturnFiled] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VATReturnFillingFrequency] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[TimeZone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isPhase1] [bit] NOT NULL CONSTRAINT [DF__TenantBas__isPha__56F3D4A3] DEFAULT (CONVERT([bit],(0))),
[FaxNo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Website] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LangTenancyName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionsComputerizationDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TenantBasicDetails] ADD CONSTRAINT [PK_TenantBasicDetails] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TenantBasicDetails_TenantId] ON [dbo].[TenantBasicDetails] ([TenantId]) ON [PRIMARY]
GO
