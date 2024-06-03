SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[GetCITBatchData]   --exec GetCITBatchData 148, '2024-01-08', '2024-01-10'
(
  @tenantId INT,      
  @fromdate DATETIME = NULL,        
  @todate DATETIME = NULL  
)
AS
BEGIN
    CREATE TABLE #TempCITBatchData
    (
        BatchNo INT,
        ScheduleName NVARCHAR(255),
        FileName NVARCHAR(255),
        UploadedOn DATETIME,
        UploadedBy NVARCHAR(255),
        TotalRecord INT
    );

    INSERT INTO #TempCITBatchData (BatchNo, ScheduleName, FileName, UploadedOn, UploadedBy, TotalRecord)
    VALUES
        (1, 'Schedule 1', 'File_A.txt', '2024-01-08', 'User1', 100),
        (2, 'Schedule 2', 'File_B.txt', '2024-01-09', 'User2', 150),
        (3, 'Schedule 3', 'File_C.txt', '2024-01-10', 'User3', 200);

    --IF (@fromdate IS NOT NULL AND @todate IS NOT NULL)
    --BEGIN
    --    DELETE FROM #TempCITBatchData
    --    WHERE UploadedOn < @fromdate OR UploadedOn > @todate;
    --END

    SELECT BatchNo, ScheduleName, FileName, UploadedOn, UploadedBy, TotalRecord
    FROM #TempCITBatchData;

    DROP TABLE #TempCITBatchData;
END
GO
