SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE         procedure [dbo].[GetCreditDetailedReportEffdate]   --  exec   GetCreditDetailedReportEffdate '2023-01-03','2023-10-03',2134,'any',null                 
(                  
@fromDate DATE=NULL,              
@toDate DATE=NULL,            
@tenantId INT=NULL,        
@type NVARCHAR(MAX)=NULL,        
@text NVARCHAR(MAX)=NULL             
)                  
as   
begin   
  
declare @tenancyname nvarchar(max)  
  
set @tenancyname = (select name from AbpTenants where id=@tenantId)  
  
if (lower(@tenancyname) like '%brady%')  
begin  
exec GetCreditDetailedReportEffdatebrady @fromdate,@toDate,@tenantId,@type,@text  
end  
else  
begin  
exec GetCreditDetailedReportEffdateothers @fromdate,@toDate,@tenantId,@type,@text   
end  
end
GO
