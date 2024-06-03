CREATE TABLE [dbo].[WHTRules]
(
[RuleID] [int] NULL,
[RuleText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RuleCommand] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__WHTRules__IsActi__1A74D648] DEFAULT ((0))
) ON [PRIMARY]
GO
