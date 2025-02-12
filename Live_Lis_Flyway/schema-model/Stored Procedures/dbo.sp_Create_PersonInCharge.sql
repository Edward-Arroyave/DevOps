SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/04/2023
-- Description: Procedimiento almacenado para crear acompañantes.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_PersonInCharge]
(
	@IdIdentificationType int,
	@IdentificationNumber varchar(20),
	@FullName varchar(255),
	@IdRelationship int,
	@IdCity int,
	@Address varchar(100),
	@TelephoneNumber varchar(15),
	@Email varchar(100),
	@IdUserAction int,
	@IdPersonInCharge int out
)
AS
BEGIN
    SET NOCOUNT ON

	IF NOT EXISTS (SELECT IdPersonInCharge FROM TB_PersonInCharge WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
		BEGIN
			INSERT INTO TB_PersonInCharge (IdIdentificationType, IdentificationNumber, FullName, IdRelationship, IdCity, Address, TelephoneNumber, Email, CreationDate, IdUserAction)
			VALUES (@IdIdentificationType, @IdentificationNumber, @FullName, @IdRelationship, @IdCity, @Address, @TelephoneNumber, @Email, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @IdPersonInCharge = IDENT_CURRENT('TB_PersonInCharge')
		END
	ELSE
		BEGIN
			UPDATE TB_PersonInCharge
				SET IdIdentificationType = @IdIdentificationType,
					IdentificationNumber = @IdentificationNumber,
					FullName = @FullName,
					IdRelationship = @IdRelationship,
					IdCity = @IdCity,
					Address = @Address,
					TelephoneNumber = @TelephoneNumber,
					Email = @Email,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdIdentificationType = @IdIdentificationType
				AND IdentificationNumber = @IdentificationNumber

			SET @IdPersonInCharge = (SELECT IdPersonInCharge FROM TB_PersonInCharge WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
		END
END
GO
