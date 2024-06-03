SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
CREATE       PROCEDURE [dbo].[UpdateTenantShareHolderDetails]               
( @json NVARCHAR(max),                 
@id int,  
@id1 int  
)            
AS              
  BEGIN   
    
  With Json_data as             
(   Select          
[id]=@id,        
      [PartnerName]      
     ,[Designation]          
     ,[DomesticName]    
     ,[CapitalAmount]    
     ,[CapitalShare]      
     ,[ConstitutionName]      
     ,[Nationality]      
     ,[RepresentativeName]     
     ,[ProfitShare]      
     ,[Mobile]    
     ,[Email]    
     ,[IdType]    
     ,[IdNumber]    
     ,[NoOfSharePercentage]     
     ,[NoOfShares]     
     ,[ShareHolderExitDate]     
     ,[ShareHolderEntryDate] 
	 ,[SharesSubjectTo]
     from            
     OPENJSON(@json)             
        with (            
        [PartnerName] nvarchar(max) '$."PartnerName"',      
        [Designation] nvarchar(max) '$."Designation"',      
        [DomesticName]  nvarchar(max) '$."DomesticName"',      
        [CapitalAmount] nvarchar(max) '$."CapitalAmount"',      
        [CapitalShare] nvarchar(max) '$."CapitalShare"',      
        [ProfitShare] nvarchar(max) '$."ProfitShare"',      
        [ConstitutionName] nvarchar(max) '$."ConstitutionName"',      
        [Nationality] nvarchar(max) '$."Nationality"',      
        [RepresentativeName] nvarchar(max) '$."RepresentativeName"' ,    
  [Mobile] nvarchar(max) '$."Mobile"',    
  [Email] nvarchar(max) '$."Email"',    
  [IdType] nvarchar(max) '$."IdType"',    
  [IdNumber] nvarchar(max) '$."IdNumber"',    
  [NoOfSharePercentage] nvarchar(max) '$."NoOfSharePercentage"',    
  [NoOfShares] nvarchar(max) '$."NoOfShares"',    
  [ShareHolderExitDate] nvarchar(max) '$."ShareHolderExitDate"',    
  [ShareHolderEntryDate] nvarchar(max) '$."ShareHolderEntryDate"' ,
  [SharesSubjectTo] nvarchar(max) '$."SharesSubjectTo"'  
        )  )            
Update CS            
set             
cs.PartnerName=jd.PartnerName,            
cs.Designation=jd.Designation,        
cs.Nationality=jd.Nationality,            
cs.CapitalAmount=jd.CapitalAmount,        
cs.CapitalShare=jd.CapitalShare,        
cs.ProfitShare=jd.ProfitShare,        
cs.ConstitutionName=jd.ConstitutionName,        
cs.RepresentativeName=jd.RepresentativeName,        
cs.DomesticName=jd.DomesticName,        
cs.Mobile=jd.Mobile,        
cs.Email=jd.Email,        
cs.IdType=jd.IdType,            
cs.IdNumber=jd.IdNumber,               
cs.NoOfSharePercentage=jd.NoOfSharePercentage,            
cs.NoOfShares=jd.NoOfShares,    
cs.ShareHolderExitDate=jd.ShareHolderExitDate,    
cs.ShareHolderEntryDate=jd.ShareHolderEntryDate,
cs.SharesSubjectTo=jd.SharesSubjectTo,
cs.LastModificationTime=getdate()            
from TenantShareHolders as CS            
inner join Json_data as JD on JD.id=CS.id            
where cs.id=jd.id;  
  
  
 With Json_data as             
(   Select          
[id]=@id1        
    ,[Address1]    
           ,[Address2]    
           ,[City]    
           ,[District]    
           ,[PostalCode]    
           ,[Country]         
     from            
     OPENJSON(@json)             
        with (            
        [Address1] nvarchar(max) '$."Address1"',      
        [Address2] nvarchar(max) '$."Address2"',      
        [City]  nvarchar(max) '$."City"',      
        [District] nvarchar(max) '$."District"',      
        [PostalCode] nvarchar(max) '$."PostalCode"',      
        [Country] nvarchar(max) '$."Country"'      
        )  )           
Update CSA            
set             
csa.Address1=jd.Address1,            
csa.Address2=jd.Address2,        
csa.City=jd.City,            
csa.District=jd.District,        
csa.PostalCode=jd.PostalCode,        
csa.Country=jd.Country              
from TenantShareHolderAddress as CSA            
inner join Json_data as JD on JD.id=CSA.id            
where csa.id=jd.id;  
  
  
  
          End
GO
