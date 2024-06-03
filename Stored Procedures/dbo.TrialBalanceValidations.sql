SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

            
CREATE      procedure [dbo].[TrialBalanceValidations]  --  exec [TrialBalanceValidations] @json,0,'2023-01-01','2023-12-31'                     
(          
@json NVARCHAR(MAX) = N'
[{"CIBalance":"6000000","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011010","GLGroup":"Fixed Asset ","GLName":"Siafa Farm Qaseem - Land","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":1,"xml_uuid":"3532fa53-1290-4ae8-a312-4715174e1ec9"},{"CIBalance":"11361199.03","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011001","GLGroup":"Fixed Asset ","GLName":"Factory Building","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":2,"xml_uuid":"b8e7ebbf-7e0e-42e5-8754-5d313bd0c1aa"},{"CIBalance":"485876.86","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011002","GLGroup":"Fixed Asset ","GLName":"Warehouse Building","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":3,"xml_uuid":"ee475f77-113c-4374-8a1a-c7d5f56ac26a"},{"CIBalance":"-3072964.8940000003","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021001","GLGroup":"Fixed Asset ","GLName":"ACD - Factory Building","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":4,"xml_uuid":"79ceb132-db48-4dee-8c26-9ce745c40359"},{"CIBalance":"-37944.455","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021002","GLGroup":"Fixed Asset ","GLName":"ACD - Warehouse Building","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":5,"xml_uuid":"0b65b4dc-f376-43ad-bdec-ba0be6d474eb"},{"CIBalance":"7686111.074","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011009","GLGroup":"Fixed Asset ","GLName":"Appliances, Coolers & Freezers - Factory","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":6,"xml_uuid":"fd45de7f-edbc-41d3-bfc1-2951457ba040"},{"CIBalance":"-7121098.417","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021009","GLGroup":"Fixed Asset ","GLName":"ACD -Appliances, Coolers & Freezers - Factory","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":7,"xml_uuid":"e17c4e82-7be2-4714-b329-fb0efd9c2cbd"},{"CIBalance":"2998162.5","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011015","GLGroup":"Fixed Asset ","GLName":"Office Building","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":8,"xml_uuid":"6a53dac2-08fe-4b82-ac7b-20c443c26bf8"},{"CIBalance":"-2532535.1650000005","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021015","GLGroup":"Fixed Asset ","GLName":"ACD -Office Building","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":9,"xml_uuid":"f31f5a24-9e7c-4c21-ad4c-cf15fc257529"},{"CIBalance":"13225596.13","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011003","GLGroup":"Fixed Asset ","GLName":"Plant and Machinery","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":10,"xml_uuid":"b1a6cfb5-c527-447c-9a21-1974c4974d2d"},{"CIBalance":"2692105.5999999996","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011004","GLGroup":"Fixed Asset ","GLName":"Factory Tools and Equipments","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":11,"xml_uuid":"631ce289-5e48-4f02-a1f9-698d8ece01ca"},{"CIBalance":"65845.56999999999","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011006","GLGroup":"Fixed Asset ","GLName":"Office Tools and Equipments","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":12,"xml_uuid":"8622eb82-c57a-4bde-a1ae-a40f63386d2f"},{"CIBalance":"-5998853.874","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021003","GLGroup":"Fixed Asset ","GLName":"ACD -Plant and Machinery","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":13,"xml_uuid":"9ad6a8b6-ea38-4939-aa15-2ae0b22d0d05"},{"CIBalance":"-2255880.5439999998","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021004","GLGroup":"Fixed Asset ","GLName":"ACD - Factory Tools and Equipments","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":14,"xml_uuid":"718f1e78-b97d-4001-8306-9b0b3a4cdb82"},{"CIBalance":"-41728.886","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021006","GLGroup":"Fixed Asset ","GLName":"ACD -Office Tools and Equipments","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":15,"xml_uuid":"248ddc7c-36a9-445e-a563-d10836525956"},{"CIBalance":"11116677.65","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011011","GLGroup":"Fixed Asset ","GLName":"Vehicles Owned","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":16,"xml_uuid":"69c076a5-6257-4ac5-b38d-c833ecea1224"},{"CIBalance":"-9583328.466000002","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021011","GLGroup":"Fixed Asset ","GLName":"ACD - Vehicles Owned","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":17,"xml_uuid":"5e695526-c281-4579-83b9-776c7a16a302"},{"CIBalance":"1518624.26","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011005","GLGroup":"Fixed Asset ","GLName":"Pallets Rack","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":18,"xml_uuid":"3cfcd4e9-4858-4899-bb21-ef2d230896cd"},{"CIBalance":"-1031164.9450000001","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021005","GLGroup":"Fixed Asset ","GLName":"ACD -Pallets Rack","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":19,"xml_uuid":"eb8ef879-7560-4f13-95a3-65298dc8c019"},{"CIBalance":"505130.89400000003","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011012","GLGroup":"Fixed Asset ","GLName":"Furniture and Fixtures Office","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":20,"xml_uuid":"aa67c638-3aa2-40ee-9a40-c3d37f178be6"},{"CIBalance":"184697.77300000002","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011017","GLGroup":"Fixed Asset ","GLName":"Furniture and Fixtures  - Factory","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":21,"xml_uuid":"9ddb961a-fb1c-4417-a5d9-d30a3ee3354e"},{"CIBalance":"-491485.442","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021012","GLGroup":"Fixed Asset ","GLName":"ACD - Furniture and Fixtures Office","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":22,"xml_uuid":"d8725075-1ee1-47e0-98a0-038204ca3e96"},{"CIBalance":"-98106.53199999999","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021017","GLGroup":"Fixed Asset ","GLName":"ACD - Furniture and Fixtures  - Factory","OPBalance":"","OpBalanceType":"","TaxCode":"13404","ID":23,"xml_uuid":"2a61b5cb-35ea-47b0-b276-d56b480756db"},{"CIBalance":"1993961.9409999999","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011007","GLGroup":"Fixed Asset ","GLName":"Electrical Equipments","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":24,"xml_uuid":"f9c59ad8-65c3-4292-a71b-70146bc2bab9"},{"CIBalance":"-1864897.712","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021007","GLGroup":"Fixed Asset ","GLName":"ACD - Electrical Equipments","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":25,"xml_uuid":"9a7f07be-110c-4a71-915b-a5772db21e96"},{"CIBalance":"586408.93","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011016","GLGroup":"Fixed Asset ","GLName":"Appliances, Coolers & Freezers Office","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":26,"xml_uuid":"cc2b5d01-0f0f-4b45-a20d-af331e0ec618"},{"CIBalance":"-565106.6780000001","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021016","GLGroup":"Fixed Asset ","GLName":"ACD -Appliances, Coolers & Freezers Office","OPBalance":"","OpBalanceType":"","TaxCode":"13404","ID":27,"xml_uuid":"42e7b05c-b18b-4193-a34d-5678b8b4fc85"},{"CIBalance":"323507.40200000006","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011014","GLGroup":"Fixed Asset ","GLName":"Computer and Hardware Office","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":28,"xml_uuid":"cee9f1f6-0d3a-4d46-9d26-e710c0fd564b"},{"CIBalance":"71934.552","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011018","GLGroup":"Fixed Asset ","GLName":"Computer and Hardware - Factory","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":29,"xml_uuid":"b06bb3d8-2226-44e2-8c75-e3cb2cd2b7e4"},{"CIBalance":"-55626.493","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021018","GLGroup":"Fixed Asset ","GLName":"ACD - Computer and Hardware - Factory","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":30,"xml_uuid":"f6a99ce2-e6c3-4266-a021-ab2f710dbf42"},{"CIBalance":"-271852.501","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021014","GLGroup":"Fixed Asset ","GLName":"ACD - Computer and Hardware Office","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":31,"xml_uuid":"a98bc590-add0-4ae0-adc3-2dfd2f29c824"},{"CIBalance":"5787346.741","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011019","GLGroup":"Fixed Asset ","GLName":"Water Boring & Pipes ","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":32,"xml_uuid":"06046d15-5a1d-4ad8-89f9-784fe19b0b49"},{"CIBalance":"-2477177.434","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11021019","GLGroup":"Fixed Asset ","GLName":"ACD - Water Borings & Pipes","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":33,"xml_uuid":"bdf088c4-5b4b-456d-a9bf-dbd3a4e4e32a"},{"CIBalance":"2333.86600000004","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11031002","GLGroup":"Fixed Asset ","GLName":"Asset Under Construction - Siafa Farm Qaseem","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":34,"xml_uuid":"ccf50d29-6216-4028-9ece-b7a3cf92cb2b"},{"CIBalance":"1","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11031004","GLGroup":"Fixed Asset ","GLName":"New Madinah Factory-II","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":35,"xml_uuid":"256132ae-b345-4d60-a681-e33209437a34"},{"CIBalance":"115510","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11011022","GLGroup":"Intangible ","GLName":"Computer software","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":36,"xml_uuid":"f0593553-cda4-4baf-8985-d91c693f9650"},{"CIBalance":"-72612.36","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11029999","GLGroup":"Intangible ","GLName":"Accumulated Amortization - Computer Software","OPBalance":"","OpBalanceType":"","TaxCode":"13403","ID":37,"xml_uuid":"9cec50b7-a0f6-4255-81c0-f0783dc4b695"},{"CIBalance":"-29148666.97","CIBalanceType":"","Credit":"","Debit":"","GLCode":"11031015","GLGroup":"Prepaid Balances ","GLName":"Siafa Farm Qaseem - Leasedhold land","OPBalance":"","OpBalanceType":"","TaxCode":"13402","ID":38,"xml_uuid":"ee49d374-1f4a-4ac9-9618-26a0dec8b4d8"}]',
@tenantid bigint = 148,          
@userid int=null,          
@fromdate date = '2023-01-01',         
@todate date ='2023-12-31' ,
@isCreditNegative BIT=1
)                            
as                            
Begin                            
DROP TABLE IF EXISTS ##TBDataTemp;         
DROP TABLE IF EXISTS ##TBDataTempIntermediate;         
      
