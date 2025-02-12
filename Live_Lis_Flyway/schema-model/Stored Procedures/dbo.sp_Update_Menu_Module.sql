SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 25/04/2022
-- Description: Procedimiento almacenado para actualizar posición módulo o submódulo en el menú.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Menu_Module]
(
	@LevelChange bit,
	@IdMenu int = NULL,
	@ParentIdMenu int = NULL,
	@Level int = NULL,
	@Menu varchar(200),
	@OrderNumber varchar(200),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdModule int, @Order int, @Position int, @Position1 int
	DECLARE @TableMenu table (ParentIdMenu int, IdMenu int, OrderNumber int)
BEGIN
    SET NOCOUNT ON

	IF @LevelChange = 'False'
		BEGIN
			IF (@Menu != '' AND @OrderNumber != '')
				BEGIN
					SET @Menu = @Menu + ','
					SET @OrderNumber = @OrderNumber + ','

					WHILE PATINDEX('%,%', @Menu) <> 0 AND PATINDEX('%,%', @OrderNumber) <> 0
						BEGIN
							SELECT @Position = PATINDEX('%,%', @Menu)
							SELECT @Position1 = PATINDEX('%,%', @OrderNumber)

							SELECT @IdModule = LEFT(@Menu, @Position -1)
							SELECT @Order = LEFT(@OrderNumber, @Position1 -1)

							SET @IdModule = (SELECT IdMenu FROM TB_Menu WHERE IdMenu = @IdModule)

							INSERT INTO @TableMenu (ParentIdMenu, IdMenu, OrderNumber)
							VALUES (@ParentIdMenu, @IdModule, @Order)

							SELECT @Menu = STUFF(@Menu, 1, @Position, '')
							SELECT @OrderNumber = STUFF(@OrderNumber, 1, @Position1, '')
						END

					MERGE TB_Menu AS TARGET
					USING
						(SELECT ParentIdMenu, IdMenu, OrderNumber FROM @TableMenu) SOURCE
					ON TARGET.IdMenu = SOURCE.IdMenu
					--ON TARGET.ParentIdMenu = SOURCE.ParentIdMenu
					WHEN MATCHED
					THEN
						UPDATE
							SET TARGET.ParentIdMenu = SOURCE.ParentIdMenu,
								TARGET.OrderNumber = SOURCE.OrderNumber,
								TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
								TARGET.IdUserAction = @IdUserAction;
				END

				SET @Message = 'Successfully updated menu'
				SET @Flag = 1
		END
	ELSE IF @LevelChange = 'True'
		BEGIN
			IF NOT EXISTS (SELECT ParentIdMenu FROM TB_Menu WHERE ParentIdMenu = @IdMenu AND Active = 'True')
				BEGIN
					IF (SELECT MenuURL FROM TB_Menu WHERE IdMenu = @IdMenu) IS NULL
						BEGIN
							UPDATE TB_Menu
								SET ParentIdMenu = @ParentIdMenu,
									Level = @Level,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdMenu = @IdMenu

							IF (@Menu != '' AND @OrderNumber != '')
								BEGIN
									SET @Menu = @Menu + ','
									SET @OrderNumber = @OrderNumber + ','

									WHILE PATINDEX('%,%', @Menu) <> 0 AND PATINDEX('%,%', @OrderNumber) <> 0
										BEGIN
											SELECT @Position = PATINDEX('%,%', @Menu)
											SELECT @Position1 = PATINDEX('%,%', @OrderNumber)

											SELECT @IdModule = LEFT(@Menu, @Position -1)
											SELECT @Order = LEFT(@OrderNumber, @Position1 -1)

											SET @IdModule = (SELECT IdMenu FROM TB_Menu WHERE IdMenu = @IdModule AND Level = @Level)

											INSERT INTO @TableMenu (IdMenu, OrderNumber)
											VALUES (@IdModule, @Order)

											SELECT @Menu = STUFF(@Menu, 1, @Position, '')
											SELECT @OrderNumber = STUFF(@OrderNumber, 1, @Position1, '')
										END
									
									MERGE TB_Menu AS TARGET
									USING
										(SELECT IdMenu, OrderNumber FROM @TableMenu) SOURCE
									ON TARGET.IdMenu = SOURCE.IdMenu
									WHEN MATCHED
									THEN
										UPDATE
											SET TARGET.OrderNumber = SOURCE.OrderNumber,
												TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
												TARGET.IdUserAction = @IdUserAction;
								END

								SET @Message = 'Successfully updated menu'
								SET @Flag = 1							
						END
					ELSE
						BEGIN
							IF @Level > 1
								BEGIN
									UPDATE TB_Menu
										SET ParentIdMenu = @ParentIdMenu,
											Level = @Level,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction
									WHERE IdMenu = @IdMenu

									IF (@Menu != '' AND @OrderNumber != '')
										BEGIN
											SET @Menu = @Menu + ','
											SET @OrderNumber = @OrderNumber + ','

											WHILE PATINDEX('%,%', @Menu) <> 0 AND PATINDEX('%,%', @OrderNumber) <> 0
												BEGIN
													SELECT @Position = PATINDEX('%,%', @Menu)
													SELECT @Position1 = PATINDEX('%,%', @OrderNumber)

													SELECT @IdModule = LEFT(@Menu, @Position -1)
													SELECT @Order = LEFT(@OrderNumber, @Position1 -1)

													SET @IdModule = (SELECT IdMenu FROM TB_Menu WHERE IdMenu = @IdModule AND Level = @Level)

													INSERT INTO @TableMenu (IdMenu, OrderNumber)
													VALUES (@IdModule, @Order)

													SELECT @Menu = STUFF(@Menu, 1, @Position, '')
													SELECT @OrderNumber = STUFF(@OrderNumber, 1, @Position1, '')
												END
											
											MERGE TB_Menu AS TARGET
											USING
												(SELECT IdMenu, OrderNumber FROM @TableMenu) SOURCE
											ON TARGET.IdMenu = SOURCE.IdMenu
											WHEN MATCHED
											THEN
												UPDATE
													SET TARGET.OrderNumber = SOURCE.OrderNumber,
														TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
														TARGET.IdUserAction = @IdUserAction;
										END

									SET @Message = 'Successfully updated menu'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = CONCAT('Module ', @IdMenu, ' has associated menu URL')
									SET @Flag = 0
								END
					END
				END
			ELSE
				BEGIN
					SET @Message = CONCAT('Module ', @IdMenu, ' has associated submodules')
					SET @Flag = 0
				END
		END
END
GO
