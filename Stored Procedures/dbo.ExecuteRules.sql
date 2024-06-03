SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[ExecuteRules]
(
@RuleGroupId int =1,
@tenantId int=2,
@importBatchId int=88
)
AS
BEGIN


--select count(*) from ImportBatchData where batchid=21

--select * from rulesenginelog
--delete from rulebatch

--select * from ruleGroup
update ImportBatchData set PaymentMeans = 'In Cash' where batchid = @importBatchId and PaymentMeans='' or PaymentMeans is null    

declare @ParentTable nvarchar(max) = (select parentTable from rulegroup where id = @RuleGroupId)

 --select count(*) from ImportBatchData WHERE   InvoiceType LIKE 'Sales%' AND UPPER(TRIM(RIGHT(InvoiceType,LEN(invoicetype) - CHARINDEX('-', invoicetype)))) NOT IN (select upper(invoice_flags) from invoiceindicators)


--declare @query nvarchar(max) = 'SELECT @output=count(e.id) FROM '+ @ParentTable +' e' ;
--declare @query nvarchar(max) = 'insert into RulesEngineLog(TableName,RecordId,errorCode,isSuccess,batchId) values('+@ParentTable+',e.id,@error_code,0,@batchId) FROM '+ @ParentTable +' e' ;

declare @sql nvarchar(max);
declare @desc nvarchar(max);
declare @joins nvarchar(max);
declare @error_code  nvarchar(max);
declare @stop_condition  int;
declare @next_rule_on_success int;
declare @next_rule_on_failure int;
declare @output int;
declare @count int=0;
declare @skip int=0;



declare @v_sql CURSOR;
set @v_sql= 
CURSOR FOR
--declare @rule_module nvarchar(max)= 'Sales Invoice';
select r.SqlStatement,r.OnSuccessNext,r.OnFailureNext,r.errorCode,r.StopCondition from [Rule] r
where r.RuleGroupId=@RuleGroupId
order by r.[Order]

-- run for each record in the parent table
declare @fromId int;
declare @toId int;
set @sql = 'SELECT @fromId=min(id),@toId=max(id) FROM ' + QUOTENAME(@ParentTable)+' where batchId='+cast(@importBatchId as nvarchar)
exec sp_executesql @sql ,@Params = N'@fromId INT OUTPUT,@toId INT OUTPUT', @fromId = @fromId OUTPUT, @toId = @toId OUTPUT;

insert into RuleBatch(RuleGroupId,ExecutionTime) values(@RuleGroupId,getdate())
declare @batchId int = SCOPE_IDENTITY()


declare @query nvarchar(max) = 'insert into RulesEngineLog(TableName,RecordId,errorCode,isSuccess,batchId,refBatchId) select '''+@ParentTable+''',e.id,@error_code,0,'''+cast(@batchId as nvarchar)+''',@batchNo FROM '+ @ParentTable +' e' ;


--use exec to get the min and max id from the parent table

--while @fromId<=@toId

--begin
--	set @fromId=@fromId+1
--	set @count=0
--	set @skip=0
--	set @output=0




OPEN @v_sql
FETCH NEXT 
FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition;
WHILE @@FETCH_STATUS = 0
BEGIN
   set @count=@count+1;
   

   set @sql = @query + ' WHERE ' + @sql + ' and e.batchId='+cast(@importBatchId as nvarchar) ;
   print @sql
   EXECUTE sp_executesql @SQL,@Params = N'@tenantId INT,@batchNo INT,@error_code INT', @tenantId = @tenantId, @batchNo = @importBatchId
      , @error_code=@error_code;

  --EXECUTE sp_executesql @SQL,@Params = N'@output
  --INT OUTPUT,@id INT,@tenantId INT,@batchNo INT', @id = @fromId, @tenantId = @tenantId, @batchNo = @batchId
  --    , @output = @output OUTPUT;

	 -- if(@output=0)
	 --   begin 
		--	EXECUTE sp_executesql @on_success,@Params = N'@id INT', @id = @fromId
		--	 if(@next_rule_on_success is not null)
		--	 	begin
		--	 		set @skip=@next_rule_on_success-@count-1
		--	 		while @@FETCH_STATUS = 0 and @skip>0
		--	 			begin
		--	 				FETCH NEXT FROM @v_sql INTO @sql, @desc,@next_rule_on_success,@next_rule_on_failure,@on_success,@on_failure,@stop_condition;
		--	 				set @skip = @skip-1
		--	 			end
		--	 	end
  --           insert into RulesEngineLog(TableName,RecordId,errorCode,isSuccess,batchId) values(@ParentTable,@fromId,@error_code,1,@batchId)
		--	print 'Success:'+@error_code
		--	if(@stop_condition=1)
		--		begin
		--		break
		--		end
		--end
	 -- else if(@output>=1)
	 --   begin
		--	EXECUTE sp_executesql @on_failure,@Params = N'@id INT', @id = @fromId
		--	 if(@next_rule_on_success is not null)
		--	 	begin
		--	 		set @skip=@next_rule_on_success-@count-1
		--	 		while @@FETCH_STATUS = 0 and @skip>0
		--	 			begin
		--	 				FETCH NEXT FROM @v_sql INTO @sql, @desc,@next_rule_on_success,@next_rule_on_failure,@on_success,@on_failure,@stop_condition;
		--	 				set @skip = @skip-1
		--	 			end
		--	 	end
  --           insert into RulesEngineLog(TableName,RecordId,errorCode,isSuccess,batchId) values(@ParentTable,@fromId,@error_code,0,@batchId)
		--	print 'Failed:'+ @error_code
		--	if(@stop_condition=2)
		--		begin 
		--		break
		--		end
		--end

		--if(@stop_condition=3)
		--	begin 
		--		break
		--	end
	
	
	FETCH NEXT 
	FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition;

END

CLOSE @v_sql


DEALLOCATE @v_sql

update RuleBatch set Failed=(select count(distinct recordId) as recordId from RulesEngineLog where isSuccess=0 and  batchId=@batchId ),
Success=(select count(distinct recordId) as recordId from RulesEngineLog where isSuccess=1 and batchId=@batchId and  recordId not in 
(select recordId from RulesEngineLog where isSuccess=0 and  batchId=@batchId ) ) where id=@batchId


select @output

END
GO
