CREATE TABLE [dbo].[AbpUserClaims]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[ClaimType] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserClaims] ADD CONSTRAINT [PK_AbpUserClaims] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserClaims_TenantId_ClaimType] ON [dbo].[AbpUserClaims] ([TenantId], [ClaimType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserClaims_UserId] ON [dbo].[AbpUserClaims] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserClaims] ADD CONSTRAINT [FK_AbpUserClaims_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AbpUsers] ([Id]) ON DELETE CASCADE
GO
