SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:     Wendy Paola Tellez Gonzalez
-- Create Date: 07/02/2023
-- Description: Procedimiento almacenado para diligenciar información de Empresa.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Business]
(
	@BusinessName varchar(100),
	@Name varchar(100),
	@NIT varchar(9),
	@VerificationDigit varchar(1),
	@Email varchar(100),
	@Address varchar(100),
	@PostalCode varchar(8),
	@IdCountry int,
	@IdCity int = NULL,
	@IdAttentionCenter smallint = NULL,
	@IdIdentificationType tinyint = NULL,
	@Interoperability bit = NULL,
	@IVA bit = NULL,
	@IvaPercentage decimal (4,2) = NULL,
	@TelephoneNumber varchar(20),
	@FiscalResponsibility varchar(50),
	@IdUSerAction int,
	@RFC varchar(12) = null,
	@Message varchar(50) out,
	@Flag bit out,
	@IdBusinessOut int out
)
AS
	DECLARE @IdFiscalResponsibility int, @Position int 
	DECLARE @Business_FiscalResponsibility table (IdBusiness int, IdFiscalResponsibility int, Active int, DateAction DateTime, IdUserAction int )
	DECLARE @IdBusiness int 
BEGIN

    SET NOCOUNT ON
	
	IF (SELECT IdBusiness FROM TB_Business) IS NULL	
		BEGIN
			INSERT INTO TB_Business (BusinessName, Name, NIT, VerificationDigit, Email, Address, PostalCode, IdCountry, IdCity, TelephoneNumber,
									IdAttentionCenter, IdIdentificationType, Interoperability, IVA, IvaPercentage, RFC)
			VALUES (@BusinessName, @Name, @NIT, @VerificationDigit, @Email, @Address, @PostalCode, @IdCountry, @IdCity, @TelephoneNumber,
					@IdAttentionCenter, @IdIdentificationType, @Interoperability, @IVA, @IvaPercentage, @RFC)

			SET @IdBusiness = SCOPE_IDENTITY()

			IF @FiscalResponsibility != ''
				BEGIN
					SET @FiscalResponsibility = @FiscalResponsibility + ','

					WHILE PATINDEX('%,%', @FiscalResponsibility) <> 0
						BEGIN
							SELECT @Position = PATINDEX('%,%', @FiscalResponsibility)
							SELECT @IdFiscalResponsibility = LEFT(@FiscalResponsibility, @Position -1)
							SET @IdFiscalResponsibility = (SELECT IdFiscalResponsibility FROM TB_FiscalResponsibility WHERE @IdFiscalResponsibility = @IdFiscalResponsibility)

							INSERT INTO TR_Business_FiscalResponsibility (IdBusiness, IdFiscalResponsibility, Active, CreationDate, IdUserAction)
							VALUES (@IdBusiness, @IdFiscalResponsibility, 1, DATEADD (HOUR,-5,GETDATE()),@IdUserAction )

							SET @FiscalResponsibility = STUFF(@FiscalResponsibility, 1, @Position, '')
						END
				END
			
			SET @Message = 'Successfully created Business'
			SET @Flag = 1
			SET @IdBusinessOut=@IdBusiness
		END
	ELSE
		BEGIN
			UPDATE TB_Business
				SET BusinessName = @BusinessName,
					Name = @Name,
					NIT = @NIT,
					VerificationDigit = @VerificationDigit,
					Email = @Email,
					Address = @Address,
					PostalCode = @PostalCode,
					IdCountry = @IdCountry,
					IdCity = @IdCity,
					TelephoneNumber = @TelephoneNumber,
					IdAttentionCenter = @IdAttentionCenter,
					IdIdentificationType = @IdIdentificationType,
					Interoperability = @Interoperability,
					IVA = @IVA,
					IvaPercentage = @IvaPercentage,
					RFC = @RFC

			SET @IdBusiness = (SELECT IdBusiness FROM TB_Business )

			IF @FiscalResponsibility != ''
				BEGIN
					SET @FiscalResponsibility = @FiscalResponsibility + ','

					WHILE PATINDEX('%,%', @FiscalResponsibility) <> 0
						BEGIN
							SELECT @Position = PATINDEX('%,%', @FiscalResponsibility)
							SELECT @IdFiscalResponsibility = LEFT(@FiscalResponsibility, @Position -1)
							SET @IdFiscalResponsibility = (SELECT IdFiscalResponsibility FROM TB_FiscalResponsibility WHERE IdFiscalResponsibility = @IdFiscalResponsibility)

							INSERT INTO @Business_FiscalResponsibility (IdBusiness, IdFiscalResponsibility, Active, DateAction, IdUserAction)
							VALUES (@IdBusiness, @IdFiscalResponsibility, 1, DATEADD (HOUR, -5, GETDATE()), @IdUserAction)

							SET @FiscalResponsibility = STUFF(@FiscalResponsibility, 1, @Position, '')
						END

					MERGE TR_Business_FiscalResponsibility AS TARGET
					USING @Business_FiscalResponsibility SOURCE
						ON TARGET.IdfiscalResponsibility = SOURCE.IdFiscalResponsibility
							AND TARGET.IdBusiness = SOURCE.IdBusiness
					WHEN NOT MATCHED BY TARGET
					THEN
						INSERT (IdBusiness, IdFiscalResponsibility, Active, CreationDate, IdUserAction)
						VALUES
							(
							SOURCE.IdBusiness,
							SOURCE.IdFiscalResponsibility,
							SOURCE.Active,
							SOURCE.DateAction,
							SOURCE.IdUserAction
							)
					WHEN NOT MATCHED BY SOURCE  AND TARGET.Active = 1
						THEN
							UPDATE
								SET TARGET.Active = 0
					WHEN MATCHED
						THEN
							UPDATE
								SET TARGET.Active = 1;
				END

			SET @Message = 'Successfully updated Business'
			SET @Flag = 1
			SET @IdBusinessOut=@IdBusiness
	END
END
GO