SELECT * INTO ##TBDataTempIntermediate      
FROM OPENJSON(@json)          
WITH           
(          
  GLCode NVARCHAR(MAX),          
  GLName NVARCHAR(MAX),          
  GLGroup NVARCHAR(MAX),          
  OPBalance NVARCHAR(MAX),          
  OpBalanceType NVARCHAR(MAX),          
  Debit NVARCHAR(MAX),          
  Credit NVARCHAR(MAX),          
  CIBalance NVARCHAR(MAX),          
  CIBalanceType NVARCHAR(MAX),          
  TaxCode NVARCHAR(MAX)          
);      
      
      
SELECT      
  GLCode,      
  GLName,      
  NULLIF(LTRIM(RTRIM(GLGroup)), '') AS GLGroup,  
  CONVERT(DECIMAL(18,2), NULLIF(OPBalance, '')) AS OPBalance,      
  OpBalanceType,      
  CONVERT(DECIMAL(18,2), NULLIF(Debit, '')) AS Debit,      
  CONVERT(DECIMAL(18,2), NULLIF(Credit, '')) AS Credit,      
  CONVERT(DECIMAL(18,2), NULLIF(CIBALANCE, '')) AS CIBALANCE,     
  CIBALANCETYPE,      
  TaxCode      
INTO ##TBDataTemp      
FROM ##TBDataTempIntermediate;        
          
