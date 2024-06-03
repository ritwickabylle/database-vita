CREATE TABLE [dbo].[AppFriendships]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[FriendProfilePictureId] [uniqueidentifier] NULL,
[FriendTenancyName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FriendTenantId] [int] NULL,
[FriendUserId] [bigint] NOT NULL,
[FriendUserName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [int] NOT NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppFriendships] ADD CONSTRAINT [PK_AppFriendships] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppFriendships_FriendTenantId_FriendUserId] ON [dbo].[AppFriendships] ([FriendTenantId], [FriendUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppFriendships_FriendTenantId_UserId] ON [dbo].[AppFriendships] ([FriendTenantId], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppFriendships_TenantId_FriendUserId] ON [dbo].[AppFriendships] ([TenantId], [FriendUserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppFriendships_TenantId_UserId] ON [dbo].[AppFriendships] ([TenantId], [UserId]) ON [PRIMARY]
GO
