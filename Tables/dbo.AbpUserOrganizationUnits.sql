CREATE TABLE [dbo].[AbpUserOrganizationUnits]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CreationTime] [datetime2] NOT NULL,
[CreatorUserId] [bigint] NULL,
[OrganizationUnitId] [bigint] NOT NULL,
[TenantId] [int] NULL,
[UserId] [bigint] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF__AbpUserOr__IsDel__45C948A1] DEFAULT (CONVERT([bit],(0)))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserOrganizationUnits] ADD CONSTRAINT [PK_AbpUserOrganizationUnits] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserOrganizationUnits_TenantId_OrganizationUnitId] ON [dbo].[AbpUserOrganizationUnits] ([TenantId], [OrganizationUnitId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserOrganizationUnits_TenantId_UserId] ON [dbo].[AbpUserOrganizationUnits] ([TenantId], [UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AbpUserOrganizationUnits_UserId] ON [dbo].[AbpUserOrganizationUnits] ([UserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AbpUserOrganizationUnits] ADD CONSTRAINT [FK_AbpUserOrganizationUnits_AbpUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AbpUsers] ([Id]) ON DELETE CASCADE
GO
