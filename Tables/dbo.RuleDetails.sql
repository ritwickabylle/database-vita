CREATE TABLE [dbo].[RuleDetails]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RuleId] [int] NULL,
[RuleValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RuleType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
