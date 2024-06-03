SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[saveNatureofService]   
(  
@json nvarchar(max)='[{"HeadofPayment":"payment aasf","NatureofService":"Management"}]',  
@batchId int=7956,  
@tenantid int= 148  
)  
as   
begin  
  
INSERT INTO headofpayment (name, natureofservice,IsActive)  
SELECT    
    HeadofPayment,   
    NatureofService,  
 1
FROM OPENJSON(@json)  
WITH (  
    HeadofPayment NVARCHAR(MAX) '$.HeadofPayment',  
    NatureofService NVARCHAR(MAX) '$.NatureofService'  
);  
  
  
  
--UPDATE ImportBatchData  
--SET NatureofServices = hod.NatureOfService  
--FROM ImportBatchData ibd  
--JOIN OPENJSON(@json) WITH (  
--    HeadofPayment NVARCHAR(MAX) '$.HeadofPayment',  
--    NatureofService NVARCHAR(MAX) '$.NatureofService'  
--) AS jsondata ON ibd.LedgerHeader = jsondata.HeadofPayment  
--inner join HeadOfPayment hod on hod.Name = jsondata.HeadofPayment   where BatchId=@batchId;  
  
  
update ImportBatchData   
set  NatureofServices = hod.NatureOfService  
from ImportBatchData  
inner join HeadOfPayment hod on hod.Name = LedgerHeader   where BatchId=@batchId;  
  
 exec PaymentTransValidation @batchId,1    
end  
  
  
--select * from HeadOfPayment order by id desc  
--delete  from HeadOfPayment where id in (234,235)  
  
--select NatureofServices,ledgerHeader,* from ImportBatchData where BatchId=7956
GO
