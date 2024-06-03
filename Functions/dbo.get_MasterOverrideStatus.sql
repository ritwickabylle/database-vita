SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[get_MasterOverrideStatus] (@uuid uniqueidentifier)
RETURNS int AS
BEGIN
Declare @countAll int =( select  count(errortype) from importmaster_ErrorLists where 
    uniqueIdentifier =@uuid and 
    status = 0 group by uniqueIdentifier
)
if(@countAll is null)
begin
set @countAll=0
end
    if(@countAll =       
    (select  count(errortype) from importmaster_ErrorLists where 
    uniqueIdentifier =@uuid and 
    status = 0 and errortype in (select code from ErrorType where errorgroupid = 3)   group by uniqueIdentifier having count(Errortype)>=1))
begin
RETURN 1
end
RETURN 0
END;

--select * from importmaster_errorlists where uniqueidentifier = '361B6A4E-DF40-4430-968F-17B06014FFEA'

--select * from importmaster_ErrorLists where 
--    uniqueIdentifier ='3653A312-7A74-4B4F-9A52-165149625E24' and 
--    status = 0
GO
