SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/09/2021
-- Description: Procedimiento almacenado para crear roles
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Role]
(	
	@Id int,
	@RoleName varchar(100),    
	@IdProfile tinyint,
	@Active bit,
	@IdUserAction int,
	@Informative bit,
	@IdRole tinyint out,
	@Message varchar(50) out,
	@Flag bit out

/*

DECLARE @idrole int , @Message varchar(50), @Flag bit  
exec [dbo].[sp_Create_Role] 69,'aaaa',3,1,1020, @idrole, @Message , @Flag   
SELECT @idrole int, @Message, @Flag
*/
)
AS
BEGIN

    SET NOCOUNT ON

	IF @Id = 0 AND @IdProfile<>3
		BEGIN
			IF NOT EXISTS(SELECT upper(RoleName) FROM TB_Role WHERE RoleName = upper(@RoleName))
				BEGIN
					INSERT INTO TB_Role(RoleName, IdUserAction, Active, IdProfile, CreationDate, Informative) 
					VALUES (@RoleName, @IdUserAction, 1, @IdProfile, DATEADD(HOUR,-5,GETDATE()), @Informative)

					SET @IdRole = IDENT_CURRENT('TB_Role')
					SET @Message = 'Successfully inserted role'
					SET @Flag = 1

					INSERT INTO TR_Role_Profile (idRole,	RoleName,	IdProfile,	Active,	CreationDate,	UpdateDate,	IdUserAction)
					VALUES (@IdRole, @RoleName, @IdProfile, 1, DATEADD(HOUR,-5,GETDATE()),NULL , @IdUserAction)

				END
			ELSE
				BEGIN
					SET @Message = 'Role already exists'
					SET @Flag = 0
				END
		END
	ELSE IF @Id <> 0 AND @IdProfile<>3
		BEGIN
			IF NOT EXISTS (SELECT upper(RoleName) FROM TB_Role WHERE RoleName = upper(@RoleName) AND IdRole != @Id and @IdProfile<>3)
				BEGIN
					UPDATE TB_Role
						SET RoleName = @RoleName,
							Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							Informative = @Informative
					WHERE IdRole = @Id

					UPDATE TR_ROLE_PROFILE SET RoleName=@RoleName, Active = @Active, IdUserAction=@IdUserAction, UpdateDate=DATEADD(HOUR,-5,GETDATE()) where IdRole=@Id

					SET @Message = 'Successfully updated role'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Role already exists'
					SET @Flag = 0
				END
		END
		
	IF @IdProfile = 3
		BEGIN
			IF  @Id = 0
				BEGIN
					IF NOT EXISTS(SELECT upper(RoleName) FROM TB_Role WHERE RoleName = upper(@RoleName))
						BEGIN
							INSERT INTO TB_Role(RoleName, IdUserAction, Active, IdProfile, CreationDate, Informative) 
							VALUES (@RoleName, @IdUserAction, 1, @IdProfile, DATEADD(HOUR,-5,GETDATE()), @Informative)

							SET @IdRole = IDENT_CURRENT('TB_Role')
							SET @Message = 'Successfully inserted role'
							SET @Flag = 1

							INSERT INTO TR_Role_Profile (idRole,	RoleName,	IdProfile,	Active,	CreationDate,	UpdateDate,	IdUserAction)
							VALUES (@IdRole, @RoleName, @IdProfile, 1, DATEADD(HOUR,-5,GETDATE()),  NULL, @IdUserAction)--,
									--(@IdRole, @RoleName, 2, 1, DATEADD(HOUR,-5,GETDATE()),  NULL, @IdUserAction)
						END
					ELSE
					BEGIN
						SET @Message = 'Role already exists'
						SET @Flag = 0
					END
				END
			ELSE IF (SELECT IdProfile FROM TB_Role WHERE IdRole = @Id) = 1 
				BEGIN
					IF (SELECT count(*) FROM TR_Role_Profile WHERE IdRole = @Id)=1
						BEGIN
							INSERT INTO TR_Role_Profile (idRole,	RoleName,	IdProfile,	Active,	CreationDate,	UpdateDate,	IdUserAction)
							VALUES (@Id, @RoleName, @IdProfile, 1, DATEADD(HOUR,-5,GETDATE()),  NULL, @IdUserAction)

							UPDATE TB_Role
								SET RoleName = @RoleName,
									Active = @Active,
									IdUserAction = @IdUserAction,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									Informative = @Informative
							WHERE IdRole = @Id

							UPDATE TR_ROLE_PROFILE SET RoleName=@RoleName, Active = @Active, IdUserAction=@IdUserAction, UpdateDate=DATEADD(HOUR,-5,GETDATE()) where IdRole=@Id

							SET @Message = 'Successfully updated role'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							UPDATE TB_Role
								SET RoleName = @RoleName,
									Active = @Active,
									IdUserAction = @IdUserAction,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									Informative = @Informative
							WHERE IdRole = @Id

							UPDATE TR_ROLE_PROFILE SET RoleName=@RoleName, Active = @Active, IdUserAction=@IdUserAction, UpdateDate=DATEADD(HOUR,-5,GETDATE()) where IdRole=@Id

							SET @Message = 'Successfully updated role'
							SET @Flag = 1
						END

				END
				ELSE
					BEGIN
						IF (SELECT count(*) FROM TR_Role_Profile WHERE IdRole = @Id)=1
							BEGIN
								INSERT INTO TR_Role_Profile (idRole,	RoleName,	IdProfile,	Active,	CreationDate,	UpdateDate,	IdUserAction)
								VALUES (@Id, @RoleName, @IdProfile, 1, DATEADD(HOUR,-5,GETDATE()),  NULL, @IdUserAction)

								UPDATE TB_Role
									SET RoleName = @RoleName,
										Active = @Active,
										IdUserAction = @IdUserAction,
										UpdateDate = DATEADD(HOUR,-5,GETDATE()),
										Informative = @Informative
								WHERE IdRole = @Id
					
								UPDATE TR_ROLE_PROFILE SET RoleName=@RoleName, Active = @Active, IdUserAction=@IdUserAction, UpdateDate=DATEADD(HOUR,-5,GETDATE()) where IdRole=@Id

								SET @Message = 'Successfully updated role'
								SET @Flag = 1
							END
						ELSE
							BEGIN
								UPDATE TB_Role
									SET RoleName = @RoleName,
										Active = @Active,
										IdUserAction = @IdUserAction,
										UpdateDate = DATEADD(HOUR,-5,GETDATE()),
										Informative = @Informative
								WHERE IdRole = @Id
					
								UPDATE TR_ROLE_PROFILE SET RoleName=@RoleName, Active = @Active, IdUserAction=@IdUserAction, UpdateDate=DATEADD(HOUR,-5,GETDATE()) where IdRole=@Id

								SET @Message = 'Successfully updated role'
								SET @Flag = 1
							END
					END
				END
	END
GO
