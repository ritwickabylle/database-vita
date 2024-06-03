SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      PROCEDURE [dbo].[GetDataCIT_Reclassification]      
(      
 @fromdate DATETIME,      
 @todate DATETIME,      
 @tenantid INT      
)      
AS      
BEGIN      
 SELECT UniqueIdentifier,
 EntryNo as 'EntryNo',
 GLName as 'GL Name',
 TAXMAP as 'Tax Map',
 PreGLBal as 'Preliminary GL Balance',
 Debit as 'Debit',
 Credit as 'Credit',
 FinalGLBal as 'Final Balance',
 Comments as 'Comments'
 FROM TrialBalance_Reclassification where isActive = 1 and Tenantid = @tenantid    order by id desc  
END
GO
