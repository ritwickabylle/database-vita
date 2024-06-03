SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[GetPaymentTypeWiseSummary]        
(        
@FromDate datetime,    --  exec  [GetPaymentTypeWiseSummary] '2023-01-01','2023-12-31',161        
        
@ToDate datetime,          
@tenantId int=null,          
@ReportType int=1           
)        
        
AS        
BEGIN        
        
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
SUM(ROUND(v.LineAmountInclusiveVAT*p.LawRate/100,2)) - SUM(ISNULL(v.LineNetAmount,0))       
FROM VI_importstandardfiles_Processed v                 
INNER JOIN vi_paymentWHTrate p ON v.UniqueIdentifier = p.uniqueidentifier               
WHERE v.TenantId=@tenantId AND v.IssueDate >= @fromdate AND v.IssueDate<= @todate AND v.InvoiceType like 'WHT%'  and v.Natureofservices <> 'Other Payments - Not subject to WHT'        
GROUP BY v.NatureofServices           
ORDER BY v.NatureofServices                  
  
declare @slno INT;  
select @slno =max(slno) from @WhtDetailReport  
INSERT INTO @WhtDetailReport(TypeofPayment,Payment,WHT,WHTPaid,DTTdiff)         
SELECT 'Payments Subject to WHT',SUM(payment),SUM(WHT),SUM(WHTpaid),sum(dttdiff) FROM @WhtDetailReport        
WHERE SLNO <=@slno       
        
INSERT INTO @WhtDetailReport(TypeofPayment,Payment)        
SELECT 'ADD:Payments not subject to WHT',ISNULL(SUM(ROUND(v.LineAmountInclusiveVAT,2)),0) from VI_importstandardfiles_Processed v        
WHERE v.NatureofServices like '%Other Payments - Not subject to WHT%' and        
v.TenantId=@tenantId AND v.IssueDate >= @fromdate AND v.IssueDate<= @todate AND v.InvoiceType like 'WHT%'                   
        
        
INSERT INTO @WhtDetailReport(Typeofpayment,Payment)        
SELECT 'Total Payments',sum(payment)  FROM @WhtDetailReport where TypeofPayment in ('ADD:Payments not subject to WHT','Payments Subject to WHT')        
  
declare @payment decimal(10,2)      
select @payment = Payment from @WhtDetailReport where Typeofpayment = 'Total Payments'      
if @payment > 0      
begin      
SELECT         
 Typeofpayment AS Typeofpayment,        
 ISNULL(Payment,0) AS Payment,        
 WHT AS WHT,        
 WHTPaid AS [WHT Paid],        
 DTTdiff AS [DTT Difference]        
        
FROM @WhtDetailReport        
  end      
  else      
  begin      
 SELECT         
  'Total Payments' AS Typeofpayment,        
  0.00 AS Payment,        
  0.00 AS WHT,        
  0.00 AS [WHT Paid],        
  0.00 AS [DTT Difference]       
  end      
END
GO
