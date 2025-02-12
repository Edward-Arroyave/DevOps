SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2022
-- Description: Procedimiento almacenado para almacenar foto/firma de usuarios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_User_Photo_Signature]
(
	@IdUser int,
	@Photo bit,
	@PhotoCode varchar(25),
	@PhotoName varchar(100),
	@Signature bit,
	@SignatureCode varchar(25),
	@SignatureName varchar(100),
	@IdUserAction int, 
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @Photo = 'True'
		BEGIN
			IF NOT EXISTS (SELECT IdUser FROM TB_UserPhoto WHERE IdUser = @IdUser)
				BEGIN
					INSERT INTO TB_UserPhoto (PhotoCode, PhotoName, IdUser, CreationDate, IdUserAction)
					VALUES (@PhotoCode, @PhotoName, @IdUser, DATEADD(HOUR,-5,GETDATE()),@IdUserAction)

					SET @Message = 'Successfully created user photo'
					SET @Flag = 1
				END
			ELSE	
				BEGIN
					UPDATE TB_UserPhoto
						SET PhotoCode = @PhotoCode,
							PhotoName = @PhotoName,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdUser = @IdUser

					SET @Message = 'Successfully updated user photo'
					SET @Flag = 1
				END
		END

	IF @Signature = 'True'
		BEGIN
			IF NOT EXISTS (SELECT IdUser FROM TB_UserSignature WHERE IdUser = @IdUser)
				BEGIN
					INSERT INTO TB_UserSignature(SignatureCode, SignatureName, IdUser, CreationDate, IdUserAction)
					VALUES (@SignatureCode, @SignatureName, @IdUser, DATEADD(HOUR,-5,GETDATE()),@IdUserAction)

					SET @Message = 'Successfully created user signature'
					SET @Flag = 1
				END
			ELSE	
				BEGIN
					UPDATE TB_UserSignature
						SET SignatureCode = @SignatureCode,
							SignatureName = @SignatureName,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdUser = @IdUser

					SET @Message = 'Successfully updated user signature'
					SET @Flag = 1
				END
		END
END
GO
