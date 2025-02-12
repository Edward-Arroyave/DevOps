SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para crear/actualizar parte del cuerpo
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_BodyPart]
(
	@IdBodyPart int,
	@Description varchar(255),
	@BlockQuantity int,
	@IdUserAction int,
	@IdBodyPart_Out int out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdBodyPart = 0
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_BodyPart WHERE Description = @Description)
				BEGIN
					INSERT INTO PTO.TB_BodyPart (Description, BlockQuantity, Active, CreationDate, IdUserAction)
					VALUES (@Description, @BlockQuantity, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @IdBodyPart_Out = IDENT_CURRENT('PTO.TB_BodyPart')
					SET @Message = 'Successfully created body part'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT Description FROM PTO.TB_BodyPart WHERE Description = @Description AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_BodyPart
								SET Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE Description = @Description

							SET @IdBodyPart_Out = (SELECT Description FROM PTO.TB_BodyPart WHERE Description = @Description)
							SET @Message = 'Successfully created body part'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Body part already exists'
							SET @Flag = 1
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Description FROM PTO.TB_BodyPart WHERE Description = @Description AND IdBodyPart != @IdBodyPart)
				BEGIN
					IF EXISTS (SELECT IdBodyPart FROM PTO.TB_BodyPart WHERE IdBodyPart = @IdBodyPart AND Active = 'False')
						BEGIN
							UPDATE PTO.TB_BodyPart
								SET Description = @Description,
									BlockQuantity = @BlockQuantity,
									Active = 'True',
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdBodyPart = @IdBodyPart

							SET @IdBodyPart_Out = @IdBodyPart
							SET @Message = 'Successfully updated body part'
							SET @Flag = 1
						END
					ELSE	
						BEGIN
							UPDATE PTO.TB_BodyPart
								SET Description = @Description,
									BlockQuantity = @BlockQuantity,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdBodyPart = @IdBodyPart

							SET @IdBodyPart_Out = @IdBodyPart
							SET @Message = 'Successfully updated body part'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Body part already exists'
					SET @Flag = 0
				END
		END
END
GO
