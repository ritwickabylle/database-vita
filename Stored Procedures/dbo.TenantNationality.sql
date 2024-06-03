SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[TenantNationality]        
AS        
BEGIN        
       --Create Temp Table        
Create Table #tenantNationality (Code nvarchar(20) , Name nvarchar(50))         
       --Insert data into Temporary Tables        
       Insert into #tenantNationality Values ('KSA','KSA');        
       Insert into #tenantNationality Values ('NONKSA','NON KSA');        
       Insert into #tenantNationality Values ('GCC','GCC');         
       -- Select Data from the Temporary Tables   '    
       Select * from #tenantNationality        
END
GO
