CREATE TABLE [dbo].[RuleBatch]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RuleGroupId] [int] NOT NULL,
[ExecutionTime] [datetime] NOT NULL,
[Success] [int] NULL,
[Failed] [int] NULL
) ON [PRIMARY]
GO