--SELECT * FROM ##TBDataTemp  
    
declare @tbtotalop as decimal(18,2)          
declare @tbtotalcl as decimal(18,2)          
declare @isinvalidglname bit              
declare @isinvalidglcode bit          
declare @isinvalidclbaltype bit            
declare @isinvalidopbaltype BIT          
DECLARE @ErrorMessages NVARCHAR(MAX) = ''        
declare @glnameblank bit    
          
begin                    
--validate glname          
  
     
 IF EXISTS(SELECT 1 FROM ##TBDataTemp where glname is null or glname ='')    
 BEGIN    
  set @ErrorMessages+='GL Name cannot be blank ';          
    
    
 END    
          
SELECT @isinvalidglname= CASE          
    WHEN           
   EXISTS (SELECT glname,count(*) as cnt FROM ##tbdatatemp  group by GLName having count(*) > 1  )         
    THEN 1          
    ELSE 0          
END          
FROM ##TBDataTemp;      
          
if @isinvalidglname=1          
begin          
 set @ErrorMessages+='GL Name should not be Duplicate,';          
end          
  
IF EXISTS(SELECT 1 FROM  [dbo].CIT_TrailBalance TB  
  INNER JOIN ##TBDataTemp T ON TB.GLCode = T.GLCode AND TB.GLName = T.GLName  
  WHERE TB.TenantId = @tenantId  
   AND TB.FinancialStartDate = @fromdate  
   AND TB.FinancialEndDate = @todate)   
BEGIN  
 UPDATE T  
 SET  
  [TaxCode] = T.[TaxCode],  
  [GLGroup]=T.GLGroup  
 FROM [dbo].CIT_TrailBalance M  
 INNER JOIN ##TBDataTemp T ON M.GLCode = T.GLCode AND M.GLName = T.GLName AND M.TaxCode = T.TaxCode  
 WHERE M.TenantId = @tenantId  
  AND M.FinancialStartDate = @fromdate  
  AND M.FinancialEndDate = @todate;  
  
END  
     
   --SELECT * FROM ##TBDataTemp  
--glcode           
SELECT @isinvalidglcode= CASE          
    WHEN           
   EXISTS (SELECT GLCode,count(*) as cnt FROM ##TBDataTemp   group by GLCode having count(*) > 1          
 ) OR EXISTS(SELECT 1 FROM CIT_TrailBalance WHERE GLName=##tbdatatemp.GLCode and TenantId = @tenantid AND          
   FinancialStartDate = @fromdate AND FinancialEndDate = @todate)          
    THEN 1          
    ELSE 0          
END          
FROM ##TBDataTemp;          
          
if @isinvalidglcode=1          
begin          
 set @ErrorMessages+='GL code should not be Duplicate,';          
          
end          
          
--validate cl baltype          
          
SELECT @isinvalidclbaltype = CASE          
    WHEN EXISTS (          
        SELECT 1          
FROM ##TBDataTemp t          
        WHERE t.CIBALANCETYPE IS NOT NULL          
            AND EXISTS (          
                SELECT 1          
                FROM CIT_TrailBalance c          
                WHERE c.TenantId = @tenantid          
                  AND c.FinancialStartDate = @fromdate          
                  AND c.FinancialEndDate = @todate          
       AND c.CIBALANCETYPE IN ('C', 'D', 'Credit', 'Debit', 'Cr', 'Dr')          
                  AND (          
                      (t.CIBALANCETYPE IN ('C', 'D') AND c.CIBALANCETYPE NOT IN ('C', 'D')) OR          
                      (t.CIBALANCETYPE IN ('Debit', 'Credit') AND c.CIBALANCETYPE NOT IN ('Debit', 'Credit')) OR          
                      (t.CIBALANCETYPE IN ('Cr', 'Dr') AND c.CIBALANCETYPE NOT IN ('Cr', 'Dr'))          
                  )          
            )          
    ) THEN 1          
    ELSE 0          
END;          
          
if @isinvalidclbaltype=1          
begin          
 set @ErrorMessages+='Valid cl Balance types are (C/D) or (Cr/Dr) or (Credit/Debit),'          
end          
          
--else          
--begin          
--   update ##TBDataTemp set CIBALANCE = abs(CIBALANCE) where CIBALANCETYPE in ('D','Dr','Debit')           
          
--   update ##TBDataTemp set CIBALANCE = 0-CIBALANCE where CIBALANCETYPE in ('C','Cr','Credit')          
--   update ##TBDataTemp set CIBALANCETYPE = ''          
--end          
          
          
--validating cl trial balance  
set @tbtotalcl = (select sum(CIBALANCE) from ##tbdatatemp)          
          
if cast(@tbtotalcl as numeric) <> 0          
begin          
  set @ErrorMessages+='CL Trial Balance mismatch ,can not proceed';          
end          
           
          
--validate op baltype          
          
SELECT @isinvalidopbaltype = CASE          
    WHEN EXISTS (          
        SELECT 1          
        FROM ##TBDataTemp t          
        WHERE t.OpBalanceType IS NOT NULL          
            AND EXISTS (          
                SELECT 1          
                FROM CIT_TrailBalance c          
                WHERE c.TenantId = @tenantid          
                  AND c.FinancialStartDate = @fromdate          
                  AND c.FinancialEndDate = @todate          
                  AND c.OpBalanceType IN ('C', 'D', 'Credit', 'Debit', 'Cr', 'Dr')          
                  AND (          
                      (t.OpBalanceType IN ('C','D') AND c.OpBalanceType NOT IN ('C', 'D')) OR          
                      (t.OpBalanceType IN ('Debit','Credit') AND c.OpBalanceType NOT IN ('Debit','Credit')) OR          
                      (t.OpBalanceType IN ('Cr', 'Dr') AND c.OpBalanceType NOT IN ('Cr', 'Dr'))          
                  )          
            )          
    )          
    THEN 1          
    ELSE 0          
END;          
          
if @isinvalidOPbaltype=1          
begin          
 set @ErrorMessages+='Valid OP Balance types are (C/D) or (Cr/Dr) or (Credit/Debit),'          
end          
          
--else          
--begin          
--   update CIT_TrailBalance set OPBalance = abs(OPBalance) where OpBalanceType in ('D','Dr','Debit')     
--   and TenantId = @tenantid AND FinancialStartDate = @fromdate AND FinancialEndDate = @todate          
--   update CIT_TrailBalance set OPBalance = 0-OPBalance where OpBalanceType in ('C','Cr','Credit')          
--   and TenantId = @tenantid AND FinancialStartDate = @fromdate AND FinancialEndDate = @todate          
--   update CIT_TrailBalance set OpBalanceType = ''          
--   where TenantId = @tenantid AND FinancialStartDate = @fromdate AND FinancialEndDate = @todate          
--end          
          
          
--validating op trial balance          
set @tbtotalop = (select sum(opbalance) from ##tbdatatemp)          
          
if cast(@tbtotalop as numeric) <> 0          
begin          
  set @ErrorMessages+=' OP Trial Balance mismatch ,can not proceed';          
end          
          
    
--validate debit          
if exists(select 1 from ##TBDataTemp where Debit<0)          
begin          
 set @ErrorMessages+='Debit can not be negative';          
end          
          
          
--Validate credit          
          
if exists(select 1 from ##TBDataTemp where Credit>0)          
begin          
 set @ErrorMessages+='Credit can not be Positive';          
end          
          
--printing errors for glname , baltype and trial balance          
IF @ErrorMessages <> ''          
    BEGIN          
        SELECT ErrorStatus = 1, ErrorMessage = @ErrorMessages;          
END          
else          
begin       
  
   
  --SELECT ErrorStatus = 0, ErrorMessage = 'SUCCESS';          
  --update ##TBDataTemp set CIBALANCE = abs(CIBALANCE) where CIBALANCETYPE in ('D','Dr','Debit')           
          
  --update ##TBDataTemp set CIBALANCE = 0-CIBALANCE where CIBALANCETYPE in ('C','Cr','Credit')          
  --update ##TBDataTemp set CIBALANCETYPE = ''          
          
          
  --   update ##TBDataTemp set opbalance = abs(opbalance) where opbalancetype in ('D','Dr','Debit')           
          
  --update ##TBDataTemp set opbalance = 0-opbalance where opbalancetype in ('C','Cr','Credit')          
  --update ##TBDataTemp set opbalancetype = ''          
          
   INSERT INTO CIT_TrailBalance          
   (  
     TenantId,          
     UniqueIdentifier,          
     GLCode,          
     GLName,          
     GLGroup,          
     OPBalance,          
     OpBalanceType,          
     Debit,          
     Credit,          
     CIBALANCE,          
     CIBALANCETYPE,          
     TaxCode,          
     ISBS,          
     FinancialStartDate,          
     FinancialEndDate,          
     CreationTime,          
     IsActive          
   )          
   SELECT          
     @tenantid,          
     NEWID(),          
     temp.glcode,          
     temp.glname,          
     temp.glgroup,          
     CASE WHEN @isCreditNegative =1 then temp.opbalance else -1 *temp.OPBalance end,          
     temp.opbalancetype,          
     temp.debit,          
     temp.credit,          
     CASE WHEN @isCreditNegative = 1 then temp.CIBALANCE else -1 *temp.CIBALANCE end,          
     temp.CIBALANCETYPE,          
     COALESCE(taxcode_master.TaxCode, NULL) AS TaxCode,   
     NULL,          
     @fromdate,          
     @todate,          
     GETDATE(),          
     1          
   FROM   
     ##TBDataTemp temp  
   LEFT JOIN  
     CIT_GLTaxCodeMaster taxcode_master ON temp.TaxCode = taxcode_master.TaxCode  
   WHERE NOT EXISTS (  
    SELECT 1  
    FROM CIT_TrailBalance  
    WHERE GLCode = temp.glcode  
    and glname =temp.glname  
    and tenantid = @tenantid and           
     FinancialStartDate=@fromdate and FinancialEndDate=@todate  
   );  
        --SELECT * FROM CIT_TrailBalance;  
  
     insert into CIT_GLMaster(TENANTid,UniqueIdentifier,GLCode,GLName,GLGroup,FinancialStartDate,FinancialEndDate,CreationTime,ISACTIVE)           
     select @tenantid,newid(),glcode,GLName,GLGroup,@fromdate,@todate,GETDATE(),1  from CIT_TrailBalance where          
     glname not in (select glname from CIT_GLMaster where tenantid = @tenantid and           
     FinancialStartDate=@fromdate and FinancialEndDate=@todate) and (GLName is not null or glname <> '')          
     and tenantid = @tenantid and    FinancialStartDate=@fromdate and FinancialEndDate=@todate           
        
   --select * from CIT_GLMaster  
       
     insert into CIT_GLGroupMaster(tenantid,UniqueIdentifier,GroupName,FinancialStartDate,FinancialEndDate,CreationTime,ISACTIVE)           
     select  distinct @tenantid,newid(),GLGroup,@fromdate,@todate,GETDATE(),1  from CIT_TrailBalance where          
     glgroup not in (select groupname from CIT_GLGroupMaster where tenantid = @tenantid  and            
     FinancialStartDate=@fromdate and FinancialEndDate=@todate ) and (GLGroup is not null or GLGroup<>'')           
     and tenantid = @tenantid and  FinancialStartDate=@fromdate and FinancialEndDate=@todate           
             
      --select * from CIT_GLGroupMaster    
  
   --CIT_GLTaxCodeMapping         
  
   -- Update existing records in [CIT_GLTaxCodeMapping]  
      UPDATE TB  
      SET  
       [TaxCode] = T.[TaxCode],  
       [LastModificationTime] = TRY_CAST(GETDATE() AS DATETIME),  
       [LastModifierUserId] = @userId  
      FROM [dbo].CIT_GLTaxCodeMapping TB  
      INNER JOIN ##TBDataTemp T ON TB.GLCode = T.GLCode AND TB.GLName = T.GLName  
      WHERE TB.TenantId = @tenantId  
       AND TB.FinancialStartDate = @fromdate  
       AND TB.FinancialEndDate = @todate;  
  
  
     --SELECT * FROM CIT_GLTaxCodeMapping  
  
  
-- Insert new records into [CIT_GLTaxCodeMapping]  
   INSERT INTO [dbo].CIT_GLTaxCodeMapping (  
    [TenantId], [UniqueIdentifier],  
    GLCode, GLName,TaxCode, ISBS, [CreationTime], [CreatorUserId], [LastModificationTime],  
    [LastModifierUserId], [FinancialStartDate], [FinancialEndDate], [IsActive]  
   )  
   SELECT  
    @tenantId, NEWID(), T.GLCode, T.GLName,COALESCE(M.TaxCode, NULL) AS TaxCode, NULL,  
    TRY_CAST(GETDATE() AS DATETIME), @userId, NULL, NULL, @fromdate, @todate, 1  
   FROM ##TBDataTemp T  
   LEFT JOIN [dbo].CIT_GLTaxCodeMaster M ON T.TaxCode = M.TaxCode  
   WHERE NOT EXISTS (  
    SELECT 1  
    FROM [dbo].CIT_GLTaxCodeMapping TB  
    WHERE TB.TenantId = @tenantId  
     AND TB.GLCode = T.GLCode  
     --AND TB.GLName = T.GLName  
     AND TB.FinancialStartDate = @fromdate  
     AND TB.FinancialEndDate = @todate  
   );  
  
   --SELECT * FROM CIT_GLTaxCodeMapping  
  
      --CIT_TrialBalanceTransactions          
  
      -- Update existing records  
      IF exists(select 1 from CIT_TrialBalanceTransactions   tb INNER JOIN ##TBDataTemp T ON  TB.GLName = T.GLName  
      WHERE TB.TenantId = @tenantId  
       AND TB.FinancialStartDate = @fromdate  
       AND TB.FinancialEndDate = @todate)
       begin
      UPDATE TB  
      SET  
          [GLCode] = T.[GLCode],  
       [TaxCode] = T.[TaxCode],  
       GlGroup =T.[GLGroup],  
       cibalance=CASE WHEN @isCreditNegative = 1 then t.CIBALANCE else -1 *t.CIBALANCE end,
       opbalance=CASE WHEN @isCreditNegative = 1 then t.opbalance else -1 *t.OPBalance end,
       cibalancetype=T.Cibalancetype,
       opbalancetype=T.opbalancetype,
       [LastModificationTime] = TRY_CAST(GETDATE() AS DATETIME),  
       [LastModifierUserId] = @userId  
      FROM [dbo].CIT_TrialBalanceTransactions TB  
      INNER JOIN ##TBDataTemp T ON  TB.GLName = T.GLName  
      WHERE TB.TenantId = @tenantId  
       AND TB.FinancialStartDate = @fromdate  
       AND TB.FinancialEndDate = @todate;  
         SELECT ErrorStatus = 1, ErrorMessage = 'Data Already Exists Updated Succesfuly'; 
    end
    else
    begin
                 SELECT ErrorStatus = 0, ErrorMessage = 'SUCCESS'; 

    end
       --select * from CIT_TrialBalanceTransactions;  
  
   -- Insert new records  
   INSERT INTO [dbo].CIT_TrialBalanceTransactions (  
    [TenantId], [UniqueIdentifier],  
    GLCode, GLName, GLGroup, OPBalance, OpBalanceType, Debit, Credit, CIBalance,  
    CIBALANCETYPE, TaxCode, ISBS, [CreationTime], [CreatorUserId], [LastModificationTime],  
    [LastModifierUserId], [FinancialStartDate], [FinancialEndDate], [IsActive]  
   )  
   SELECT  
    @tenantId, NEWID(), T.GLCode, T.GLName, T.GLGroup,CASE WHEN @isCreditNegative = 1 then t.opbalance else -1 *t.OPBalance end,          
    T.OpBalanceType,  
    T.Debit, T.Credit, CASE WHEN @isCreditNegative = 1 then t.CIBALANCE else -1 *t.CIBALANCE end, T.CIBALANCETYPE, COALESCE(M.TaxCode, NULL) AS TaxCode, NULL,  
    TRY_CAST(GETDATE() AS DATETIME), @userId, NULL, NULL, @fromdate, @todate, 1  
   FROM ##TBDataTemp T  
   LEFT JOIN [dbo].CIT_GLTaxCodeMaster M ON T.TaxCode = M.TaxCode  
   WHERE NOT EXISTS (  
    SELECT 1  
    FROM [dbo].CIT_TrialBalanceTransactions TB  
    WHERE TB.TenantId = @tenantId  
     --AND TB.GLCode = T.GLCode  
     AND TB.GLName = T.GLName  
     AND TB.FinancialStartDate = @fromdate  
     AND TB.FinancialEndDate = @todate  
   );  
  
   --select * from CIT_TrialBalanceTransactions  
  
end         
DROP TABLE IF EXISTS ##TBDataTemp;         
DROP TABLE IF EXISTS ##TBDataTempIntermediate;         
end  
END
GO
