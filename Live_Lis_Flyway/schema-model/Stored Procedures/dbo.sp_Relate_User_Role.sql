SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para relacionar o actualizar roles a un usuario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Relate_User_Role]
(
	@IdUser int,
	@Role varchar(20),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdRole int, @Position int
	DECLARE @TableRole table (IdUser_Role int identity, IdUser int, IdRole int)
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdUser FROM TB_User WHERE IdUser = @IdUser)
		BEGIN
			IF NOT EXISTS (SELECT IdUser FROM TR_User_Role WHERE IdUser = @IdUser)
				BEGIN
					IF (@Role != '')
						BEGIN
							SET @Role = @Role + ','

							WHILE PATINDEX('%,%', @Role) <> 0
								BEGIN	
									SELECT @Position = PATINDEX('%,%', @Role)

									SELECT @IdRole = LEFT(@Role, @Position -1)

									SET @IdRole = (SELECT IdRole FROM TB_Role WHERE IdRole = @IdRole)

									INSERT INTO TR_User_Role (IdUser, IdRole, CreationDate, IdUserAction, Active)
									VALUES (@IdUser, @IdRole, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)

									SELECT @Role = STUFF(@Role, 1, @Position,'')
								END
						END

						SELECT CONCAT_WS(' ', Name, LastName) FullName, Email, UserName, IdentificationNumber FROM TB_User WHERE IdUser = @IdUser


						SET @Message = 'User successfully related to the role'
						SET @Flag = 1
				END
			ELSE
				BEGIN
					IF (@Role != '')
						BEGIN
							SET @Role = @Role + ','

							WHILE PATINDEX ('%,%', @Role) <> 0
								BEGIN
									SELECT @Position = PATINDEX('%,%', @Role)

									SELECT @IdRole = LEFT(@Role, @Position -1)

									SET @IdRole = (SELECT IdRole FROM TB_Role WHERE IdRole = @IdRole)
										
									BEGIN
										INSERT INTO @TableRole (IdUser, IdRole)
										(SELECT DISTINCT IdUser, @IdRole FROM TR_User_Role /*WHERE IdUser = @IdUser*/)
									END

									SELECT @Role = STUFF(@Role, 1, @Position, '') 
								END
							
							MERGE TR_User_Role AS TARGET
							USING
								(SELECT IdUser_Role, IdUser, IdRole FROM @TableRole) SOURCE
									ON TARGET.IdRole = SOURCE.IdRole
										AND TARGET.IdUser = SOURCE.IdUser
							WHEN NOT MATCHED BY TARGET
							THEN
								INSERT (IdUser, IdRole, CreationDate, IdUserAction, Active)
								VALUES
									(
									SOURCE.IdUser,
									SOURCE.IdRole,
									DATEADD(HOUR,-5,GETDATE()),
									@IdUserAction,
									1
									)
							WHEN NOT MATCHED BY SOURCE AND TARGET.IdUser = @IdUser AND TARGET.Active = 1
								THEN
									UPDATE
										SET TARGET.Active = 0,
											TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											TARGET.IdUserAction = @IdUserAction
							WHEN MATCHED AND TARGET.Active = 0
								THEN
									UPDATE
										SET TARGET.Active = 1,
											TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											TARGET.IdUserAction = @IdUserAction;
						END

					SET @Message = 'User related role were updated successsfully'
					SET @Flag = 1
				END
		END
	ELSE
		BEGIN
			SET @Message = 'User does not exists'
			SET @Flag = 0
		END
END
GO
