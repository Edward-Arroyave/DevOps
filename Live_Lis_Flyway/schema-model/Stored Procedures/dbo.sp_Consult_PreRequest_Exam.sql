SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/09/2022
-- Description: Procedimiento almacenado para consultar examenes asociados a un presolicitud.
-- =============================================
-- EXEC [dbo].[sp_Consult_PreRequest_Exam] 36
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_PreRequest_Exam]
(
	@IdPreRequest int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdPreRequest, C.IdExam, C.ExamCode, C.ExamName, C.IdAdditionalForm AS EIdAdditionalForm, A.IdCompany, A.IdContract, E.IdContractType, E.ContractName, A.IdPatient, G.Value, E.IdGenerateCopay_CM, 
		C.IdSection, E.IdAdditionalForm
	FROM TB_PreRequest A
	INNER JOIN TR_PreRequest_Exam B
		ON B.IdPreRequest = A.IdPreRequest
	INNER JOIN TB_Exam C
		ON C.IdExam = B.IdExam
	INNER JOIN TB_Company D
		ON D.IdCompany = A.IdCompany
	INNER JOIN TB_Contract E
		ON E.IdContract = A.IdContract
	INNER JOIN TB_TariffScheme F
		ON F.IdTariffScheme = E.IdTariffScheme
	INNER JOIN TR_TariffScheme_Service G
		ON G.IdTariffScheme = F.IdTariffScheme
			AND G.IdExam = C.IdExam
	WHERE A.IdPreRequest = @IdPreRequest
		AND B.Active = 'True'
		AND A.IdPreRequestStatus = 1
	ORDER BY 1
END
GO
