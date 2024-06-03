SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[TenantShareApplicability]    
AS    
BEGIN    
       --Create Temp Table    
Create Table #tenantShareApplicability (Code nvarchar(20) , Name nvarchar(50))     
       --Insert data into Temporary Tables    
       Insert into #tenantShareApplicability Values ('Z','ZAKAT');    
       Insert into #tenantShareApplicability Values ('C','CIT');    
       -- Select Data from the Temporary Tables   '
       Select * from #tenantShareApplicability    
END
GO
