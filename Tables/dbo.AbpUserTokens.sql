CREATE TABLE [dbo].[AbpUserTokens]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[LoginProvider] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL,
[Value] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpireDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserTokens] ADD CONSTRAINT [PK_AbpUserTokens] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserTokens_TenantId_UserId] ON [dbo].[AbpUserTokens] ([TenantId], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserTokens_UserId] ON [dbo].[AbpUserTokens] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserTokens] ADD CONSTRAINT [FK_AbpUserTokens_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AbpUsers] ([Id]) ON DELETE CASCADE
GO
