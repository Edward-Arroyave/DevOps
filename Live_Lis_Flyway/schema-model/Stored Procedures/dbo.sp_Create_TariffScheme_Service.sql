SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacenado para relacionar servicios a un esquema tarifario.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit 
--EXEC [sp_Create_TariffScheme_Service] 0,4,NULL,NULL,1,15000,80,4,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_TariffScheme_Service]
(
	@IdTariffSchemeService int,
	@IdTariffScheme int, 
	@IdTypeOfProcedure int,
	@IdService int = NULL, 
	@IdExam int = NULL,
	@IdExamGroup int = NULL,
	@Value bigint, 
	@Value_UVR bigint,
	@IdUserAction int,
	@Hiring Varchar (10) = NULL,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdTariffSchemeService = 0
		BEGIN
			IF NOT EXISTS (SELECT IdTariffSchemeService FROM TR_TariffScheme_Service WHERE IdTariffScheme = @IdTariffScheme AND ISNULL(IdService,0) = ISNULL(@IdService,0) AND ISNULL(IdExam,0) = ISNULL(@IdExam,0) AND ISNULL(IdExamGroup,0) = ISNULL(@IdExamGroup,0))
				BEGIN
					INSERT INTO TR_TariffScheme_Service (IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, Active, CreationDate, IdUserAction, Hiring)
					VALUES (@IdTariffScheme, @IdTypeOfProcedure, @IdService, @IdExam, @IdExamGroup, @Value, @Value_UVR,1 , DATEADD(HOUR,-5,GETDATE()), @IdUserAction, @Hiring)

					SET @Message = 'Successfully created tariff for service'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT IdTariffSchemeService FROM TR_TariffScheme_Service WHERE IdTariffScheme = @IdTariffScheme AND ISNULL(IdService,0) = ISNULL(@IdService,0) AND ISNULL(IdExam,0) = ISNULL(@IdExam,0) AND ISNULL(IdExamGroup,0) = ISNULL(@IdExamGroup,0) AND Active = 'False')
						BEGIN
							UPDATE TR_TariffScheme_Service
								SET Value = @Value,
									Value_UVR = @Value_UVR,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction,
									Hiring = @Hiring
							WHERE IdTariffScheme = @IdTariffScheme 
								AND ISNULL(IdService,0) = ISNULL(@IdService,0) 
								AND ISNULL(IdExam,0) = ISNULL(@IdExam,0) 
								AND ISNULL(IdExamGroup,0) = ISNULL(@IdExamGroup,0)

							SET @Message = 'Successfully created tariff for service'
							SET @Flag = 1
						END
					ELSE
						BEGIN	
							SET @Message = 'Service already has the tariff associated'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT IdTariffSchemeService FROM TR_TariffScheme_Service WHERE IdTariffScheme = @IdTariffScheme AND ISNULL(IdService,0) = ISNULL(@IdService,0) AND ISNULL(IdExam,0) = ISNULL(@IdExam,0) AND ISNULL(IdExamGroup,0) = ISNULL(@IdExamGroup,0) AND Active = 'False' AND IdTariffSchemeService != @IdTariffSchemeService)
				BEGIN
					UPDATE TR_TariffScheme_Service
						SET IdTypeOfProcedure = @IdTypeOfProcedure,
							IdTariffScheme = @IdTariffScheme,
							IdExam = @IdExam,
							IdService = @IdService,
							IdExamGroup = @IdExamGroup,
							Value = @Value,
							Value_UVR = @Value_UVR,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction,
							Hiring = @Hiring
					WHERE IdTariffSchemeService = @IdTariffSchemeService

					SET @Message = 'Successfully updated tariff for service'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service already has the tariff associated'
					SET @Flag = 0
				END
		END
END
GO
