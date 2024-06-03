CREATE TABLE [dbo].[AbpPersistedGrants]
(
[Id] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClientId] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[Data] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Expiration] [datetime2] NULL,
[SubjectId] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConsumedTime] [datetime2] NULL,
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SessionId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpPersistedGrants] ADD CONSTRAINT [PK_AbpPersistedGrants] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpPersistedGrants_Expiration] ON [dbo].[AbpPersistedGrants] ([Expiration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpPersistedGrants_SubjectId_ClientId_Type] ON [dbo].[AbpPersistedGrants] ([SubjectId], [ClientId], [Type]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpPersistedGrants_SubjectId_SessionId_Type] ON [dbo].[AbpPersistedGrants] ([SubjectId], [SessionId], [Type]) ON [PRIMARY]
GO
