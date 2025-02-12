SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 18/01/2023
-- Description: Procedimiento almacenado para excepciones creadas a un contrato especifico.
-- =============================================
--EXEC [sp_Consult_ContractException] 106
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ContractException]
(
	@IdContract int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdContractException, A.IdContract, B.ContractName, B.IdCompany, D.IdTypeOfProcedure, G.TypeOfProcedure, A.IdService, F.CUPS, A.IdExam, E.ExamCode, E.ExamName, D.Value, A.ValueException
	FROM TB_ContractException A
	INNER JOIN TB_Contract B
		ON B.IdContract = A.IdContract
	INNER JOIN TB_TariffScheme C
		ON C.IdTariffScheme = B.IdTariffScheme
	INNER JOIN TR_TariffScheme_Service D
		ON D.IdTariffScheme = C.IdTariffScheme
			AND D.IdExam = A.IdExam
		--	AND ISNULL(D.IdService,0) = ISNULL(A.IdService,0)
	INNER JOIN TB_Exam E
		ON E.IdExam = A.IdExam
	INNER JOIN TB_TypeOfProcedure G
		ON G.IdTypeOfProcedure = D.IdTypeOfProcedure
	LEFT JOIN TB_Service F
		ON ISNULL(F.IdService,0) = ISNULL(A.IdService,0)
	WHERE A.IdContract = @IdContract
		AND A.Active = 'True'
		AND D.Active = 'True'

	UNION ALL

	SELECT DISTINCT A.IdContractException, A.IdContract, B.ContractName, B.IdCompany, D.IdTypeOfProcedure, G.TypeOfProcedure, NULL, NULL, A.IdExamGroup, E.ExamGroupCode, E.ExamGroupName, D.Value, A.ValueException
	FROM TB_ContractException A
	INNER JOIN TB_Contract B
		ON B.IdContract = A.IdContract
	INNER JOIN TB_TariffScheme C
		ON C.IdTariffScheme = B.IdTariffScheme
	INNER JOIN TR_TariffScheme_Service D
		ON D.IdTariffScheme = C.IdTariffScheme
			AND D.IdExamGroup = A.IdExamGroup
	INNER JOIN TB_ExamGroup E
		ON E.IdExamGroup = A.IdExamGroup
	INNER JOIN TB_TypeOfProcedure G
		ON G.IdTypeOfProcedure = D.IdTypeOfProcedure
	WHERE A.IdContract = @IdContract
		AND A.Active = 'True'
		AND D.Active = 'True'

END


GO
