CREATE TABLE [dbo].[DynamicFileMapping]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[Country] [nchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Module] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Field] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultValue] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsMandatory] [bit] NOT NULL CONSTRAINT [DF_Table_1_ismanditory] DEFAULT ((0)),
[IsActive] [bit] NULL CONSTRAINT [DF_DynamicFileMapping_IsActive] DEFAULT ((1)),
[DisplaySequence] [int] NULL,
[DisplayName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HelpText] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DynamicFi__DataT__4B8221F7] DEFAULT ('string')
) ON [PRIMARY]
GO
