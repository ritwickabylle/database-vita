SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE              PROCEDURE [dbo].[GetWHTDashboardDataCountryWise](     --exec  [GetWHTDashboardDataCountryWise] '2023-01-01','2024-01-31',159      
-- exec paymenttransvalidation 5785
@FromDate datetime,        
@ToDate datetime,      
@tenantId int=null, 
@ReportType int=1
)        
AS        
BEGIN        
DECLARE @WhtDetailReport AS TABLE        
(
	SLNO int identity(1,1),        
	Country nvarchar(100),                      
	Payment decimal(18,2),              
	WHT decimal(18,2)  ,                            
	WHTPaid decimal(18,2),    
	DTTdiff decimal(18,2)  
)        
    
INSERT INTO @WhtDetailReport (Country,Payment,WHT,WHTPaid,DTTdiff)            
SELECT (Case when v.BuyerCountryCode IN (SELECT DISTINCT ALPHACODE FROM WHTDTTRATES) then '*'+v.BuyerCountryCode+'*' else v.BuyerCountryCode end),SUM(ROUND(v.LineAmountInclusiveVAT,2)),        
SUM(ROUND(v.LineAmountInclusiveVAT*p.effrate/100,2)),SUM(ISNULL(v.LineNetAmount,0)),    
SUM(ROUND(v.LineAmountInclusiveVAT*p.LawRate/100,2)) - SUM(ROUND(v.LineAmountInclusiveVAT*p.EffRate/100,2))
FROM VI_importstandardfiles_Processed v         
INNER JOIN vi_paymentWHTrate p ON v.UniqueIdentifier = p.uniqueidentifier   
--inner join Country c ON c.AlphaCode=v.BuyerCountryCode
WHERE v.TenantId=@tenantId AND v.IssueDate >= @fromdate AND v.IssueDate<= @todate AND v.InvoiceType LIKE 'WHT%' 
GROUP BY v.BuyerCountryCode
        
declare @slno int;
select @slno= max(slno) from @WhtDetailReport

INSERT INTO @WhtDetailReport(Country,Payment,WHT,WHTPaid,DTTdiff) 
SELECT 'Total',sum(payment),sum(WHT),SUM(WHTpaid),sum(dttdiff) FROM @WhtDetailReport
WHERE SLNO <=@slno 


select 
	Country,
	ISNULL(Payment,0.00) AS Payment,
	ISNULL(WHT,0.00) AS WHT,
	ISNULL(WHTPaid,0.00) AS WHTPaid,
	ISNULL(DTTdiff,0.00) AS DTTdiff
from @WhtDetailReport   

END
GO
