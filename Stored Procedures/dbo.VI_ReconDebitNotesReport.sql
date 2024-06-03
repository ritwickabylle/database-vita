SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   procedure [dbo].[VI_ReconDebitNotesReport]    -- exec VI_ReconDebitNotesReport '2022-09-01', '2022-09-30'          
(          
@fromdate date,          
@todate date,        
@tenantId int=null        
)          
as          
Begin          
-- (18,'Debit Notes on Supplies',13,13,2)  


declare @temp_table table
(id int,  
Description varchar(100),  
InnerAmount decimal (18,2),  
Amount decimal (18,2),  
style int 
)

insert into @temp_table
exec GetSalesDebitReconciliationReport @fromdate,@todate,@tenantid
         
select 18,'Debit Notes on Supplies',null,          
      isnull(amount,0) as amount,2          
 from @temp_table sales          
 where  id=8;          
end
GO
