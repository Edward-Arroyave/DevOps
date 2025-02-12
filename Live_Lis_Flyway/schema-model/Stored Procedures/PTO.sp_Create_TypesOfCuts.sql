SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/06/2022
-- Description: Procedimiento almacenado para crear/actualizar tipo de cortes.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_TypesOfCuts]
(
	@IdTypesOfCuts int,
	@Description varchar(255),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdTypesOfCuts = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_TypesOfCuts WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_TypesOfCuts (Description, Active, CreationDate, IdUserAction)
					VALUES (@Description, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created type of cuts'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_TypesOfCuts WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_TypesOfCuts
								SET Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @Message = 'Successfully created type of cuts'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Type of cuts already exists'
							SET @Flag = 1
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_TypesOfCuts WHERE Description = @Description AND IdTypesOfCuts != @IdTypesOfCuts)
				BEGIN
					IF EXISTS (SELECT IdTypesOfCuts FROM PTO.TB_TypesOfCuts WHERE IdTypesOfCuts = @IdTypesOfCuts AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_TypesOfCuts
								SET Description = @Description,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdTypesOfCuts = @IdTypesOfCuts

							SET @Message = 'Successfully updated type of cuts'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_TypesOfCuts
								SET Description = @Description,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdTypesOfCuts = @IdTypesOfCuts

							SET @Message = 'Successfully updated type of cuts'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Type of cuts already exists'
					SET @Flag = 0
				END
		END
END
GO
