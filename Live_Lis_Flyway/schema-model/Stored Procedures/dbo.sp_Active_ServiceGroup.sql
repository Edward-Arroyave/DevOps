SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/05/2022
-- Description: Procedimiento almacenado para activar o inactivar grupos de servicios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_ServiceGroup]
(
    @ServiceGroupLevel int,
	@IdServiceGroup int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @ServiceGroupLevel = 1
		BEGIN
			IF EXISTS (SELECT IdServiceGroup FROM TB_ServiceGroup WHERE IdServiceGroup = @IdServiceGroup)
				BEGIN
					UPDATE TB_ServiceGroup
						SET Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = DATEADD(HOUR,-5,GETDATE())
					WHERE IdServiceGroup = @IdServiceGroup

					-- Inactivar grupo de servicios nivel 2 relacionados
					IF @Active = 'False'
						BEGIN
							UPDATE TB_ServiceGroupLevel2
								SET Active = 'False',
									IdUserAction = @IdUserAction,
									UpdateDate = DATEADD(HOUR,-5,GETDATE())
							WHERE IdServiceGroup = @IdServiceGroup

							-- Inactivar grupo de servicios nivel 3 relacionados
							UPDATE B
								SET B.Active = 'False',
									IdUserAction = @IdUserAction,
									UpdateDate = DATEADD(HOUR,-5,GETDATE())
							FROM TB_ServiceGroupLevel2 A
							INNER JOIN TB_ServiceGroupLevel3 B
								ON B.IdServiceGroupLevel2 = A.IdServiceGroupLevel2
							WHERE A.IdServiceGroup = @IdServiceGroup
						END

					SET @Message = 'Successfully updated service group'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service group not found'
					SET @Flag = 0
				END
		END
	ELSE IF @ServiceGroupLevel = 2
		BEGIN
			IF EXISTS (SELECT IdServiceGroupLevel2 FROM TB_ServiceGroupLevel2 WHERE IdServiceGroupLevel2 = @IdServiceGroup)
				BEGIN
					UPDATE TB_ServiceGroupLevel2
						SET Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = DATEADD(HOUR,-5,GETDATE())
					WHERE IdServiceGroupLevel2 = @IdServiceGroup

					-- Inactivar grupo de servicios nivel 3 relacionados
					IF @Active = 'False'
						BEGIN
							UPDATE TB_ServiceGroupLevel3
								SET Active = 'False',
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdServiceGroupLevel2 = @IdServiceGroup
						END
					-- Activar grupo de servicio nivel 1 relacionado
					ELSE IF @Active = 'True'
						BEGIN
							UPDATE B
								SET Active = 'True',
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							FROM TB_ServiceGroupLevel2 A
							INNER JOIN TB_ServiceGroup B
								ON B.IdServiceGroup = A.IdServiceGroup
							WHERE A.IdServiceGroupLevel2 = @IdServiceGroup
						END

					SET @Message = 'Successfully updated service group level 2'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Service group level 2 not found'
					SET @Flag = 0
				END
		END
	ELSE IF @ServiceGroupLevel = 3
		BEGIN
			IF EXISTS (SELECT IdServiceGroupLevel3 FROM TB_ServiceGroupLevel3 WHERE IdServiceGroupLevel3 = @IdServiceGroup)
				BEGIN
					UPDATE TB_ServiceGroupLevel3
						SET Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = DATEADD(HOUR,-5,GETDATE())
					WHERE IdServiceGroupLevel3 = @IdServiceGroup

					-- Activar grupo de servicio nivel 2 relacionado
					IF @Active = 'True'
						BEGIN
							UPDATE B
								SET Active = 'True',
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							FROM TB_ServiceGroupLevel3 A
							INNER JOIN TB_ServiceGroupLevel2 B
								ON B.IdServiceGroupLevel2 = A.IdServiceGroupLevel2
							WHERE A.IdServiceGroupLevel3 = @IdServiceGroup

							UPDATE C
								SET Active = 'True',
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							FROM TB_ServiceGroupLevel3 A
							INNER JOIN TB_ServiceGroupLevel2 B
								ON B.IdServiceGroupLevel2 = A.IdServiceGroupLevel2
							INNER JOIN TB_ServiceGroup C
								ON C.IdServiceGroup = B.IdServiceGroup
							WHERE A.IdServiceGroupLevel3 = @IdServiceGroup
						END

					SET @Message = 'Successfully updated service group level 3'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Serive group level 3 not found'
					SET @Flag = 0
				END
		END
END
GO
