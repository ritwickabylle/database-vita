CREATE TABLE [dbo].[AppRecentPasswords]
(
[Id] [uniqueidentifier] NOT NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL,
[Password] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppRecentPasswords] ADD CONSTRAINT [PK_AppRecentPasswords] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
