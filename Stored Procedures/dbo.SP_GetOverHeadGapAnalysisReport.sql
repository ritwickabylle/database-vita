SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           PROCEDURE [dbo].[SP_GetOverHeadGapAnalysisReport]  
(@tenantId int=null)      
--exec SP_GetOverHeadGapAnalysisReport 50  
as  
begin  

declare @finstartdate datetime,     
        @finenddate datetime

declare @OverHeadGapAnalysisReport as table  
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

set @finstartdate = (select top 1 EffectiveFromDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid) --in (select tenantid from ImportBatchData where BatchId=@batchno))                  
                  
set @finenddate = (select top 1 EffectiveTillEndDate from  FinancialYear with (nolock) where isactive = 1 and tenantid = @tenantid)  --in (select tenantid from ImportBatchData where BatchId=@batchno))                  
  
  
--insert into @OverHeadGapAnalysisReport values (1,'Supplies',null,null,null,null,null,null,null,null,null,null,null,null,null,1));  

insert into @OverHeadGapAnalysisReport values (1,'Supplies',null,null,null,null,null,null,null,null,null,null,null,null,null,1);  

  
--insert into @OverHeadGapAnalysisReport values (2,'Taxable',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
exec VI_OverHeadGapAnalysis_Taxable @finstartdate, @finenddate,@tenantId   
   
--insert into @OverHeadGapAnalysisReport values (3,'Exempt',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
exec VI_OverHeadGapAnalysis_Exempt @finstartdate, @finenddate,@tenantId   
    
--insert into @OverHeadGapAnalysisReport values (4,'Total',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
select 4,'Total',sum(col01),sum(col02),sum(col03),sum(col04),sum(col05),sum(col06),sum(col07),sum(col08),sum(col09),sum(col10),sum(col11),sum(col12),sum(Amount),2 from @OverHeadGapAnalysisReport where id in (2,3)  


declare @PrevAppor float = 0.00        
declare @CurrAppor float = 0.00        

       
set @Prevappor = (select top 1 ApportionmentSupplies from ApportionmentBaseData  where  TenantId=@tenantid and type='Previous' and date = 'Total' and EffectiveFromDate = @finstartdate and EffectiveTillEndDate = @finenddate )        

set @Currappor = (select top 1 ApportionmentSupplies from ApportionmentBaseData  where  TenantId=@tenantid and type='Current' and date = 'Total' and EffectiveFromDate = @finstartdate and EffectiveTillEndDate = @finenddate )        

--insert into @OverHeadGapAnalysisReport values (5,'% of Taxable Supplies',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
select 5,'% of Taxable Supplies',
case when sum(case when id = 2 then col01 else 0 end) > 0 and sum(case when id = 4 then col01 else 0 end) > 0  then
round(sum(case when id = 2 then col01 else 0 end) / sum(case when id = 4 then col01 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col02 else 0 end) > 0 and sum(case when id = 4 then col02 else 0 end) > 0  then
round(sum(case when id = 2 then col02 else 0 end) / sum(case when id = 4 then col02 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col03 else 0 end) > 0 and sum(case when id = 4 then col03 else 0 end) > 0  then
round(sum(case when id = 2 then col03 else 0 end) / sum(case when id = 4 then col03 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col04 else 0 end) > 0 and sum(case when id = 4 then col04 else 0 end) > 0  then
round(sum(case when id = 2 then col04 else 0 end) / sum(case when id = 4 then col04 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col05 else 0 end) > 0 and sum(case when id = 4 then col05 else 0 end) > 0  then
round(sum(case when id = 2 then col05 else 0 end) / sum(case when id = 4 then col05 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col06 else 0 end) > 0 and sum(case when id = 4 then col06 else 0 end) > 0  then
round(sum(case when id = 2 then col06 else 0 end) / sum(case when id = 4 then col06 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col07 else 0 end) > 0 and sum(case when id = 4 then col07 else 0 end) > 0  then
round(sum(case when id = 2 then col07 else 0 end) / sum(case when id = 4 then col07 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col08 else 0 end) > 0 and sum(case when id = 4 then col08 else 0 end) > 0  then
round(sum(case when id = 2 then col08 else 0 end) / sum(case when id = 4 then col08 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col09 else 0 end) > 0 and sum(case when id = 4 then col09 else 0 end) > 0  then
round(sum(case when id = 2 then col09 else 0 end) / sum(case when id = 4 then col09 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col10 else 0 end) > 0 and sum(case when id = 4 then col10 else 0 end) > 0  then
round(sum(case when id = 2 then col10 else 0 end) / sum(case when id = 4 then col10 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col11 else 0 end) > 0 and sum(case when id = 4 then col11 else 0 end) > 0  then
round(sum(case when id = 2 then col11 else 0 end) / sum(case when id = 4 then col11 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then col12 else 0 end) > 0 and sum(case when id = 4 then col12 else 0 end) > 0  then
round(sum(case when id = 2 then col12 else 0 end) / sum(case when id = 4 then col12 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 2 then Amount else 0 end) > 0 and sum(case when id = 4 then amount else 0 end) > 0  then
round(sum(case when id = 2 then Amount else 0 end) / sum(case when id = 4 then amount else 0 end) * 100,2) else 0 end
,1 as style
from @OverHeadGapAnalysisReport where id in (2,4)

--insert into @OverHeadGapAnalysisReport values (6,'Cumulative Supplies',null,null,null,null,null,null,null,null,null,null,null,null,null,0);  

insert into @OverHeadGapAnalysisReport values (6,'Cumulative Supplies',null,null,null,null,null,null,null,null,null,null,null,null,null,1);  

--insert into @OverHeadGapAnalysisReport values (7,'Taxable',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
select 7,'Taxable',col01,col01+col02,col01+col02+col03,col01+col02+col03+col04,col01+col02+col03+col04+col05,col01+col02+col03+col04+col05+col06,
col01+col02+col03+col04+col05+col06+col07,col01+col02+col03+col04+col05+col06+col07+col08,col01+col02+col03+col04+col05+col06+col07+col08+col09,
col01+col02+col03+col04+col05+col06+col07+col08+col09+col10,col01+col02+col03+col04+col05+col06+col07+col08+col09+col10+col11,
col01+col02+col03+col04+col05+col06+col07+col08+col09+col10+col11+col12,Amount,0 from @OverHeadGapAnalysisReport where id in (2)  

--insert into @OverHeadGapAnalysisReport values (8,'Exempt',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
select 8,'Exempt',col01,col01+col02,col01+col02+col03,col01+col02+col03+col04,col01+col02+col03+col04+col05,col01+col02+col03+col04+col05+col06,
col01+col02+col03+col04+col05+col06+col07,col01+col02+col03+col04+col05+col06+col07+col08,col01+col02+col03+col04+col05+col06+col07+col08+col09,
col01+col02+col03+col04+col05+col06+col07+col08+col09+col10,col01+col02+col03+col04+col05+col06+col07+col08+col09+col10+col11,
col01+col02+col03+col04+col05+col06+col07+col08+col09+col10+col11+col12,Amount,0 from @OverHeadGapAnalysisReport where id in (3)  

--insert into @OverHeadGapAnalysisReport values (9,'Total',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
select 9,'Total',col01,col01+col02,col01+col02+col03,col01+col02+col03+col04,col01+col02+col03+col04+col05,col01+col02+col03+col04+col05+col06,
col01+col02+col03+col04+col05+col06+col07,col01+col02+col03+col04+col05+col06+col07+col08,col01+col02+col03+col04+col05+col06+col07+col08+col09,
col01+col02+col03+col04+col05+col06+col07+col08+col09+col10,col01+col02+col03+col04+col05+col06+col07+col08+col09+col10+col11,
col01+col02+col03+col04+col05+col06+col07+col08+col09+col10+col11+col12,Amount,0 from @OverHeadGapAnalysisReport where id in (4)  

insert into @OverHeadGapAnalysisReport    
select 10,'% of Cumulative Taxable Supplies',
case when sum(case when id = 7 then col01 else 0 end) > 0 and sum(case when id = 9 then col01 else 0 end) > 0  then
round(sum(case when id = 7 then col01 else 0 end) / sum(case when id = 9 then col01 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col02 else 0 end) > 0 and sum(case when id = 9 then col02 else 0 end) > 0  then
round(sum(case when id = 7 then col02 else 0 end) / sum(case when id = 9 then col02 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col03 else 0 end) > 0 and sum(case when id = 9 then col03 else 0 end) > 0  then
round(sum(case when id = 7 then col03 else 0 end) / sum(case when id = 9 then col03 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col04 else 0 end) > 0 and sum(case when id = 9 then col04 else 0 end) > 0  then
round(sum(case when id = 7 then col04 else 0 end) / sum(case when id = 9 then col04 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col05 else 0 end) > 0 and sum(case when id = 9 then col05 else 0 end) > 0  then
round(sum(case when id = 7 then col05 else 0 end) / sum(case when id = 9 then col05 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col06 else 0 end) > 0 and sum(case when id = 9 then col06 else 0 end) > 0  then
round(sum(case when id = 7 then col06 else 0 end) / sum(case when id = 9 then col06 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col07 else 0 end) > 0 and sum(case when id = 9 then col07 else 0 end) > 0  then
round(sum(case when id = 7 then col07 else 0 end) / sum(case when id = 9 then col07 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col08 else 0 end) > 0 and sum(case when id = 9 then col08 else 0 end) > 0  then
round(sum(case when id = 7 then col08 else 0 end) / sum(case when id = 9 then col08 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col09 else 0 end) > 0 and sum(case when id = 9 then col09 else 0 end) > 0  then
round(sum(case when id = 7 then col09 else 0 end) / sum(case when id = 9 then col09 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col10 else 0 end) > 0 and sum(case when id = 9 then col10 else 0 end) > 0  then
round(sum(case when id = 7 then col10 else 0 end) / sum(case when id = 9 then col10 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col11 else 0 end) > 0 and sum(case when id = 9 then col11 else 0 end) > 0  then
round(sum(case when id = 7 then col11 else 0 end) / sum(case when id = 9 then col11 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then col12 else 0 end) > 0 and sum(case when id = 9 then col12 else 0 end) > 0  then
round(sum(case when id = 7 then col12 else 0 end) / sum(case when id = 9 then col12 else 0 end) * 100,2) else 0 end
, case when sum(case when id = 7 then Amount else 0 end) > 0 and sum(case when id = 9 then amount else 0 end) > 0  then
round(sum(case when id = 7 then Amount else 0 end) / sum(case when id = 9 then amount else 0 end) * 100,2) else 0 end
,1 as style
from @OverHeadGapAnalysisReport where id in (7,9)

--insert into @OverHeadGapAnalysisReport values (11,' ',null,null,null,null,null,null,null,null,null,null,null,null,null,0);  

insert into @OverHeadGapAnalysisReport values (11,' ',null,null,null,null,null,null,null,null,null,null,null,null,null,1);  

--insert into @OverHeadGapAnalysisReport values (12,'Total Overheads Exps (As per Purchase File)',0,0,0,0,0,0,0,0,0,0,0,0,0,2);  

insert into @OverHeadGapAnalysisReport  
exec VI_OverHeadGapAnalysisTotalOverheads @finstartdate, @finenddate,@tenantId

--insert into @OverHeadGapAnalysisReport values (13,'Amount of Overheads Absorbed (As per Prev Yr %)',0,0,0,0,0,0,0,0,0,0,0,0,0,2);  

insert into @OverHeadGapAnalysisReport  
exec VI_OverHeadGapAnalysisOverheadsAbsorbed @finstartdate, @finenddate,@tenantId

--insert into @OverHeadGapAnalysisReport values (14,'Amount of Overheads to be Absorbed (As Per CY %)',0,0,0,0,0,0,0,0,0,0,0,0,0,2);  

insert into @OverHeadGapAnalysisReport  
exec VI_OverHeadGapAnalysisOverheadsAbsorbedCYear @finstartdate, @finenddate,@tenantId

--insert into @OverHeadGapAnalysisReport values (15,'Overhead Absorption Gap',0,0,0,0,0,0,0,0,0,0,0,0,0,0);  

insert into @OverHeadGapAnalysisReport    
select 15,'Overhead Absorption Gap',
sum(case when id = 13 then col01 when id = 14 then 0-col01 else 0 end) as col01
, sum(case when id = 13 then col02 when id = 14 then 0-col02 else 0 end) as col02
, sum(case when id = 13 then col03 when id = 14 then 0-col03 else 0 end) as col03
, sum(case when id = 13 then col04 when id = 14 then 0-col04 else 0 end) as col04
, sum(case when id = 13 then col05 when id = 14 then 0-col05 else 0 end) as col05
, sum(case when id = 13 then col06 when id = 14 then 0-col06 else 0 end) as col06
, sum(case when id = 13 then col07 when id = 14 then 0-col07 else 0 end) as col07
, sum(case when id = 13 then col08 when id = 14 then 0-col08 else 0 end) as col08
, sum(case when id = 13 then col09 when id = 14 then 0-col09 else 0 end) as col08
, sum(case when id = 13 then col10 when id = 14 then 0-col10 else 0 end) as col10
, sum(case when id = 13 then col11 when id = 14 then 0-col11 else 0 end) as col11
, sum(case when id = 13 then col12 when id = 14 then 0-col12 else 0 end) as col12
, sum(case when id = 13 then amount when id = 14 then 0-amount else 0 end) as amount
,1 as style
from @OverHeadGapAnalysisReport where id in (13,14)


select id,  Particular,col01,col02,col03,col04,col05,col06,col07,col08,col09,col10,col11,col12,Amount,style from @OverHeadGapAnalysisReport  order by id
  
end
GO
