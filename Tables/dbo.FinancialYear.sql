CREATE TABLE [dbo].[FinancialYear]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[EffectiveFromDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveTillEndDate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FinancialYear] ADD CONSTRAINT [PK_FinancialYear] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
