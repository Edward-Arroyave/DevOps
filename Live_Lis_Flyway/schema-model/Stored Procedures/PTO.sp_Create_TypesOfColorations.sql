SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/06/2022
-- Description: Procedimiento almacenado para crear/actualizar tipo de coloracoión.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_TypesOfColorations]
(
	@IdTypesOfColorations int,
	@Description varchar(255),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdTypesOfColorations = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_TypesOfColorations WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_TypesOfColorations (Description, Active, CreationDate, IdUserAction)
					VALUES (@Description, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created type of colorations'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_TypesOfColorations WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_TypesOfColorations
								SET Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @Message = 'Successfully created type of colorations'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Type of colorations already exists'
							SET @Flag = 1
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_TypesOfColorations WHERE Description = @Description AND IdTypesOfColorations != @IdTypesOfColorations)
				BEGIN
					IF EXISTS (SELECT IdTypesOfColorations FROM PTO.TB_TypesOfColorations WHERE IdTypesOfColorations = @IdTypesOfColorations AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_TypesOfColorations
								SET Description = @Description,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdTypesOfColorations = @IdTypesOfColorations

							SET @Message = 'Successfully updated type of colorations'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_TypesOfColorations
								SET Description = @Description,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdTypesOfColorations = @IdTypesOfColorations

							SET @Message = 'Successfully updated type of colorations'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Type of colorations already exists'
					SET @Flag = 0
				END
		END
END
GO
