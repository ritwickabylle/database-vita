SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[VI_OverHeadGapAnalysisTotalOverheads]    -- exec VI_OverHeadGapAnalysisTotalOverheads '2023-01-01','2023-12-31'  ,50
(  
@fromdate datetime,
@todate datetime,
@tenantId int=null
)  --select * from vi_importoverheadfiles_processed 
as  
Begin  
--  select * from apportionmentbasedata

declare @ExpSummary as table  
(
amount decimal(18,2),
effdate datetime,
Particular varchar(100)
)  



insert into @expSummary
select  isnull(sum((case when (invoicetype like 'Purchase%')    
        then isnull(LineNetAmount ,0)-isnull(AdvanceRcptAmtAdjusted,0)   
        else 0 end) -   
        (case when (invoicetype like 'CN Purchase%'    
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
     then isnull(LineNetAmount ,0)  
        else 0 end) +  
  (case when (invoicetype like 'DN Purchase%'   
     and OrignalSupplyDate  >= @fromdate and orignalSupplydate <= @todate)   
  then isnull(LineNetAmount ,0)  
  else 0 end)),0)  
 as amount,  
 effdate,
 'Total Overheads Exps (As per Purchase File)'  
 from VI_importOverheadfiles_Processed   
 where  ((invoicetype like 'CN Purchase%'  or invoicetype like 'DN Purchase%' )  
 or (Invoicetype like 'Purchase%'   
)) and vatcategorycode = 'S' and isnull(AffiliationStatus,'Y') <> 'N'  and upper(PurchaseCategory) like 'OVER%'
and effdate >= @fromdate and effdate <= @todate and TenantId=@tenantId
group by effdate

--select * from vi_importoverheadfiles_processed where TenantId =50
--select effdate,DATEADD(mm, 0, @fromdate),DATEADD(mm, -11, @todate),

--select amount ,
--effdate ,
--Particular from @ExpSummary 

select 12,particular,
      sum(CASE WHEN CAST(effdate AS DATETIME) BETWEEN DATEADD(mm, 0, @fromdate) AND DATEADD(mm, -11, @todate)
      then isnull(Amount,0) else 0 end) as col01
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 1, @fromdate) AND DATEADD(mm, -10, @todate)
      then isnull(amount,0) else 0 end) as col02
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 2, @fromdate) AND DATEADD(mm, -9, @todate)
      then isnull(amount,0) else 0 end) as col03
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 3, @fromdate) AND DATEADD(mm, -8, @todate)
      then isnull(amount,0) else 0 end) as col04
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 4, @fromdate) AND DATEADD(mm, -7, @todate)
      then isnull(amount,0) else 0 end) as col05
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 5, @fromdate) AND DATEADD(mm, -6, @todate)
      then isnull(amount,0) else 0 end) as col06
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 6, @fromdate) AND DATEADD(mm, -5, @todate)
      then isnull(amount,0) else 0 end) as col07
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 7, @fromdate) AND DATEADD(mm, -4, @todate)
      then isnull(amount,0) else 0 end) as col08
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 8, @fromdate) AND DATEADD(mm, -3, @todate)
      then isnull(amount,0) else 0 end) as col09
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 9, @fromdate) AND DATEADD(mm, -2, @todate)
      then isnull(amount,0) else 0 end) as col10
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 10, @fromdate) AND DATEADD(mm, -1, @todate)
      then isnull(amount,0) else 0 end) as col11
,     sum(CASE WHEN CAST([effdate] AS DATETIME) BETWEEN DATEADD(mm, 11, @fromdate) AND DATEADD(mm, 0, @todate)
      then isnull(amount,0) else 0 end) as col12
,     sum(isnull(amount,0))  Amount
, 2 as style
 from @ExpSummary    
 group by particular
end
GO
