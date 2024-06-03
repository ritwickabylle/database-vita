SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   procedure [dbo].[VI_OverHeadGapAnalysis_Exempt]    -- exec VI_OverHeadGapAnalysis_Exempt '2023-01-01', '2023-12-31',50    
(    
@fromdate date,    
@todate date,  
@tenantId int=null  
)    
as    
Begin 

declare @exemptdata as table  
(id int,  
Particular varchar(100),
col01 decimal(18,2),
col02 decimal(18,2),
col03 decimal(18,2),
col04 decimal(18,2),
col05 decimal(18,2),
col06 decimal(18,2),
col07 decimal(18,2),
col08 decimal(18,2),
col09 decimal(18,2),
col10 decimal(18,2),
col11 decimal(18,2),
col12 decimal(18,2),
Amount decimal (18,2),  
style integer  
)
--  select * from apportionmentbasedata  
insert into @exemptdata  
select 3,'Exempt',    
      CASE WHEN [date]<>'Total' and [date] = '1-'+cast(year(@fromdate) as nvarchar(20))  
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '2-'+cast(year(@fromdate) as nvarchar(20))  
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end  
,      CASE WHEN [date]<>'Total' and [date] = '3-'+cast(year(@fromdate) as nvarchar(20)) 
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '4-'+cast(year(@fromdate) as nvarchar(20))
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '5-'+cast(year(@fromdate) as nvarchar(20)) 
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '6-'+cast(year(@fromdate) as nvarchar(20)) 
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '7-'+cast(year(@fromdate) as nvarchar(20))  
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '8-'+cast(year(@fromdate) as nvarchar(20))  
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '9-'+cast(year(@fromdate) as nvarchar(20)) 
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '10-'+cast(year(@fromdate) as nvarchar(20)) 
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '11-'+cast(year(@fromdate) as nvarchar(20))
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,      CASE WHEN [date]<>'Total' and [date] = '12-'+cast(year(@fromdate) as nvarchar(20)) 
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end   
,     CASE WHEN [date]='Total'  
      then sum(cast(ExemptSupply as numeric(18,2))) else 0 end as Amount  
, 0 as style  
 from apportionmentbasedata     
 where   type = 'Current' and effectivefromdate = @fromdate and effectivetillenddate = @todate and TenantId=@tenantId
  group by [Date]

   select 3,'Exempt',sum(col01) as col01,sum(col02) as col02,sum(col03) as col03
 ,sum(col04) as col04,sum(col05) as col05,sum(col06) as col06,sum(col07) as col07
 ,sum(col08) as col08,sum(col09) as col09,sum(col10) as col10,sum(col11) as col11,sum(col12) as col12,sum(Amount) as Amount,0 as style from @exemptdata 
end  
  
--select * from apportionmentbasedata
GO
