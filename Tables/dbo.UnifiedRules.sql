CREATE TABLE [dbo].[UnifiedRules]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RuleGroupId] [int] NULL,
[SqlStatement] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OnSuccessNext] [int] NULL,
[OnFailureNext] [int] NULL,
[StopCondition] [int] NULL,
[Order] [int] NULL,
[errorCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[key] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__UnifiedRule__key__59D0414E] DEFAULT (NULL),
[isActive] [bit] NULL CONSTRAINT [DF__UnifiedRu__isAct__5AC46587] DEFAULT ((1)),
[TenantId] [bigint] NULL,
[TenancyCode] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Module] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phase] [int] NULL
) ON [PRIMARY]
GO
