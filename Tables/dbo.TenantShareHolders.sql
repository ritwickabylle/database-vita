CREATE TABLE [dbo].[TenantShareHolders]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[PartnerName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Designation] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nationality] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CapitalAmount] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CapitalShare] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProfitShare] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConstitutionName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RepresentativeName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DomesticName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mobile] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IdType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IdNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoOfSharePercentage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoOfShares] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShareHolderExitDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShareHolderEntryDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SharesSubjectTo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TenantShareHolders] ADD CONSTRAINT [PK_TenantShareHolders] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TenantShareHolders_TenantId] ON [dbo].[TenantShareHolders] ([TenantId]) ON [PRIMARY]
GO
