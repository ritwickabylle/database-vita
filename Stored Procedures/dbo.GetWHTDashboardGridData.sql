SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
      
CREATE       PROCEDURE [dbo].[GetWHTDashboardGridData]      
(      
    @FromDate DATETIME, -- exec GetWHTDashboardGridData '2022-01-01', '2023-12-01', 2, 1     
    @ToDate DATETIME,      
    @tenantId INT = NULL,      
    @ReportType INT = 1      
)      
AS      
BEGIN      
    DECLARE @griddashboard AS TABLE      
    (      
  id int IDENTITY(1,1),  
        [Month] NVARCHAR(MAX),      
        [TotalForeignPayments] NVARCHAR(MAX),      
        [Material] NVARCHAR(MAX),      
        [NotSaudiSourceIncome] NVARCHAR(MAX),      
        [SaudiSourceIncome] NVARCHAR(MAX),      
        [NonTreaty] NVARCHAR(MAX),      
        [Treaty] NVARCHAR(MAX),      
        [Upfront] NVARCHAR(MAX),      
        [Refund] NVARCHAR(MAX),      
        [Status] NVARCHAR(MAX),      
        [ReturnFilingDueDate] NVARCHAR(MAX),      
        [ReturnFiledDate] NVARCHAR(MAX)      
    );      
      
    WITH NonTreatyCTE AS      
    (      
        SELECT      
            MONTH(v.IssueDate) AS [Month],      
            YEAR(v.IssueDate) AS [Year],      
            ISNULL(SUM(v.LineAmountInclusiveVAT), 0) AS NonTreatySum      
        FROM      
            VI_importstandardfiles_Processed v      
        WHERE      
            v.TenantId = @tenantId      
            AND v.IssueDate >= @FromDate      
            AND v.IssueDate <= @ToDate      
            AND v.BuyerCountryCode NOT IN (SELECT DISTINCT ALPHACODE FROM WHTDTTRATES)      
            AND v.InvoiceType LIKE 'WHT%'      
        GROUP BY      
            YEAR(v.IssueDate),      
            MONTH(v.IssueDate)      
    ),      
    TreatyCTE AS      
    (      
        SELECT      
            MONTH(v.IssueDate) AS [Month],      
            YEAR(v.IssueDate) AS [Year],      
            ISNULL(SUM(v.LineAmountInclusiveVAT), 0) AS TreatySum      
        FROM      
            VI_importstandardfiles_Processed v      
        WHERE      
            v.TenantId = @tenantId      
            AND v.IssueDate >= @FromDate      
            AND v.IssueDate <= @ToDate      
            AND v.BuyerCountryCode IN (SELECT DISTINCT ALPHACODE FROM WHTDTTRATES)      
            AND v.InvoiceType LIKE 'WHT%'      
        GROUP BY      
            YEAR(v.IssueDate),      
            MONTH(v.IssueDate)      
    )      
      
    INSERT INTO @griddashboard      
 SELECT      
  LEFT(DATENAME(MONTH, DATEFROMPARTS(YEAR(v.IssueDate), MONTH(v.IssueDate), 1)), 3) + ' ' + CAST(YEAR(v.IssueDate) AS NVARCHAR(4)) AS [Month],      
  CAST(SUM(LineAmountInclusiveVAT) AS NVARCHAR(MAX)) AS Salary,      
  CONVERT(NVARCHAR(MAX), ISNULL(SUM(CASE WHEN V.NatureofServices = 'Supply of Goods' THEN v.LineAmountInclusiveVAT ELSE 0 END), 0)) AS [For Material Consumables And Spares],      
  CONVERT(NVARCHAR(MAX), ISNULL(SUM(CASE WHEN V.NatureofServices = 'Not a Saudi Source Income' THEN v.LineAmountInclusiveVAT ELSE 0 END), 0)) AS [Not A Saudi Source Income],      
  CONVERT(NVARCHAR(MAX), ISNULL(SUM(CASE WHEN V.NatureofServices <> 'Not a Saudi Source Income' AND V.NatureofServices <> 'Other Payments - Not subject to WHT' THEN v.LineAmountInclusiveVAT ELSE 0 END), 0)) AS [Saudi Source Income],      
  CONVERT(NVARCHAR(MAX), ISNULL((SELECT NonTreatySum FROM NonTreatyCTE WHERE [Month] = MONTH(v.IssueDate) AND [Year] = YEAR(v.IssueDate)), 0)) AS [Non Treaty],      
  CONVERT(NVARCHAR(MAX), ISNULL((SELECT TreatySum FROM TreatyCTE WHERE [Month] = MONTH(v.IssueDate) AND [Year] = YEAR(v.IssueDate)), 0)) AS [Treaty],      
  '0' AS [Upfront],      
  '0' AS [Refund],      
  'Filed' AS [Status],      
   CONVERT(NVARCHAR(10), DATEADD(DAY, 10, EOMONTH(DATEADD(MONTH, 1, v.IssueDate), -1)), 120) AS [Return Filing Due Date],      
  NULL AS [Return Filed Due Date]      
 FROM      
  VI_importstandardfiles_Processed v      
 WHERE      
   v.TenantId = @tenantId AND v.IssueDate >= @FromDate AND v.IssueDate <= @ToDate AND v.InvoiceType LIKE 'WHT%'      
 GROUP BY      
  YEAR(v.IssueDate),      
  MONTH(v.IssueDate),      
  DATEADD(DAY, 10, EOMONTH(DATEADD(MONTH, 1, v.IssueDate), -1))   
 ORDER BY      
  YEAR(v.IssueDate),      
  MONTH(v.IssueDate)      
      
     
  if exists (select top 1 id from @griddashboard)    
  begin    
    SELECT      
        [Month],      
        TotalForeignPayments AS [Total Foreign Payments],      
        Material AS [For Material, Consumables and Spares],      
        NotSaudiSourceIncome AS [Not a Saudi Source Income],      
        SaudiSourceIncome AS [Saudi Source Income],      
        NonTreaty AS [Non Treaty],      
        Treaty AS [Treaty Country],      
        Upfront AS [Upfront],      
        Refund AS [Refund],      
        Status AS [Status],      
        FORMAT(CAST(ReturnFilingDueDate AS DATETIME), 'dd-MMM-yy') AS [Return Filing Due Date],      
        ReturnFiledDate   AS [Return Filed Date]  
    FROM      
        @griddashboard      
 end    
 else     
 begin    
  SELECT      
        Null as [Month],      
        0.00 AS [Total Foreign Payments],      
        0.00 AS [For Material, Consumables and Spares],      
        0.00 AS [Not a Saudi Source Income],      
        0.00 AS [Saudi Source Income],      
        0.00 AS [Non Treaty],      
        0.00 AS [Treaty Country],      
        0.00 AS [Upfront],      
        0.00 AS [Refund],      
        null AS [Status],      
        null AS [Return Filing Due Date],      
        null as [Return Filed Date]     
   
 end    
END
GO
