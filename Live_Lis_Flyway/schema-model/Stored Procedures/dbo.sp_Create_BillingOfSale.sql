SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/08/2022
-- Description: Procedimiento almacenado para crear factura de venta.
-- =============================================
--DECLARE @IdBillingOfSaleOut int, @Message varchar(50), @Flag bit
--EXEC [sp_Create_BillingOfSale] 1368,40687,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10000,NULL,NULL,NULL,44,@IdBillingOfSaleOut out, @Message out, @Flag out
--SELECT @IdBillingOfSaleOut, @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_BillingOfSale]
(
	@IdBillingOfSale int,
	@IdPatient int = NULL,
	@ThirdPerson bit,
	@IdTypeOfPerson int = NULL,
	@IdIdentificationType int = NULL,
	@IdentificationNumber varchar(15) = NULL,
	@VerificationDigit varchar(1) = NULL,
	@Name varchar(255) = NULL,
	@LastName varchar(255) = NULL,
	@Address varchar(100) = NULL,
	@IdCountry int = NULL,
	@IdCity int = NULL,
	@TelephoneNumber varchar(20) = NULL,
	@EmailTP varchar(100) = NULL,
	@TotalValue decimal (20,2) ,
	@Email varchar(100) = NULL,
	@Observation varchar(max) = NULL,
	@IdBusinessAdvisor int = NULL,
	@IdUserAction int,
	@IdBillingOfSaleOut int out,
	@Message varchar(50) out,
	@Flag bit out
		
)
AS
	DECLARE @IdThirdPerson int, @IdContract int, @IdContractType int, @IdRequest int, @IdAdmissionSource int
	DECLARE @IVA decimal (4,2) = 0

BEGIN

    SET NOCOUNT ON

			IF (select IVA from TB_GeneralConfiguration) = 1
				BEGIN
					SET @IVA = (select isnull(ivapercentage,1) from TB_GeneralConfiguration)
				END

			IF @IdContractType = 1 AND @IVA > 0
				BEGIN 
					SET @TotalValue = isnull(@TotalValue,0)+ (isnull(@TotalValue,0) * (@IVA / 100))
				END

	SET @IdAdmissionSource= (SELECT DISTINCT C.IdAdmissionSource
								FROM TB_BillingOfSale A
								INNER JOIN TR_BillingOfSale_Request B
									ON B.IdBillingOfSale = A.IdBillingOfSale
								INNER JOIN TB_Request C
									ON C.IdRequest = B.IdRequest
								WHERE A.IdBillingOfSale = @IdBillingOfSale)

	IF @IdPatient IS NULL
		BEGIN
			SET @IdPatient = (SELECT IdPatient FROM TB_BillingOfSale WHERE IdBillingOfSale = @IdBillingOfSale)
		END
	
	---Crear información de tercero
    IF @ThirdPerson = 'True'
		BEGIN
			IF NOT EXISTS (SELECT IdThirdPerson FROM TB_ThirdPerson WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
				BEGIN
					INSERT INTO TB_ThirdPerson (IdTypeOfPerson, IdIdentificationType, IdentificationNumber, VerificationDigit, Name, LastName, Address, IdCountry, IdCity, TelephoneNumber, Email, CreationDate, IdUserAction)
					VALUES (@IdTypeOfPerson, @IdIdentificationType, @IdentificationNumber, @VerificationDigit, @Name, @LastName, @Address, @IdCountry, @IdCity, @TelephoneNumber, @EmailTP, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @IdThirdPerson = SCOPE_IDENTITY ()
				END
			ELSE
				BEGIN
					SET @IdThirdPerson = (SELECT IdThirdPerson  FROM TB_ThirdPerson WHERE IdIdentificationType  = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
				END
		END

	--- Diligenciar información de pago.
	UPDATE TB_BillingOfSale
		SET BillingOfSaleDate = DATEADD(HOUR,-5,GETDATE()),
			IdPatient = @IdPatient,
			IdThirdPerson = @IdThirdPerson,
			TotalValuePatient = @TotalValue, 
			Email = @Email,
			IdBillingOfSaleStatus = 1,
			Observation = @Observation,
			IdBusinessAdvisor = @IdBusinessAdvisor,
			IdUserAction = @IdUserAction
	WHERE IdBillingOfSale = @IdBillingOfSale

	
	-- Actualizar estado de la solicitud 
	IF @IdAdmissionSource = 5
		BEGIN
			SET @IdRequest = (SELECT DISTINCT B.IdRequest FROM TB_BillingOfSale A INNER JOIN TR_BillingOfSale_Request B ON B.IdBillingOfSale = A.IdBillingOfSale INNER JOIN TB_Request C ON C.IdRequest = B.IdRequest WHERE A.IdBillingOfSale = @IdBillingOfSale AND C.IdAdmissionSource = 5)

			UPDATE A 
				SET A.IdRequestStatus =  CASE WHEN A.NumberOfPatients = TotalPatient THEN 3 ELSE 5 END		
			--SELECT A.IdRequestStatus, A.NumberOfPatients, B.TotalPatient, CASE WHEN A.NumberOfPatients = TotalPatient THEN 3 ELSE 5 END
			FROM TB_Request A
			INNER JOIN (
						SELECT IdRequest, COUNT(DISTINCT IdPatient) TotalPatient
						FROM TR_Request_Patient 
						WHERE IdRequest = @IdRequest
						GROUP BY IdRequest
						) B
				ON B.IdRequest = A.IdRequest
			WHERE A.IdRequest = @IdRequest
		END
	ELSE IF @IdAdmissionSource != 5
		BEGIN
			UPDATE B
				SET IdRequestStatus = 3,
					--UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			--SELECT *
			FROM TR_BillingOfSale_Request A
			INNER JOIN TB_Request B
				ON B.IdRequest = A.IdRequest
			WHERE A.IdBillingOfSale = @IdBillingOfSale
		END

	SET @IdBillingOfSaleOut = @IdBillingOfSale
	SET @Message = 'Successfully created billing of sale'
	SET @Flag = 1
	
END
GO
