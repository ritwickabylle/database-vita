SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

  CREATE     procedure [dbo].[GetRules]
  (
    @RuleGroupId int
  )
    as
    begin
    select r.Id, r.RuleGroupId, rd.RuleType, r.errorCode, r.OnSuccessNext, r.OnFailureNext, r.StopCondition, r.SqlStatement as 'sql', r.[Order], rd.RuleValue from [Rule] r inner join RuleDetails rd on r.Id = rd.RuleId where r.RuleGroupId = @RuleGroupId
    end
GO
