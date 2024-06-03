CREATE TABLE [dbo].[AbpRoleClaims]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[ClaimType] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpRoleClaims] ADD CONSTRAINT [PK_AbpRoleClaims] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpRoleClaims_RoleId] ON [dbo].[AbpRoleClaims] ([RoleId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpRoleClaims_TenantId_ClaimType] ON [dbo].[AbpRoleClaims] ([TenantId], [ClaimType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpRoleClaims] ADD CONSTRAINT [FK_AbpRoleClaims_AbpRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AbpRoles] ([Id]) ON DELETE CASCADE
GO
