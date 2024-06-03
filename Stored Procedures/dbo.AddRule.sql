SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create   procedure [dbo].[AddRule]
   (
        @errorCode nvarchar(max),
        @OnSuccessNext int,
        @OnFailureNext int,
        @StopCondition int,
        @Sql nvarchar(max),
        @Order int=null,
        @RuleGroupId int,
        @RuleType varchar(100),
        @RuleValue nvarchar(max)
     )

as
begin
    declare @RuleId int
    -- insert the rule
    insert into [Rule] (RuleGroupId, SqlStatement,errorCode, OnSuccessNext, OnFailureNext, StopCondition, [Order]) values (@RuleGroupId, @Sql, @errorCode, @OnSuccessNext, @OnFailureNext, @StopCondition, @Order)

    -- get the id of inserted rule using identity
    set @RuleId = @@identity

    -- insert the rule details
    insert into RuleDetails (RuleId, RuleType, RuleValue) values (@RuleId,@RuleType, @RuleValue)

end
GO
