SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[V_ExamResult] AS
SELECT B.IdPatient, B.IdRequest, B.RequestDate, B.RequestNumber, C.IdPatient_Exam, C.IdExam,
	STUFF ((
			SELECT DISTINCT ',' + CONVERT(varchar(1),IdAnalyticalStatus)
			FROM (
				SELECT DISTINCT IdRequest, IdExam, IdPatient_Exam, IdAnalyticalStatus
					,ROW_NUMBER () OVER (PARTITION BY IdRequest, IdExam, IdAnalyticalStatus ORDER BY IdAnalyticalStatus ) ResultStatus
				FROM (
						SELECT DISTINCT A.IdRequest, B.IdExam, B.IdPatient_Exam, C.IdAnalyticalStatus
						FROM TB_Request A
						INNER JOIN TR_Patient_Exam B
							ON B.IdRequest = A.IdRequest
						INNER JOIN ANT.TB_Results C
							ON C.IdPatient_Exam = B.IdPatient_Exam
					) SOURCE
				) A
			WHERE A.IdRequest = B.IdRequest
				AND A.IdExam = C.IdExam
			FOR XML PATH('')
			),1,1,'') ResultStatus
FROM TB_Request B
INNER JOIN TR_Patient_Exam C
	ON C.IdRequest = B.IdRequest

GO
