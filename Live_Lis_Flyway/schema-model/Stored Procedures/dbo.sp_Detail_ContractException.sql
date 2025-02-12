SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 18/01/2023
-- Description: Procedimiento almacenado para retornar detalle de excepciones a examen de un contrato.
-- =============================================
-- EXEC [sp_Detail_ContractException] 185
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_ContractException]
(
	@IdContractException int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdContractException, A.IdContract, D.IdTypeOfProcedure, G.TypeOfProcedure, A.IdService, A.IdExam, E.ExamCode, E.ExamName, D.Value, A.ValueException
	FROM TB_ContractException A
	INNER JOIN TB_Contract B
		ON B.IdContract = A.IdContract
	INNER JOIN TB_TariffScheme C
		ON C.IdTariffScheme = B.IdTariffScheme
	INNER JOIN TR_TariffScheme_Service D
		ON D.IdTariffScheme = C.IdTariffScheme
	INNER JOIN TB_TypeOfProcedure G
		ON G.IdTypeOfProcedure = D.IdTypeOfProcedure
	INNER JOIN TB_Exam E
		ON ISNULL(E.IdExam,0) = ISNULL(D.IdExam,0)
			AND ISNULL(E.IdExam,0) = ISNULL(A.IdExam,0)
	LEFT JOIN TB_Service F
		ON ISNULL(F.IdService,0) = ISNULL(D.IdService,0)
			AND ISNULL(F.IdService,0) = ISNULL(A.IdService,0)
	WHERE A.IdContractException = @IdContractException

	UNION ALL

	SELECT A.IdContractException, A.IdContract, D.IdTypeOfProcedure, G.TypeOfProcedure, NULL, A.IdExamGroup, E.ExamGroupCode, E.ExamGroupName, D.Value, A.ValueException
	FROM TB_ContractException A
	INNER JOIN TB_Contract B
		ON B.IdContract = A.IdContract
	INNER JOIN TB_TariffScheme C
		ON C.IdTariffScheme = B.IdTariffScheme
	INNER JOIN TR_TariffScheme_Service D
		ON D.IdTariffScheme = C.IdTariffScheme
	INNER JOIN TB_ExamGroup E
		ON ISNULL(E.IdExamGroup,0) = ISNULL(D.IdExamGroup,0)
			AND ISNULL(E.IdExamGroup,0) = ISNULL(A.IdExamGroup ,0)
	INNER JOIN TB_TypeOfProcedure G
		ON G.IdTypeOfProcedure = D.IdTypeOfProcedure
	WHERE A.IdContractException = @IdContractException
END
GO
