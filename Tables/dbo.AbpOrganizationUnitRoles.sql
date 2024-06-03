CREATE TABLE [dbo].[AbpOrganizationUnitRoles]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[TenantId] [int] NULL,
[RoleId] [int] NOT NULL,
[OrganizationUnitId] [bigint] NOT NULL,
[IsDeleted] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpOrganizationUnitRoles] ADD CONSTRAINT [PK_AbpOrganizationUnitRoles] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpOrganizationUnitRoles_TenantId_OrganizationUnitId] ON [dbo].[AbpOrganizationUnitRoles] ([TenantId], [OrganizationUnitId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpOrganizationUnitRoles_TenantId_RoleId] ON [dbo].[AbpOrganizationUnitRoles] ([TenantId], [RoleId]) ON [PRIMARY]
GO
