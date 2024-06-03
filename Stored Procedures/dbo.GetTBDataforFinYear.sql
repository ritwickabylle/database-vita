SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create   procedure [dbo].[GetTBDataforFinYear]   --exec GetTBDataforFinYear 33,'01-jan-2022','31-dec-2022' 

(                      
@tenantid numeric,        
@finbegin date,        
@finend date        
)       
as begin

declare @CITTBdataDisplayTable as table 

(ClientGLNumber nvarchar(15),        
   AccountDescription  nvarchar(max),        
   FSClassificationOrMapping  nvarchar(max),        
   OpeningBalance  nvarchar(50),        
   Debit  nvarchar(50),        
   Credit  nvarchar(50),        
   ClosingBalance  nvarchar(50),        
   BSIS  nvarchar(50),        
   Description  nvarchar(max),
   Code nvarchar(max) ,
   FinBeginDate  date,        
   FinEndDate  date)

   insert into @CITTBdataDisplayTable
   (

   --ClientGLNumber,        
   --AccountDescription,        
   --FSClassificationOrMapping ,        
   --OpeningBalance,        
   --Debit,        
   --Credit ,        
   --ClosingBalance ,        
   --BSIS ,        
   --Description,
   --Code,
    FinBeginDate,        
   FinEndDate)

 select      
        
       
       '01-Jan-2023' as FinBeginDate,        
        '31-Jan-2023' as FinEndDate        


insert into @CITTBdataDisplayTable(ClientGLNumber,AccountDescription,FSClassificationOrMapping,OpeningBalance,Debit,Credit,ClosingBalance,BSIS,Description,Code)         
values('31016001','Retail Sales Cafe','Revenue','0.00','0.00','0.00',-101739.00,'','',10101)

insert into @CITTBdataDisplayTable(ClientGLNumber,AccountDescription,FSClassificationOrMapping,OpeningBalance,Debit,Credit,ClosingBalance,BSIS,Description,Code)         
values('31011001','Local Sales','Revenue','0.00','0.00','0.00',-35358766.00,'','','')


insert into @CITTBdataDisplayTable(ClientGLNumber,AccountDescription,FSClassificationOrMapping,OpeningBalance,Debit,Credit,ClosingBalance,BSIS,Description,Code)         
values('31011002','Wholesale Sales','Revenue','0.00','0.00','0.00',-387216.00,'','','')

select ClientGLNumber,        
   AccountDescription,        
   FSClassificationOrMapping ,        
   OpeningBalance,        
   Debit,        
   Credit ,        
   ClosingBalance ,        
   BSIS ,        
   Description,
   Code,
    FinBeginDate,        
   FinEndDate        
from @CITTBdataDisplayTable        
        
end
GO
