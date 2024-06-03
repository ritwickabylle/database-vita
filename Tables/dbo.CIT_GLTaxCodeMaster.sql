CREATE TABLE [dbo].[CIT_GLTaxCodeMaster]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[TaxCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxCodeDisplayOrder] [int] NULL,
[MainGroup] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGroup] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduleNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISBS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemeNo] [int] NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsActive] [bit] NOT NULL,
[Inputstatus] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CIT_GLTaxCodeMaster] ADD CONSTRAINT [PK_GLTaxCodeMaster] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
