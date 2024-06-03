SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE    procedure [dbo].[GetDebitNotePeriodicalReporteffdate]   --exec   GetDebitNotePeriodicalReporteffdate '2023-10-03','2023-10-12',2140,null,null            
(              
@fromDate Date=null,              
@toDate Date=null,          
@tenantId int=null,    
@type NVARCHAR(MAX)=NULL,        
@text NVARCHAR(MAX)=NULL      
)              
as begin   
  
declare @tenancyname nvarchar(max)  
  
set @tenancyname = (select name from AbpTenants where id=@tenantId)  
  
if (lower(@tenancyname) like '%brady%')  
begin  
exec GetDebitDetailedReportEffdatebrady @fromdate,@toDate,@tenantId,@type,@text  
end  
else  
begin  
exec GetDebitDetailedReportEffdateothers @fromdate,@toDate,@tenantId,@type,@text   
end  
       
end
GO
