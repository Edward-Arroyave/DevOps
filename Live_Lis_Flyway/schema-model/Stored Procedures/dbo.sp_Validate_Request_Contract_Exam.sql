SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/09/2022
-- Description: Procedimiento almacenado para validar que los examenes de una presolicitud esten dentro del contrato/plan.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Validate_Request_Contract_Exam]
(
	@Request_Contract_Exams Request_Contract_Exams READONLY
)
AS
BEGIN

    SET NOCOUNT ON

	SELECT A.IdPreRequest, A.IdContract, A.IdExam, A.ExamCode, B.Value, B.IdGenerateCopay_CM, B.IdSection, CASE WHEN B.IdExam IS NOT NULL THEN 1 ELSE 0 END Belong
	FROM @Request_Contract_Exams A
	LEFT JOIN (
				SELECT IdContract, B.IdTariffScheme, D.IdExam, D.ExamCode, C.Value, A.IdGenerateCopay_CM, D.IdSection
				FROM TB_Contract A
				INNER JOIN TB_TariffScheme B
					ON B.IdTariffScheme = A.IdTariffScheme
				INNER JOIN TR_TariffScheme_Service C
					ON C.IdTariffScheme = B.IdTariffScheme
				INNER JOIN TB_Exam D
					ON D.IdExam = C.IdExam
			) B
		ON B.IdContract = A.IdContract
			AND B.IdExam = A.IdExam
END
GO
