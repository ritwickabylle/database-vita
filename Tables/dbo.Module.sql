CREATE TABLE [dbo].[Module]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[ModuleId] [int] NOT NULL,
[ModuleName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Module] ADD CONSTRAINT [PK_Module] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
