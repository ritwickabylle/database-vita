SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     FUNCTION [dbo].[get_TransactionOverrideStatus] (@uuid uniqueidentifier)   -- exec get_transactionoverridestatus '1CC6DA24-5EB2-4AEA-BA25-E2A963FE0D11'
RETURNS int AS
BEGIN
Declare @countAll int =( select  count(errortype) from importstandardfiles_ErrorLists  where 
    uniqueIdentifier =@uuid and 
    status = 0 group by uniqueIdentifier
)
if(@countAll is null)
begin
set @countAll=0
end
    if(@countAll =       
    (select  count(errortype) from importstandardfiles_ErrorLists  where 
    uniqueIdentifier =@uuid and 
    status = 0 and errortype in (select code from ErrorType where errorgroupid = 3)   group by uniqueIdentifier having count(Errortype)>=1))
begin
--print 1
RETURN 1
end
RETURN 0
END;

--select * from errortype where code = 529
--select  count(errortype) from importstandardfiles_ErrorLists  where 
--    uniqueIdentifier ='1CC6DA24-5EB2-4AEA-BA25-E2A963FE0D11' and 
--    status = 0 and 
--errortype in (select code from ErrorType where errorgroupid = 3)   group by uniqueIdentifier having count(Errortype)>1

--select * from importmaster_errorlists where uniqueidentifier = '361B6A4E-DF40-4430-968F-17B06014FFEA'

--select * from importmaster_ErrorLists where 
--    uniqueIdentifier ='3653A312-7A74-4B4F-9A52-165149625E24' and 
--    status = 0
GO
