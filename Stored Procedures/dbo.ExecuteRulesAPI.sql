SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         PROCEDURE [dbo].[ExecuteRulesAPI]      
(      
@RuleGroupId int=3 ,      
@tenantId int=131,      
@json nvarchar(max)=N'{
  "Identifier": "1",
  "Name": "FG-0250-13-0014",
  "Description": "250ml FANTA SPLASH ULTRA NRB ORANGE",
  "BuyerIdentifier": "",
  "SellerIdentifier": null,
  "StandardIdentifier": null,
  "Quantity": 126280.0,
  "UOM": "Bottle",
  "UnitPrice": 0.312663,
  "CostPrice": 0.0,
  "DiscountPercentage": 0.0,
  "DiscountAmount": 0.0,
  "GrossPrice": 41246.84,
  "NetPrice": 41246.84,
  "VATRate": 15.0,
  "VATCode": "S",
  "VATAmount": 6187.03,
  "LineAmountInclusiveVAT": 47433.87,
  "CurrencyCode": "SAR",
  "TaxSchemeId": null,
  "Notes": null,
  "ExcemptionReasonCode": null,
  "ExcemptionReasonText": null,
  "Language": null,
  "AdditionalData1[0].descriptionAr": "قارورة فانتا سبلاش برتقال-250ملي",
  "AdditionalData2[0].delivery_note_number": "15155663",
  "AdditionalData2[0].date_of_supply": "18-MAY-23",
  "isOtherCharges": false,
  "isDeleted": false,
  "uuid": "ce83ee1f-a321-47f0-89b2-65e1c23c5afb"
}'
)      
AS      
BEGIN  
declare @json1 nvarchar(max)
IF(@RuleGroupId =3)
BEGIN
SELECT @json1 = 
    JSON_QUERY('
        {
            "Identifier": "' + Identifier + '",
            "Name": "' + Name + '",
            "Description": "' + Description + '",
            "BuyerIdentifier": "' + BuyerIdentifier + '",
            "SellerIdentifier": ' + ISNULL('"' + SellerIdentifier + '"', 'null') + ',
            "StandardIdentifier": ' + ISNULL('"' + StandardIdentifier + '"', 'null') + ',
            "Quantity": ' + CAST(Quantity AS NVARCHAR(MAX))  + ',
            "UOM": "' + UOM + '",
            "UnitPrice": ' + CAST(UnitPrice AS NVARCHAR(MAX)) + ',
            "CostPrice": ' + CAST(CostPrice AS NVARCHAR(MAX)) + ',
            "DiscountPercentage": ' + CAST(DiscountPercentage AS NVARCHAR(MAX)) + ',
            "DiscountAmount": ' + CAST(DiscountAmount AS NVARCHAR(MAX)) + ',
            "GrossPrice": ' + CAST(GrossPrice AS NVARCHAR(MAX)) + ',
            "NetPrice": ' + CAST(NetPrice AS NVARCHAR(MAX)) + ',
            "VATRate": ' + CAST(VATRate AS NVARCHAR(MAX)) + ',
            "VATCode": "' + VATCode + '",
            "VATAmount": ' + CAST(VATAmount AS NVARCHAR(MAX)) + ',
            "LineAmountInclusiveVAT": ' + CAST(LineAmountInclusiveVAT AS NVARCHAR(MAX)) + ',
            "CurrencyCode": "' + CurrencyCode + '",
            "TaxSchemeId": ' + ISNULL('"' + TaxSchemeId + '"', 'null') + ',
            "Notes": ' + ISNULL('"' + Notes + '"', 'null') + ',
            "ExcemptionReasonCode": ' + ISNULL('"' + ExcemptionReasonCode + '"', 'null') + ',
            "ExcemptionReasonText": ' + ISNULL('"' + ExcemptionReasonText + '"', 'null') + ',
            "Language": ' + ISNULL('"' + Language + '"', 'null') + ',
            "AdditionalData1": {
                "descriptionAr": ' + ISNULL('"' +  AdditionalData1 + '"', 'null') + '
            },
            "AdditionalData2": {
                "delivery": ' + ISNULL('"' +  AdditionalData2delivery + '"', 'null') + ',
                "date_of_supply": ' + ISNULL('"' +  AdditionalData2dateofsupply + '"', 'null') + '
            },
            "isOtherCharges": ' + IIF(isOtherCharges = 1, 'true', 'false') + ',
            "isDeleted": ' + IIF(isDeleted = 1, 'true', 'false') + ',
            "uuid": "' + uuid + '"
        }')
FROM OPENJSON(@json)
WITH (
    Identifier NVARCHAR(255),
    Name NVARCHAR(255),
    Description NVARCHAR(255),
    BuyerIdentifier NVARCHAR(255),
    SellerIdentifier NVARCHAR(255) '$.SellerIdentifier' ,
    StandardIdentifier NVARCHAR(255) '$.StandardIdentifier' ,
    Quantity DECIMAL(18, 2),
    UOM NVARCHAR(255),
    UnitPrice float,
    CostPrice DECIMAL(18, 2),
    DiscountPercentage DECIMAL(18, 2),
    DiscountAmount DECIMAL(18, 2),
    GrossPrice DECIMAL(18, 2),
    NetPrice DECIMAL(18, 2),
    VATRate DECIMAL(18, 2),
    VATCode NVARCHAR(255),
    VATAmount DECIMAL(18, 2),
    LineAmountInclusiveVAT DECIMAL(18, 2),
    CurrencyCode NVARCHAR(255),
    TaxSchemeId NVARCHAR(255) '$.TaxSchemeId' ,
    Notes NVARCHAR(MAX) '$.Notes' ,
    ExcemptionReasonCode NVARCHAR(255) '$.ExcemptionReasonCode' ,
    ExcemptionReasonText NVARCHAR(MAX) '$.ExcemptionReasonText' ,
    Language NVARCHAR(255) '$.Language' ,
    AdditionalData1 NVARCHAR(255) '$.AdditionalData1[0].descriptionAr' ,
    AdditionalData2delivery NVARCHAR(MAX) '$.AdditionalData2[0].delivery_note_number',
	 AdditionalData2dateofsupply NVARCHAR(MAX) '$.AdditionalData2[0].date_of_supply',
    isOtherCharges BIT,
    isDeleted BIT,
    uuid NVARCHAR(255)
)
END
ELSE
BEGIN
SET @json1=@json
END

declare @query nvarchar(max)=''      
declare @ParentTable nvarchar(max) = (select parentTable from rulegroup where id = @RuleGroupId)      
declare @SelectQuery nvarchar(max)=''
declare @jsonData AS dbo.DataDictionaryType

IF(@RuleGroupId =2)
begin
set @SelectQuery  = 'select * from  OPENJSON(@json)'      
INSERT into @jsonData execute sp_executesql @SelectQuery,@Params = N'@json nvarchar(max)', @json =@json    
end
else
begin
set @SelectQuery = 'select * from  OPENJSON(@json1)'      
INSERT into @jsonData execute sp_executesql @SelectQuery,@Params = N'@json1 nvarchar(max)', @json1 =@json1     
end
    
Declare @uuid as nvarchar(500)= (select [value] from @jsonData where [key]='uuid')     
      
DECLARE @cols AS NVARCHAR(MAX)      
      
select @cols = STUFF((SELECT ',' + QUOTENAME([key])       
                    from @jsonData      
                    group by [key], [value]      
                    order by [key]      
            FOR XML PATH(''), TYPE      
            ).value('.', 'NVARCHAR(MAX)')       
        ,1,1,'')    
		
		--print @cols
      
declare @TransformQuery nvarchar(max) = N'(SELECT ' + @cols + N' from       
             (      
                select [value], [key]      
                from @jsonData      
            ) x      
            pivot       
            (      
                max(value)      
                for [key] in (' + @cols + N')      
            ) p ) as t'      
      
      
