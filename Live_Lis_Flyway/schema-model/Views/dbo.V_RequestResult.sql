SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dbo].[V_RequestResult] AS
SELECT B.IdPatient, B.IdRequest, B.RequestDate, B.RequestNumber,
	STUFF ((
			SELECT DISTINCT ',' + CONVERT(varchar(1),IdAnalyticalStatus)
			FROM (
				SELECT DISTINCT IdRequest, IdAnalyticalStatus
					,ROW_NUMBER () OVER (PARTITION BY IdRequest, IdExam, /*IdAnalyte,*/ IdAnalyticalStatus ORDER BY IdAnalyticalStatus ) ResultStatus
				FROM (
						SELECT DISTINCT A.IdRequest, B.IdExam, /*E.IdAnalyte,*/ ISNULL(C.IdAnalyticalStatus,0) AS IdAnalyticalStatus
						FROM TB_Request A
						INNER JOIN TR_Patient_Exam B
							ON B.IdRequest = A.IdRequest
						INNER JOIN TB_Exam D
							ON D.IdExam = B.IdExam
						--INNER JOIN TB_Analyte E
						--	ON E.IdExam = D.IdExam
						LEFT JOIN ANT.TB_Results C
							ON C.IdPatient_Exam = B.IdPatient_Exam
								--AND C.IdAnalyte = E.IdAnalyte
						--WHERE E.Active = 'True'
						--	AND A.IdRequest = 71585
					) SOURCE
				) A
			WHERE A.IdRequest = B.IdRequest
			FOR XML PATH('')
			),1,1,'') ResultStatus
FROM TB_Request B
--WHERE B.IdRequest = 71585

GO
