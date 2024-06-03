SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROC [dbo].[GetTaxcodeMasterDataByShcedule]
(  
   @ScheduleNo  NVARCHAR(MAX),
   @Isactive    bit=1
)
AS
BEGIN 

  SELECT * FROM CIT_GLTaxCodeMaster WHERE ScheduleNo=@ScheduleNo  and IsActive=@Isactive

END
GO