declare @sql nvarchar(max);      
declare @desc nvarchar(max);      
declare @field nvarchar(max);      
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
select r.SqlStatement,r.OnSuccessNext,r.OnFailureNext,r.errorCode,r.StopCondition,r.[key] from [Rule] r      
where r.RuleGroupId=@RuleGroupId and r.isActive=1   
and  ((r.TenantId=@tenantId and (select count(*) from [Rule] where tenantId=@tenantId)>0)  
or (r.TenantId is null and (select count(*) from [Rule] where tenantId=@tenantId)=0))
order by r.[Order]      

declare @batchId int = (select max(batchId) from RulesEngineLog)+1      
   -------------------------    
   if(@RuleGroupId=3)    
   begin    
 set @query = 'INSERT INTO tmp_items(
 [AdditionalData1],
 [AdditionalData2],
 [BuyerIdentifier],
 [CostPrice],
 [CurrencyCode]
 ,[Description]
 ,[DiscountAmount]
 ,[DiscountPercentage]
 ,[ExcemptionReasonCode]
 ,[ExcemptionReasonText]
 ,[GrossPrice]
 ,[Identifier]
 ,[isDeleted]
 ,[isOtherCharges]
 ,[Language]
 ,[LineAmountInclusiveVAT]
 ,[Name]
 ,[NetPrice]
 ,[Notes]
 ,[Quantity]
 ,[SellerIdentifier]
 ,[StandardIdentifier]
 ,[TaxSchemeId]
 ,[UnitPrice]
 ,[UOM]
 ,[uuid]
 ,[VATAmount]
 ,[VATCode]
 ,[VATRate]
) SELECT * FROM '+@TransformQuery;   

--select * from  @jsonData

EXECUTE sp_executesql @query,@Params = N'@jsonData dbo.DataDictionaryType READONLY', @jsonData = @jsonData;    
end    
 -------------------------    
set @query  = 'insert into RulesEngineLog(TableName,Field,errorCode,isSuccess,batchId,refBatchId) select '''+@ParentTable+''',@field,@error_code,0,'''+cast(@batchId as nvarchar)+''',null FROM '+@TransformQuery;      
      
      
OPEN @v_sql      
FETCH NEXT       
FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition,@field;      
WHILE @@FETCH_STATUS = 0      
BEGIN      
   set @count=@count+1;      
      print @sql    
   set @sql = @query + ' WHERE ' + @sql  ;      
   EXECUTE sp_executesql @SQL,@Params = N'@jsonData dbo.DataDictionaryType READONLY,@error_code INT,@field nvarchar(max),@items_uuid nvarchar(500)', @jsonData = @jsonData, @error_code=@error_code,@field=@field,@items_uuid=@uuid;      
      
 FETCH NEXT       
 FROM @v_sql INTO @sql,@next_rule_on_success,@next_rule_on_failure,@error_code,@stop_condition,@field;      
      
END      
      
CLOSE @v_sql      
      
      
DEALLOCATE @v_sql      
    
 if(@RuleGroupId<>3)    
   begin    
delete from tmp_items where uuid=@uuid;      
  end    
 select STUFF((SELECT e.ZatcaCode+'--'+e.ZatcaErrorMessage  +';'    
                    from RulesEngineLog r      
     inner join CustomErrorType e      
     on r.errorCode = e.Code      
     where r.batchId=@batchId and e.IsActive=1      
            FOR XML PATH(''), TYPE      
            ).value('.', 'NVARCHAR(MAX)')       
        ,1,0,'') as error      
    
 --select '' as error    
      
      
END
GO
