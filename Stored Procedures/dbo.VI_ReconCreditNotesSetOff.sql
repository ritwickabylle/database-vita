SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[VI_ReconCreditNotesSetOff]    -- exec VI_ReconCreditNotesSetOff '2022-09-01', '2022-09-30'          
(          
@fromdate date,          
@todate date,        
@tenantId int=null        
)          
as          
Begin          
-- (14,'Credit Notes Set off ',11,11,2) 

declare @temp_table table
(id int,  
Description varchar(100),  
InnerAmount decimal (18,2),  
Amount decimal (18,2),  
style int 
)

insert into @temp_table
exec GetSalesCreditReconciliationReport @fromdate,@todate,@tenantid
         
select 14,'Credit Notes Set off ',null,          
      isnull(amount,0) as amount,2          
 from @temp_table           
 where  id=18 ;          
end
GO
