SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/05/2023
-- Description: Procedimiento almacenado para actuallizar valores de esquemas tarifarios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_TariffService]
AS
BEGIN
    SET NOCOUNT ON

	UPDATE A
		SET Value = B.Value,
			Value_UVR = B.Value_UVR,
			InitialVigenceDate = B.InitialVigenceDate,
			UpdateDate = DATEADD(HOUR,-5,GETDATE()),
			IdUserAction = B.IdUserAction
	FROM TR_TariffScheme_Service A
	INNER JOIN TB_TariffServiceChange B
		ON B.IdTariffScheme = A.IdTariffScheme
			AND ISNULL(B.IdService,0) = ISNULL(A.IdService,0)
			AND ISNULL(B.IdExam,0) = ISNULL(A.IdExam,0)
			AND ISNULL(B.IdExamGroup,0) = ISNULL(A.IdExamGroup,0)
	WHERE B.InitialVigenceDate = CONVERT(DATE,DATEADD(HOUR,-5,GETDATE()))

	UPDATE A
		SET IdTariffScheme = B.IdTariffScheme,
			InitialValidityTariffServDate = B.InitialValidityTariffServDate
	FROM TB_Contract A
	INNER JOIN TB_ContractTariffScheme B
		ON B.IdContract = A.IdContract
	WHERE B.InitialValidityTariffServDate = CONVERT(DATE,DATEADD(HOUR,-5,GETDATE()))
END
GO
