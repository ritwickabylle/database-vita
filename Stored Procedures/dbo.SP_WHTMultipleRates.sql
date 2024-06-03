SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  PROCEDURE [dbo].[SP_WHTMultipleRates]      
as        
begin        
      
select ServiceName,Standardrate_OOK,StandardRate,natureofservice from mst_WHTMultipleRates group by ServiceName,Standardrate_OOK,StandardRate ,natureofservice 
       
end
GO
