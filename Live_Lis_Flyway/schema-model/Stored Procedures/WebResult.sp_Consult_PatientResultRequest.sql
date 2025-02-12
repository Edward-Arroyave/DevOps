SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/09/2023
-- Description: Procedimiento almacenado para consultar los exámenes en la solicitud de un paciente.
-- =============================================
--EXEC [WebResult].[sp_Consult_PatientResultRequest] 71418
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Consult_PatientResultRequest]
(
	@IdRequest int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdPatient, CONCAT(F.IdentificationTypeCode, ' ', B.IdentificationNumber) AS IdentificationNumber, CONCAT_WS(' ', B.FirstName, B.SecondName, B.FirstLastName, B.SecondLastName) AS PatientName,
		B.BirthDate, dbo.FnS_GetAge(B.BirthDate, DATEADD(HOUR,-5,GETDATE())) AS Age, C.BiologicalSex, E.CompanyName, G.AffiliationCategory, B.TelephoneNumber, B.Email, B.Address
	FROM TB_Request A
	INNER JOIN carehis.TB_Patient_Ext B
		ON B.IdPatient = A.IdPatient
	INNER JOIN carehis.TB_BiologicalSex_Ext C
		ON C.IdBiologicalSex = B.IdBiologicalSex
	INNER JOIN TB_Contract D
		ON D.IdContract = A.IdContract
	INNER JOIN TB_Company E
		ON E.IdCompany = D.IdCompany
	INNER JOIN carehis.TB_IdentificationType_Ext F
		ON F.IdIdentificationType = B.IdIdentificationType
	INNER JOIN carehis.TB_AffiliationCategory_Ext G
		ON G.IdAffiliationCategory = B.IdAffiliationCategory
	WHERE A.IdRequest = @IdRequest

	SELECT DISTINCT A.IdRequest, A.IdPatient, A.RequestNumber, D.IdPatient_Exam, B.IdExam, CONCAT(C.ExamCode, ' - ', C.ExamName) ExamName, 
		--CASE WHEN A.IdRequestStatus IN (1,3,4,5,6) THEN 'En espera de resultados'
		--		--WHEN A.IdRequestStatus = 6 THEN 'Resultados parciales'
		--		WHEN A.IdRequestStatus IN (9,10) THEN 'Con resultado' END AS RequestStatus
		CASE WHEN E.IdAnalyticalStatus IN (1,5,6) OR E.IdAnalyticalStatus IS NULL THEN 'En espera de resultados'
				WHEN E.IdAnalyticalStatus IN (2,3,4,7) THEN 'Con resultado' END AS RequestStatus
	FROM TB_Request A
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_Exam C
		ON C.IdExam = B.IdExam
	INNER JOIN TR_Patient_Exam D
		ON D.IdRequest = A.IdRequest
			AND D.IdExam = B.IdExam
	LEFT JOIN ANT.TB_Results E
		ON E.IdPatient_Exam = D.IdPatient_Exam
	LEFT JOIN ANT.TB_AnalyticalStatus F
		ON F.IdAnalyticalStatus = E.IdAnalyticalStatus
	WHERE A.IdRequest = @IdRequest
		AND B.Active = 'True'
END
GO
