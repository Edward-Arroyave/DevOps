SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacenado para retornar información de servicio de esquema tarifario.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Detail_TariffScheme_Service] 45, @Message out, @Flag out
--SELECT @Message, @Flag 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_TariffScheme_Service]
(
	@IdTariffSchemeService int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdProcedureType int
BEGIN
    SET NOCOUNT ON

	SET @IdProcedureType = (SELECT DISTINCT IdTypeOfProcedure FROM TR_TariffScheme_Service WHERE IdTariffSchemeService = @IdTariffSchemeService)

	IF EXISTS (SELECT IdTariffSchemeService FROM TR_TariffScheme_Service WHERE IdTariffSchemeService = @IdTariffSchemeService)
		BEGIN
			IF @IdProcedureType = 1
				BEGIN
					SELECT A.IdTariffSchemeService, A.IdTariffScheme, A.IdTypeOfProcedure, B.IdServiceType, A.IdService, A.IdExam, A.Value, A.Value_UVR, A.Hiring
					FROM TR_TariffScheme_Service A
					LEFT JOIN TB_Service B
						ON B.IdService = A.IdService
					LEFT JOIN TB_Exam C
						ON C.IdExam = A.IdExam
					WHERE A.IdTariffSchemeService = @IdTariffSchemeService
				END
			ELSE
				BEGIN
					SELECT A.IdTariffSchemeService, A.IdTariffScheme, A.IdTypeOfProcedure, A.IdExamGroup, A.Value, A.Value_UVR, A.Hiring
					FROM TR_TariffScheme_Service A
					INNER JOIN TB_ExamGroup B
						ON B.IdExamGroup = A.IdExamGroup 
					WHERE A.IdTariffSchemeService = @IdTariffSchemeService
				END
	
			SET @Message = 'Tariff scheme service found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Tariff scheme service does not exists'
			SET @Flag = 0
		END
END
GO
