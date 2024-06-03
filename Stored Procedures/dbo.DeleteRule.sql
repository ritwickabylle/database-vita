SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     procedure [dbo].[DeleteRule]
    (
        @Id int 
    )
    as
    begin
        delete from RuleDetails where RuleId = @Id
        delete from [Rule] where Id = @Id
    end
GO
