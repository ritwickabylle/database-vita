SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
CREATE        PROCEDURE [dbo].[GetDataCIT_Schedule]    -- exec [GetDataCIT_Schedule] 172, 'CIT_TrailBalance', CIT_TrailBalance      
(@tenantId int,      
@scheduleCode nvarchar(max) = 'CIT_Schedule1',      
  @fromdate DateTime = '1/1/2024',              
  @todate DateTime = '12/31/2024'  )      
AS      
BEGIN      
      
DECLARE @cols nvarchar(max)       
SELECT                        
    @cols = STRING_AGG(CONCAT('[', REPLACE(T.MappedColumns, '''', ''''''), '] as ''', REPLACE(T.uploadedFields, '''', ''''''), ''''), ',')                
                  
from                  
  (SELECT                    
    TOP 200000 MF.MappedColumns,                  
    MF.uploadedFields,                  
    MF.SequenceNumber                  
 FROM                   
  MappingConfiguration MC                  
  CROSS APPLY OPENJSON(MC.MappingData)                   
     WITH (                  
       SequenceNumber int '$.sequenceNumber',                  
       MappedColumns VARCHAR(100) '$.fieldForMapping',                  
       uploadedFields VARCHAR(100) '$.uploadedFields[0]',                  
       IsCustomerMapped bit '$.isCustomerMapped'                  
       ) AS MF                  
 WHERE                  
  MC.TenantId = 0 AND                  
  MC.Module = 'CIT' AND                  
  MC.TransactionType = @scheduleCode AND                  
  MC.MappingType = 'FieldMapping' AND                   
  MC.IsActive = 1          
 ORDER BY                  
  MF.SequenceNumber ASC  ) T          
      
  print @cols      
      
 if @scheduleCode = 'CIT_Schedule1'      
 begin      
  exec [dbo].[GetDataCIT_Schedule1] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule2'      
 begin      
  exec [dbo].[GetDataCIT_Schedule2] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule2_1'      
 begin      
  exec [dbo].[GetDataCIT_Schedule2_1] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule3'      
 begin      
  exec [dbo].[GetDataCIT_Schedule3] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_TrailBalance'      
 begin      
  exec [dbo].[GetDataCIT_TrailBalance] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'Reclassification'      
 begin      
  exec [dbo].[GetDataCIT_Reclassification]  @fromDate, @toDate,@tenantId      
 end      
 else if @scheduleCode = 'CIT_Schedule4'      
 begin      
  exec [dbo].[GetDataCIT_Schedule4] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule5'      
 begin      
  exec [dbo].[GetDataCIT_Schedule5] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule6'      
 begin      
  exec [dbo].[GetDataCIT_Schedule6] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule7'      
 begin      
  exec [dbo].[GetDataCIT_Schedule7] @cols, @tenantId, @fromDate, @toDate      
 end   
  else if @scheduleCode = 'CIT_Schedule8'      
 begin      
  exec [dbo].[GetDataCIT_Schedule8] @cols, @tenantId, @fromDate, @toDate      
 end   
   else if @scheduleCode = 'CIT_Schedule9'      
 begin      
  exec [dbo].[GetDataCIT_Schedule9] @cols, @tenantId, @fromDate, @toDate      
 end   
    else if @scheduleCode = 'CIT_Schedule9_1'      
 begin      
  exec [dbo].[GetDataCIT_Schedule9_1] @cols, @tenantId, @fromDate, @toDate      
 end   
    else if @scheduleCode = 'CIT_Schedule10_1'      
 begin      
  exec [dbo].[GetDataCIT_Schedule10_1] @cols, @tenantId, @fromDate, @toDate      
 end   
 else if @scheduleCode = 'CIT_Schedule10'      
 begin      
  exec [dbo].[GetDataCIT_Schedule10] @cols, @tenantId, @fromDate, @toDate      
 end   
 else if @scheduleCode = 'CIT_Schedule11_A'      
 begin      
  exec [dbo].[GetDataCIT_Schedule11_A] @cols, @tenantId, @fromDate, @toDate      
 end   
  else if @scheduleCode = 'CIT_Schedule11_B'      
 begin      
  exec [dbo].[GetDataCIT_Schedule11_B] @cols, @tenantId, @fromDate, @toDate      
 end   
   else if @scheduleCode = 'CIT_Schedule13'      
 begin      
  exec [dbo].[GetDataCIT_Schedule13] @cols, @tenantId, @fromDate, @toDate      
 end   
 else if @scheduleCode = 'CIT_Schedule14'      
 begin      
  exec [dbo].[GetDataCIT_Schedule14] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule15'      
 begin      
  exec [dbo].[GetDataCIT_Schedule15] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule16'      
 begin      
  exec [dbo].[GetDataCIT_Schedule16] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule17'      
 begin      
  exec [dbo].[GetDataCIT_Schedule17] @cols, @tenantId, @fromDate, @toDate      
 end      
 else if @scheduleCode = 'CIT_Schedule18'      
 begin      
  exec [dbo].[GetDataCIT_Schedule18] @cols, @tenantId, @fromDate, @toDate      
 end      
END
GO
