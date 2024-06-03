SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE    PROCEDURE [dbo].[UpdateCIT_ScheduleData]     -- exec UpdateCIT_ScheduleData 148  
    @tenantId INT = '143',  
 @scheduleCode nvarchar(max) = 'CIT_Schedule11_A',  
 @userId INT = '169',  
    @json NVARCHAR(MAX) = N'{"uniqueidentifier_column":"654c673f-8f69-4b8a-9f56-604d79ed5da2","line item":"qwwe","adjusted carried forward CIT losses":"1","adjusted declared net profit":"1","loss deducted during the year":"1","end of year Balance":"1"}'  
AS  
BEGIN  
 if @scheduleCode = 'CIT_Schedule1'  
 begin  
  exec [dbo].[UpdateCIT_Schedule1Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule2'  
 begin  
  exec [dbo].[UpdateCIT_Schedule2Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule2_1'  
 begin  
  exec [dbo].[UpdateCIT_Schedule2_1Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_TrailBalance'  
 begin  
  exec [dbo].[UpdateCIT_TrailBalanceData] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule3'  
 begin  
  exec [dbo].[UpdateCIT_Schedule3Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule4'  
 begin  
  exec [dbo].[UpdateCIT_Schedule4Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule5'  
 begin  
  exec [dbo].[UpdateCIT_Schedule5Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule6'  
 begin  
  exec [dbo].[UpdateCIT_Schedule6Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule7'  
 begin  
  exec [dbo].[UpdateCIT_Schedule7Data] @tenantId, @userId, @json  
 end  
  else if @scheduleCode = 'CIT_Schedule8'  
 begin  
  exec [dbo].[UpdateCIT_Schedule8Data] @tenantId, @userId, @json  
 end 
 else if @scheduleCode = 'CIT_Schedule9'  
 begin  
  exec [dbo].[UpdateCIT_Schedule9Data] @tenantId, @userId, @json  
 end
 else if @scheduleCode = 'CIT_Schedule10'  
 begin  
  exec [dbo].[UpdateCIT_Schedule10Data] @tenantId, @userId, @json  
 end 
 else if @scheduleCode = 'CIT_Schedule11_A'  
 begin  
  exec [dbo].[UpdateCIT_Schedule11_AData] @tenantId, @userId, @json  
 end 
 else if @scheduleCode = 'CIT_Schedule11_B'  
 begin  
  exec [dbo].[UpdateCIT_Schedule11_BData] @tenantId, @userId, @json  
 end 
 else if @scheduleCode = 'CIT_Schedule13'  
 begin  
  exec [dbo].[UpdateCIT_Schedule13Data] @tenantId, @userId, @json  
 end 
 else if @scheduleCode = 'CIT_Schedule14'  
 begin  
  exec [dbo].[UpdateCIT_Schedule14Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule15'  
 begin  
  exec [dbo].[UpdateCIT_Schedule15Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule16'  
 begin  
  exec [dbo].[UpdateCIT_Schedule16Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule17'  
 begin  
  exec [dbo].[UpdateCIT_Schedule17Data] @tenantId, @userId, @json  
 end  
 else if @scheduleCode = 'CIT_Schedule18'  
 begin  
  exec [dbo].[UpdateCIT_Schedule18Data] @tenantId, @userId, @json  
 end  
END
GO
