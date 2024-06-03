SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    procedure [dbo].[getNaturofServicetobeMappedList](   --getNaturofServicetobeMappedList 7937,148  
@batchid int,  
@tenantid int  
)as  
begin  
SELECT t.LedgerHeader
FROM (
    SELECT LedgerHeader
    FROM ImportBatchData IB
    WHERE batchid = @batchid
      AND tenantid = @tenantid
      AND IB.UniqueIdentifier IN (
          SELECT UniqueIdentifier
          FROM importstandardfiles_ErrorLists
          WHERE batchid = @batchid
            AND tenantid = @tenantid
            AND ErrorType = '114'
      )
    GROUP BY LedgerHeader
) AS t
WHERE t.LedgerHeader NOT IN (
    SELECT Name
    FROM HeadOfPayment
);


end
GO
