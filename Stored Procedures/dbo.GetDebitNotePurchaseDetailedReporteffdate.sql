SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[GetDebitNotePurchaseDetailedReporteffdate]   --  exec GetDebitNotePurchaseDetailedReporteffdate '2022-11-01', '2022-11-30'            
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
exec GetDebitNotePurchaseDetailedReporteffdatebrady @fromdate,@toDate,@tenantId,@type,@text  
end  
else  
begin  
exec GetDebitNotePurchaseDetailedReporteffdateothers @fromdate,@toDate,@tenantId,@type,@text   
end  
       
end
GO
