SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para crear/actualizar medio de fijación.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_FixingMedium]
(
	@IdFixingMedium int,
	@Description varchar(255),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdFixingMedium = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_FixingMedium WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_FixingMedium(Description, Active, CreationDate, IdUserAction)
					VALUES (@Description, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created fixing medium'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_FixingMedium WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_FixingMedium
								SET Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @Message = 'Successfully created fixing medium'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Fixing medium already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_FixingMedium WHERE Description = @Description AND IdFixingMedium != @IdFixingMedium)
				BEGIN
					IF EXISTS (SELECT IdFixingMedium FROM PTO.TB_FixingMedium WHERE IdFixingMedium = @IdFixingMedium AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_FixingMedium
								SET Description = @Description,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdFixingMedium = @IdFixingMedium

							SET @Message = 'Successfully updated fixing medium'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_FixingMedium
								SET Description = @Description,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdFixingMedium = @IdFixingMedium

							SET @Message = 'Successfully updated fixing medium'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Fixing medium already exists'
					SET @Flag = 0
				END
		END
END
GO
