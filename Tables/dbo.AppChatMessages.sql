CREATE TABLE [dbo].[AppChatMessages]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[Message] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReadState] [int] NOT NULL,
[Side] [int] NOT NULL,
[TargetTenantId] [int] NULL,
[TargetUserId] [bigint] NOT NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL,
[SharedMessageId] [uniqueidentifier] NULL,
[ReceiverReadState] [int] NOT NULL CONSTRAINT [DF__AppChatMe__Recei__46BD6CDA] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppChatMessages] ADD CONSTRAINT [PK_AppChatMessages] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppChatMessages_TargetTenantId_TargetUserId_ReadState] ON [dbo].[AppChatMessages] ([TargetTenantId], [TargetUserId], [ReadState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppChatMessages_TargetTenantId_UserId_ReadState] ON [dbo].[AppChatMessages] ([TargetTenantId], [UserId], [ReadState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppChatMessages_TenantId_TargetUserId_ReadState] ON [dbo].[AppChatMessages] ([TenantId], [TargetUserId], [ReadState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AppChatMessages_TenantId_UserId_ReadState] ON [dbo].[AppChatMessages] ([TenantId], [UserId], [ReadState]) ON [PRIMARY]
GO
