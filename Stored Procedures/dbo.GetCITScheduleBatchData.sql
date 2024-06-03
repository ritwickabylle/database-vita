SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE      PROCEDURE [dbo].[GetCITScheduleBatchData]   -- exec GetCITScheduleBatchData 159, '1/1/2023', '12/31/2023'    
(    
  @tenantId INT = 159,          
  @fromdate DATETIME = NULL,            
  @todate DATETIME = NULL      
)    
AS    
BEGIN        
    SELECT Format(UploadedOn,'dd-MM-yyyy') as uploadedOn, ScheduleName, SUBSTRING(FileName, CHARINDEX('_', FileName) + 1, LEN(FileName)) as FileName, BatchNo, TotalRecord    
    FROM CITScheduleBatchData  
	where TRY_CAST(FinancialStartDate AS DATE) = TRY_CAST(@fromDate AS DATE)            
    and TRY_CAST(FinancialEndDate AS DATE) = TRY_CAST(@toDate AS DATE) and ScheduleName like '%Schedule%' and TenantId = @tenantId order by BatchNo desc;    
END
GO
