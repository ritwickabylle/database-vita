SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetSalesBatchData]    
(    
@fileName nvarchar(max)='' ,
@module varchar(max) = 'VAT',
@tenantId int = null  
)    
AS    
BEGIN    
IF (@module='VAT')
BEGIN 
--select format(CreationTime,'dd-MM-yyyy') as CreatedDate,BatchId,FileName,TotalRecords,SuccessRecords,FailedRecords,Status,Type from BatchData  where FileName = @fileName and ISNULL(TenantId,0)=ISNULL(@tenantId,0) order by CreationTime desc    
  SELECT    
    bd.BatchId as BatchId,    
    Type,    
    SUBSTRING(bd.FileName, CHARINDEX('_', bd.FileName) + 1, LEN(bd.FileName)) AS FileName,    
    TotalRecords,    
    SuccessRecords,    
    FailedRecords - SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'UNCLASSIFIED' THEN 1 ELSE 0 END) AS FailedRecords,    
    Status,    
    FORMAT(bd.CreationTime, 'dd-MM-yyyy') AS CreatedDate,    
    SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'SALES' THEN 1 ELSE 0 END) AS sales,    
    SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'PURCHASE' THEN 1 ELSE 0 END) AS purchase,    
    SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'CREDIT' THEN 1 ELSE 0 END) AS credit,    
    SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'DEBIT' THEN 1 ELSE 0 END) AS debit,    
    SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'CREDIT-PURCHASE' THEN 1 ELSE 0 END) AS creditPurchase,    
    SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'DEBIT-PURCHASE' THEN 1 ELSE 0 END) AS debitPurchase,    
    SUM(CASE WHEN UPPER(TRIM(ibd.TransType)) = 'UNCLASSIFIED' THEN 1 ELSE 0 END) AS unclassified    
FROM    
    BatchData bd WITH (NOLOCK)    
INNER JOIN ImportBatchData ibd ON ibd.BatchId = bd.BatchId    
WHERE    
    bd.FileName = @fileName
    AND ISNULL(bd.TenantId, 0) = ISNULL(@tenantId, 0)    
    AND bd.Type <> 'Payment'    
GROUP BY    
    bd.BatchId,    
    bd.Type,    
    SUBSTRING(bd.FileName, CHARINDEX('_', bd.FileName) + 1, LEN(bd.FileName)),    
    bd.TotalRecords,    
    bd.SuccessRecords,    
    bd.FailedRecords,  
    bd.Status,    
    FORMAT(bd.CreationTime, 'dd-MM-yyyy')    
ORDER BY    
    BatchId DESC;
END

ELSE IF (@module='WHT')      
BEGIN
select  BatchId,      
  Type,      
  SUBSTRING(FileName, CHARINDEX('_', FileName) + 1, LEN(FileName)) as FileName,      
  TotalRecords,      
  SuccessRecords,      
  FailedRecords,      
  Status,      
  format(CreationTime,'dd-MM-yyyy') as CreatedDate       
from    BatchData with (nolock)           
where FileName = @fileName         
and ISNULL(TenantId,0)=ISNULL(@tenantId,0) and Type = 'Payment' order by CreationTime desc       
END      
END

--exec [GetSalesBatchData] '20242516590_WHT New 2.xlsx',159

--select * from BatchData
GO
