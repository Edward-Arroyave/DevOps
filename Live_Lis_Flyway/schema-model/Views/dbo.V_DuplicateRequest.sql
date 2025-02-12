SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[V_DuplicateRequest] AS
WITH RequestPairs AS (
    SELECT 
        t1.RequestNumber AS RequestNumber1, t1.IdRequest AS IdRequest1, t1.CreationDate AS CreationDate1, 
        t2.RequestNumber AS RequestNumber2, t2.IdRequest AS IdRequest2, t2.CreationDate AS CreationDate2,
        t1.IdRequestStatus AS Status1, t2.IdRequestStatus AS Status2
    FROM 
        TB_Request t1
    INNER JOIN 
        TB_Request t2 ON t1.IdRequest < t2.IdRequest -- Para evitar duplicados y comparar una vez
    WHERE 
        MONTH(t1.CreationDate) = 5 AND MONTH(t2.CreationDate) = 5 -- Filtrar por el mes de mayo
        AND YEAR(t1.CreationDate) = YEAR(GETDATE()) AND YEAR(t2.CreationDate) = YEAR(GETDATE()) -- Asegurarse de que estamos en el año actual
        AND DAY(t2.CreationDate) = DAY(t1.CreationDate)
        AND t1.IdAdmissionSource = t2.IdAdmissionSource
        AND t1.IsEmergency = t2.IsEmergency
        AND t1.IdAttentionCenter = t2.IdAttentionCenter
        AND t1.IdPatient = t2.IdPatient
        AND t1.IdContract = t2.IdContract
        AND t1.IdRequestStatus = t2.IdRequestStatus
		AND t1.IdRequestStatus != 2 AND t2.IdRequestStatus != 2
)
SELECT 
    rp.RequestNumber1, rp.IdRequest1, rp.CreationDate1, rp.Status1, 
    rp.RequestNumber2, rp.IdRequest2, rp.CreationDate2, rp.Status2
FROM 
    RequestPairs rp
INNER JOIN 
    (SELECT IdRequest, COUNT(IdExam) AS ExamCount, STRING_AGG(CAST(IdExam AS VARCHAR), ',') AS ExamList
     FROM TR_Request_Exam
     GROUP BY IdRequest) re1 ON rp.IdRequest1 = re1.IdRequest
INNER JOIN 
    (SELECT IdRequest, COUNT(IdExam) AS ExamCount, STRING_AGG(CAST(IdExam AS VARCHAR), ',') AS ExamList
     FROM TR_Request_Exam
     GROUP BY IdRequest) re2 ON rp.IdRequest2 = re2.IdRequest
WHERE 
    re1.ExamCount = re2.ExamCount
    AND re1.ExamList = re2.ExamList

GO
