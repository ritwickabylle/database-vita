CREATE TABLE [dbo].[CIT_TenantAdditionalMastersInformation]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[ZatcaBranch] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommercialName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Buildingno] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Area] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POBox] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIPcode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinancialNo] [int] NULL,
[MainActivity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DescriptionofMainActivity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinancialStartDate] [datetime2] NULL,
[FinancialEndDate] [datetime2] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
