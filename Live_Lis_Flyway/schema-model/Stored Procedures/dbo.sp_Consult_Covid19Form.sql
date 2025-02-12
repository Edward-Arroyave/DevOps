SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/10/2022
-- Description: Procedimiento almacenado para consultar cuestionarios de salud de Covid 19.
-- =============================================
-- EXEC [sp_Consult_Covid19Form] 140
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Covid19Form]
(
	@IdPatient int
)
AS
	DECLARE @IdCovid19FormType int
BEGIN
    SET NOCOUNT ON

	SET @IdCovid19FormType = (SELECT IdCovid19FormType FROM TB_Covid19Form WHERE IdPatient = @IdPatient)

	IF @IdCovid19FormType = 1
		BEGIN
			SELECT *
			FROM TB_Covid19Form
			WHERE IdPatient = @IdPatient
		END
	ELSE IF @IdCovid19FormType = 2
		BEGIN
			SELECT *
			FROM TB_Covid19Form
			WHERE IdPatient = @IdPatient
		END
	ELSE IF @IdCovid19FormType = 3
		BEGIN
			SELECT *
			FROM TB_Covid19Form
			WHERE IdPatient = @IdPatient
		END
END
GO
