SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/10/2022	
-- Description: Procedimiento almacenado para crear venta a un paciente.
-- =============================================
/* 
EXEC [sp_Consult_SampleRegistration] 50922, 1
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_SampleRegistration]
(
	@IdRequest int,
	@SampleRegistrationStatus int
)
AS
BEGIN
    SET NOCOUNT ON

	-- Recibidas
	IF @SampleRegistrationStatus = 2
		BEGIN
			SELECT A.IdSampleRegistration, A.IdRequest, 
				STUFF ((
					SELECT ' - ', + CONVERT(varchar(10),EX.ExamCode)
					FROM TB_Request RQ
					INNER JOIN TR_Request_Exam RE
						ON RE.IdRequest = RQ.IdRequest AND RE.Active = 'True'
					INNER JOIN TB_Exam EX
						ON EX.IdExam = RE.IdExam
					INNER JOIN TR_Exam_SampleType EST on RE.idexam = EST.IdExam and A.IdSampleType = EST.IdSampleType
					WHERE RQ.IdRequest = A.IdRequest
				FOR XML PATH('')),2,1,'') ExamCode,
				STUFF ((
					SELECT ', ', + CONVERT(varchar(10),EX.ExamCode) + ' ' + CONVERT(varchar(500),EX.ExamName)
					FROM TB_Request RQ
					INNER JOIN TR_Request_Exam RE
						ON RE.IdRequest = RQ.IdRequest
							AND RE.Active = 'True'
					INNER JOIN TB_Exam EX
						ON EX.IdExam = RE.IdExam
					INNER JOIN TR_Exam_SampleType EST on RE.idexam = EST.IdExam and A.IdSampleType = EST.IdSampleType
					WHERE RQ.IdRequest = A.IdRequest
				FOR XML PATH('')),1,1,'') ExamName,	
				ISNULL(A.LabelCodeAlternative, A.LabelCode) LabelCode, B.SampleType, A.TakingDate, C.ContainerTypeName, C.Color, A.IdSampleRegistrationStatus,
					CASE WHEN A.IdSampleRegistrationStatus IN (1,2) THEN D.SampleRegistrationStatus 
						WHEN A.IdSampleRegistrationStatus IN (3,4) THEN NULL 
						ELSE NULL END SampleRegistrationStatus,
					CASE WHEN A.IdSampleRegistrationStatus = 4 THEN NULL 
						ELSE A.ReceptionDate END ReceptionDate,
					CASE WHEN A.IdSampleRegistrationStatus = 4 THEN NULL 
						WHEN  A.IdSampleRegistrationStatus = 3 THEN NULL 
					ELSE A.ReceptionPostpDate END ReceptionPostpDate,
					R.IdRequestServiceType,
					AD.IdAdmissionSource, AD.AdmissionSource
			FROM TB_Request R
			INNER JOIN TB_SampleRegistration A ON R.IdRequest = A.IdRequest
			INNER JOIN TB_SampleType B
				ON B.IdSampleType = A.IdSampleType
			LEFT JOIN TB_ContainerType C
				ON C.IdContainerType = A.IdContainerType
			LEFT JOIN TB_SampleRegistrationStatus D
				ON D.IdSampleRegistrationStatus = A.IdSampleRegistrationStatus
			LEFT JOIN tb_admissionsource AD on R.IdAdmissionSource = AD.IdAdmissionSource
			WHERE A.IdRequest = @IdRequest
				AND A.Active ='True'
				order by a.labelcode
		END
	-- Tomadas
	ELSE IF @SampleRegistrationStatus = 1
		BEGIN
			SELECT A.IdSampleRegistration, A.IdRequest, 
				STUFF ((
					SELECT ' - ', + CONVERT(varchar(10),EX.ExamCode)
					FROM TB_Request RQ
					INNER JOIN TR_Request_Exam RE
						ON RE.IdRequest = RQ.IdRequest
							AND RE.Active = 'True'
					INNER JOIN TB_Exam EX
						ON EX.IdExam = RE.IdExam
					INNER JOIN TR_Exam_SampleType EST on RE.idexam = EST.IdExam and A.IdSampleType = EST.IdSampleType
					WHERE RQ.IdRequest = A.IdRequest
				FOR XML PATH('')),2,1,'') ExamCode,
				STUFF ((
					SELECT ', ', + CONVERT(varchar(10),EX.ExamCode) + ' ' + CONVERT(varchar(500),EX.ExamName)
					FROM TB_Request RQ
					INNER JOIN TR_Request_Exam RE
						ON RE.IdRequest = RQ.IdRequest
							AND RE.Active = 'True'
					INNER JOIN TB_Exam EX
						ON EX.IdExam = RE.IdExam
					INNER JOIN TR_Exam_SampleType EST on RE.idexam = EST.IdExam and A.IdSampleType = EST.IdSampleType
					WHERE RQ.IdRequest = A.IdRequest
				FOR XML PATH('')),1,1,'') ExamName,	
			ISNULL(A.LabelCodeAlternative, A.LabelCode) LabelCode, B.SampleType, A.ReceptionDate, C.ContainerTypeName, C.Color, A.IdSampleRegistrationStatus,
			CASE WHEN A.IdSampleRegistrationStatus IN (3,4) THEN D.SampleRegistrationStatus 
				WHEN A.IdSampleRegistrationStatus = 2 THEN NULL 
				WHEN A.IdSampleRegistrationStatus = 1 THEN 'Tomada' 
				ELSE NULL END SampleRegistrationStatus,
			CASE WHEN A.IdSampleRegistrationStatus = 2 THEN NULL 
				ELSE A.TakingDate END TakingDate,
			CASE WHEN A.IdSampleRegistrationStatus = 2 THEN NULL 
				ELSE A.TakingPostpDate END TakingPostpDate,
				R.IdRequestServiceType,
				AD.IdAdmissionSource, AD.AdmissionSource
			FROM TB_Request R
			INNER JOIN TB_SampleRegistration A ON R.IdRequest = A.IdRequest
			INNER JOIN TB_SampleType B
				ON B.IdSampleType = A.IdSampleType
			LEFT JOIN TB_ContainerType C
				ON C.IdContainerType = A.IdContainerType
			LEFT JOIN TB_SampleRegistrationStatus D
				ON D.IdSampleRegistrationStatus = A.IdSampleRegistrationStatus
					AND (A.IdSampleRegistrationStatus IN (1,3,4)
						OR A.IdSampleRegistrationStatus IS NULL)
			LEFT JOIN tb_admissionsource AD on R.IdAdmissionSource = AD.IdAdmissionSource
			WHERE A.IdRequest = @IdRequest
				AND A.Active ='True'
				order by a.labelcode
		END
END
GO
