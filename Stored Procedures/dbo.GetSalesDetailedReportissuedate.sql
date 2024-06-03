SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
      
CREATE     PROCEDURE [dbo].[GetSalesDetailedReportissuedate]   -- exec GetSalesDetailedReportissuedate '2023-01-31', '2023-10-31',2134,'any',null             
(              
@fromDate DATE=NULL,              
@toDate DATE=NULL,            
@tenantId INT=NULL,        
@type NVARCHAR(MAX)=NULL,        
@text NVARCHAR(MAX)=NULL        
)              
AS BEGIN            
  
declare @tenancyname nvarchar(max)  
  
set @tenancyname = (select name from AbpTenants where id=@tenantId)  
  
if (lower(@tenancyname) like '%brady%')  
begin 
exec GetSalesDetailedReportEffdatebrady @fromdate,@toDate,@tenantId,@type,@text 

end  
else  
begin  
exec GetSalesDetailedReportEffdateothers @fromdate,@toDate,@tenantId,@type,@text   
end  
  
      
      
end
GO
