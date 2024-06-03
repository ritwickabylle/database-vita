CREATE TABLE [dbo].[AppUserDelegations]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[LastModificationTime] [datetime2] NULL,
[LastModifierUserId] [bigint] NULL,
[IsDeleted] [bit] NOT NULL,
[DeleterUserId] [bigint] NULL,
[DeletionTime] [datetime2] NULL,
[SourceUserId] [bigint] NOT NULL,
[TargetUserId] [bigint] NOT NULL,
[TenantId] [int] NULL,
[StartTime] [datetime2] NOT NULL,
[EndTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppUserDelegations] ADD CONSTRAINT [PK_AppUserDelegations] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppUserDelegations_TenantId_SourceUserId] ON [dbo].[AppUserDelegations] ([TenantId], [SourceUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppUserDelegations_TenantId_TargetUserId] ON [dbo].[AppUserDelegations] ([TenantId], [TargetUserId]) ON [PRIMARY]
GO
