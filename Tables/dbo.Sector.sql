CREATE TABLE [dbo].[Sector]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UniqueIdentifier] [uniqueidentifier] NOT NULL,
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryGroupCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryGroupName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubIndustryCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubIndustryName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[CreationTime] [datetime] NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sector] ADD CONSTRAINT [PK_Sector] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Sector_TenantId] ON [dbo].[Sector] ([TenantId]) ON [PRIMARY]
GO
