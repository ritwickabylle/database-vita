CREATE TABLE [dbo].[taxmaster]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TaxSchemeID] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxID] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxName] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate] [int] NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxCode] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Eff_Fm_Dt] [datetime2] NOT NULL,
[Eff_To_Dt] [datetime2] NULL,
[IsActive] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[taxmaster] ADD CONSTRAINT [PK_taxmaster] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
