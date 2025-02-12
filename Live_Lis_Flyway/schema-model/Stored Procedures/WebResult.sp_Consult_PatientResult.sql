SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/09/2023
-- Description: Procedimiento almacenado para consultar lo resultados de un paciente.
-- =============================================
--EXEC [WebResult].[sp_Consult_PatientResult] 3670,'','','',''
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Consult_PatientResult]
(
	@IdPatient int,
	@InitialDate date,
	@FinalDate date, 
	@RequestNumber varchar(15),
	@RequestStatus varchar(1)
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

	IF @InitialDate != '' AND @FinalDate != ''
		BEGIN
			SET @InitialDateTime = @InitialDate
			SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		END
	ELSE
		BEGIN
			SET @InitialDateTime = '' 
			SET @FinalDateTime = ''
		END

	SELECT A.IdPatient, CONCAT(B.IdentificationTypeCode, ' ', A.IdentificationNumber) AS IdentificationNumber, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) AS PatientName
	FROM carehis.TB_Patient_Ext A
	INNER JOIN carehis.TB_IdentificationType_Ext B
		ON B.IdIdentificationType = A.IdIdentificationType
	WHERE A.IdPatient = @IdPatient
		
	SELECT IdRequest, RequestDate, RequestNumber, Exams,
		CASE WHEN IdRequestStatus = 1 THEN 'En espera de resultados'
			WHEN IdRequestStatus = 2 THEN 'Resultados parciales'
			WHEN IdRequestStatus = 3 THEN 'Finalizados' END AS RequestStatus
	FROM (
		SELECT A.IdRequest, A.RequestDate, A.RequestNumber, A.IdPatient, 
			STUFF((SELECT DISTINCT ', ', + CONVERT(varchar(10),C.ExamCode), ' - ', CONVERT(varchar(500),C.ExamName)
					FROM TR_Patient_Exam B
					INNER JOIN TB_Exam C
						ON C.IdExam = B.IdExam
					WHERE B.IdRequest = A.IdRequest
					FOR XML PATH ('')
					),1,1,'') Exams,
			CASE WHEN A.IdRequestStatus IN (3,4,5) THEN 1
				WHEN A.IdRequestStatus IN (1) THEN 2
				WHEN A.IdRequestStatus IN (6,9,10) THEN 3 END AS IdRequestStatus
		FROM TB_Request A
		INNER JOIN TB_RequestStatus B
			ON B.IdRequestStatus = A.IdRequestStatus
		WHERE A.IdPatient = @IdPatient
		) SOURCE
	WHERE ((RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
		AND (@InitialDateTime != '' OR @FinalDateTime != '')
			OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND CASE WHEN @RequestNumber = '' THEN '' ELSE RequestNumber END = @RequestNumber
		AND CASE WHEN @RequestStatus = '' THEN '' ELSE IdRequestStatus END = @RequestStatus
	ORDER BY 2 DESC

END
GO
