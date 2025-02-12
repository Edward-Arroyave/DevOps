SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 29/03/2022
-- Description: Procedimiento almacenado para crear un módulo o submódulo en el menú.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Create_Menu_Module] 1,'Administración','administracion',NULL,NULL,30,1,1,44,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Menu_Module]
(
	@IdMenu int,
	@MenuName varchar(50),
	@DescriptionMenu varchar(255),
	@ParentIdMenu int = NULL,
	--@OrderNumber int,
	@MenuURL varchar(100) = NULL,
	@IdMenuIcon int = NULL,
	@Level int,
	@IdProfile int,
	@IdUserAction int,
	@PaymentMethod bit = null,
	@Message varchar(50) out,
	@Flag bit out

)
AS
	DECLARE @IdModule int, @OrderNumber int = 1
BEGIN
    SET NOCOUNT ON

	SET @OrderNumber = @OrderNumber + (SELECT COUNT(IdMenu) FROM TB_Menu WHERE Level = 1 AND Active = 1)

	IF @IdMenu = 0
		BEGIN
			IF NOT EXISTS (SELECT MenuName FROM TB_Menu WHERE MenuName = @MenuName)
				BEGIN
					INSERT INTO TB_Menu (MenuName, DescriptionMenu, ParentIdMenu, OrderNumber, MenuURL, IdMenuIcon, Level, 
										IdProfile, Status, Active, CreationDate, IdUserAction, PaymentMethod)
					VALUES (@MenuName, @DescriptionMenu, @ParentIdMenu, @OrderNumber, @MenuURL, @IdMenuIcon, @Level, 
							@IdProfile, 1, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction,  @PaymentMethod)

					SET @Message = 'Successfully created menu module'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT MenuName FROM TB_Menu WHERE MenuName = @MenuName AND Active = 'False')
						BEGIN
							IF ISNULL(@ParentIdMenu,0) != @IdMenu
								BEGIN
									SET @IdModule = (SELECT IdMenu FROM TB_Menu WHERE MenuName = @MenuName AND Active = 'False')

									UPDATE TB_Menu
										SET DescriptionMenu = @DescriptionMenu,
											ParentIdMenu = @ParentIdMenu, 
											OrderNumber = @OrderNumber,
											MenuURL = @MenuURL,
											IdMenuIcon = @IdMenuIcon,
											Level = @Level, 
											IdProfile = @IdProfile,
											Status = 1,
											Active = 1,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction,
											PaymentMethod = @PaymentMethod
									WHERE IdMenu = @IdModule

									SET @Message = 'Successfully created menu module'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'ParentIdMenu not valid'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Menu module already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT MenuName FROM TB_Menu WHERE MenuName = @MenuName AND IdMenu != @IdMenu)
				BEGIN
					IF ISNULL(@ParentIdMenu,0) != @IdMenu
						BEGIN
							IF @Level = 1
								BEGIN
									IF (SELECT MenuURL FROM TB_Menu WHERE IdMenu = @IdMenu) IS NULL AND @MenuURL IS NULL
										BEGIN
											UPDATE TB_Menu
												SET MenuName = @MenuName,
													DescriptionMenu = @DescriptionMenu,
													ParentIdMenu = @ParentIdMenu,
													--OrderNumber = @OrderNumber, 
													MenuURL = @MenuURL,
													IdMenuIcon = @IdMenuIcon,
													Level = @Level,
													IdProfile = @IdProfile,
													UpdateDate = DATEADD(HOUR,-5,GETDATE()),
													IdUserAction = @IdUserAction,
													PaymentMethod = @PaymentMethod
											WHERE IdMenu = @IdMenu

											SET @Message = 'Successfully updated menu module'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											IF @MenuURL IS NULL
												BEGIN
													UPDATE TB_Menu
														SET MenuName = @MenuName,
															DescriptionMenu = @DescriptionMenu,
															ParentIdMenu = @ParentIdMenu,
															--OrderNumber = @OrderNumber, 
															MenuURL = @MenuURL,
															IdMenuIcon = @IdMenuIcon,
															Level = @Level,
															IdProfile = @IdProfile,
															UpdateDate = DATEADD(HOUR,-5,GETDATE()),
															IdUserAction = @IdUserAction,
															PaymentMethod = @PaymentMethod
													WHERE IdMenu = @IdMenu

													SET @Message = 'Successfully updated menu module'
													SET @Flag = 1
												END
											ELSE
												BEGIN
													SET @Message = CONCAT('Module ', @IdMenu,' has route assigned')
													SET @Flag = 0
												END
										END
								END
							ELSE
								BEGIN
									UPDATE TB_Menu
										SET MenuName = @MenuName,
											DescriptionMenu = @DescriptionMenu,
											ParentIdMenu = @ParentIdMenu,
											--OrderNumber = @OrderNumber, 
											MenuURL = @MenuURL,
											IdMenuIcon = @IdMenuIcon,
											Level = @Level,
											IdProfile = @IdProfile,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction,
											PaymentMethod = @PaymentMethod
									WHERE IdMenu = @IdMenu

									SET @Message = 'Successfully updated menu module'
									SET @Flag = 1
								END
						END
					ELSE
						BEGIN
							SET @Message = 'ParentIdMenu not valid'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT MenuName FROM TB_Menu WHERE MenuName = @MenuName AND IdMenu != @IdMenu AND Active = 'False')
						BEGIN
							IF @IdMenu != ISNULL(@ParentIdMenu,0)
								BEGIN
									IF @Level = 1
										BEGIN
											IF (SELECT MenuURL FROM TB_Menu WHERE IdMenu = @IdMenu) IS NULL AND @MenuURL IS NULL
												BEGIN
													UPDATE TB_Menu
														SET MenuName = @MenuName,
															DescriptionMenu = @DescriptionMenu,
															ParentIdMenu = @ParentIdMenu,
															--OrderNumber = @OrderNumber, 
															MenuURL = @MenuURL,
															IdMenuIcon = @IdMenuIcon,
															Level = @Level,
															IdProfile = @IdProfile,
															UpdateDate = DATEADD(HOUR,-5,GETDATE()),
															IdUserAction = @IdUserAction,
															PaymentMethod = @PaymentMethod
													WHERE IdMenu = @IdMenu

													SET @Message = 'Successfully updated menu module'
													SET @Flag = 1
												END
											ELSE
												BEGIN
													IF @MenuURL IS NULL
														BEGIN
															UPDATE TB_Menu
																SET MenuName = @MenuName,
																	DescriptionMenu = @DescriptionMenu,
																	ParentIdMenu = @ParentIdMenu,
																	--OrderNumber = @OrderNumber, 
																	MenuURL = @MenuURL,
																	IdMenuIcon = @IdMenuIcon,
																	Level = @Level,
																	IdProfile = @IdProfile,
																	UpdateDate = DATEADD(HOUR,-5,GETDATE()),
																	IdUserAction = @IdUserAction,
																	PaymentMethod = @PaymentMethod
															WHERE IdMenu = @IdMenu

															SET @Message = 'Successfully updated menu module'
															SET @Flag = 1
														END
													ELSE
														BEGIN
															SET @Message = CONCAT('Module ', @IdMenu,' has route assigned')
															SET @Flag = 0
														END
												END
										END
									ELSE
										BEGIN
											UPDATE TB_Menu
												SET MenuName = @MenuName,
													DescriptionMenu = @DescriptionMenu,
													ParentIdMenu = @ParentIdMenu,
													--OrderNumber = @OrderNumber, 
													MenuURL = @MenuURL,
													IdMenuIcon = @IdMenuIcon,
													Level = @Level,
													IdProfile = @IdProfile,
													UpdateDate = DATEADD(HOUR,-5,GETDATE()),
													IdUserAction = @IdUserAction,
													PaymentMethod = @PaymentMethod
											WHERE IdMenu = @IdMenu

											SET @Message = 'Successfully updated menu module'
											SET @Flag = 1
										END
								END
							ELSE
								BEGIN
									SET @Message = 'ParentIdMenu not valid'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN						
							SET @Message = 'Menu module already exists'
							SET @Flag = 0
						END
				END
		END
END
GO
