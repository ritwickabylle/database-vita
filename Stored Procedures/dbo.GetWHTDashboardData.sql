SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
CREATE        PROCEDURE [dbo].[GetWHTDashboardData]    
(@FromDate datetime,    --  exec GetWHTDashboardData '2023-01-01','2024-12-31',161,0    
@ToDate datetime,    
@tenantId int=null,    
@ReportType int=1)      
as      
begin      
    
DECLARE @WhtDetailReport AS TABLE            
(    
 SLNO int identity(1,1),            
 Typeofpayment nvarchar(100),                          
 Payment decimal(18,2),                  
 WHT decimal(18,2)  ,                                
 WHTPaid decimal(18,2),        
 DTTdiff decimal(18,2)      
)     
      
INSERT INTO @WhtDetailReport (TypeofPayment,Payment,WHT,WHTPaid,DTTdiff)        
SELECT v.Natureofservices,SUM(ROUND(v.LineAmountInclusiveVAT,2)),            
SUM(ROUND(v.LineAmountInclusiveVAT*p.effrate/100,2)),SUM(ISNULL(v.LineNetAmount,0)),        
SUM(ROUND(v.LineAmountInclusiveVAT*p.LawRate/100,2)) - SUM(ROUND(v.LineAmountInclusiveVAT*p.EffRate/100,2))    
FROM VI_importstandardfiles_Processed v             
INNER JOIN vi_paymentWHTrate p ON v.UniqueIdentifier = p.uniqueidentifier           
WHERE v.TenantId=@tenantId AND v.IssueDate >= @fromdate AND v.IssueDate<= @todate AND v.InvoiceType like 'WHT%'     
GROUP BY v.NatureofServices       
ORDER BY v.NatureofServices              
          
INSERT INTO @WhtDetailReport(TypeofPayment,Payment,WHT,WHTPaid,DTTdiff)     
SELECT 'Total',SUM(payment),SUM(WHT),SUM(WHTpaid),sum(dttdiff) FROM @WhtDetailReport    
WHERE SLNO in ('01','02','03','04','05','06','07','08','09','10','11')    
    
INSERT INTO @WhtDetailReport(TypeofPayment,Payment)    
SELECT 'ADD:Payments not subject to WHT',ISNULL(SUM(ROUND(v.LineAmountInclusiveVAT,2)),0) from VI_importstandardfiles_Processed v    
WHERE v.NatureofServices like '%Other Payments - Not subject to WHT%' and    
v.TenantId=@tenantId AND v.IssueDate >= @fromdate AND v.IssueDate<= @todate AND v.InvoiceType like 'WHT%'               
    
    
INSERT INTO @WhtDetailReport(Typeofpayment,Payment)    
SELECT 'Total Payments',sum(payment)  FROM @WhtDetailReport where TypeofPayment in ('ADD:Payments not subject to WHT','Total')      
  
declare @payment decimal(10,2)  
select @payment = Payment from @WhtDetailReport where Typeofpayment = 'Total Payments'  
if @payment > 0  
begin  
SELECT     
 Typeofpayment AS Typeofpayments,    
 ISNULL(Payment,0) AS totalamountPaid,    
 ISNULL(WHT,0) AS taxDue,    
 ISNULL(WHTPaid,0) AS [WHT Paid],    
 ISNULL(DTTdiff,0) AS [DTT Difference]    
    
FROM @WhtDetailReport    
  end  
  else  
  begin  
 SELECT     
  'Total' AS Typeofpayments,    
  0.00 AS totalamountPaid,    
  0.00 AS taxDue,    
  0.00 AS [WHT Paid],    
  0.00 AS [DTT Difference]   
  end  
      
end
GO
