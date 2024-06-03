SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     FUNCTION [dbo].[get_WHTDTTSpecialRate] (@uuid uniqueidentifier)   --SELECT dbo.get_WHTDTTSpecialRate('5777C272-7C73-449E-BEEB-BA6F60F6EDBE')
RETURNS int AS
BEGIN
Declare @SpecialStatus int 
declare @sql nvarchar(max)
declare @sql1 nvarchar(max)
--declare @ruleid int

begin
set @SpecialStatus=0
end

set @sql = (select rulecommand from whtrules r inner join whtdttrates w on r.ruleid = w.ruleid
inner join VI_importstandardfiles_Processed v on upper(v.NatureofServices) = upper(w.servicename)  
   and left(v.buyercountrycode,2) = w.alphacode where v.uniqueidentifier = @uuid)

set @sql1 = 'select 1 as specialstatus from vi_importstandardfiles_processed v where v.uniqueidentifier ='''+ CONVERT(varchar(max), @uuid) +''' and ' + @sql

 
--insert into logs(json,date,batchid) values (@sql,getdate(),@specialstatus)

execute sp_executesql @sql1

if @@rowcount > 0
begin
  set @specialstatus = 1
end

--select * from logs
--print @sql

--select * from batchdata
--upper(v.VenderConstitution) not like %PARTNER% and upper(v.VendorConstitution) <> LLP and   v.PercaptailholdingForiegnCo >= 25 and v.CapitalInvestmentDate is not null
--print @sql1

RETURN @specialstatus

end;

-- select * from vi_importstandardfiles_processed
--select * from importmaster_errorlists where uniqueidentifier = '361B6A4E-DF40-4430-968F-17B06014FFEA'

--select * from importmaster_ErrorLists where 
--    uniqueIdentifier ='3653A312-7A74-4B4F-9A52-165149625E24' and 
--    status = 0

--select * from logs order by id desc

--select * from batchdata
GO
