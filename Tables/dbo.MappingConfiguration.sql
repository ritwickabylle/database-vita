CREATE TABLE [dbo].[MappingConfiguration]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[CountryCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TenantId] [int] NULL,
[TenantCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Module] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MappingType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MappingData] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL CONSTRAINT [DF_Table_1_isActive] DEFAULT ((1)),
[EffectiveFrom] [datetime] NULL,
[EffectiveTill] [datetime] NULL,
[AdditionalData1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalData2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MappingName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MappingId] [int] NULL
) ON [PRIMARY]
GO
