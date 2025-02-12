SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/02/2023
-- Description: Procedimiento almaceanado para anular solicitud.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Cancel_Request] 21902,1,'PRUE',1,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Cancel_Request]
(
	@IdRequest int,
	@IdRequestCancelReason int,
	@RequestCancelReason varchar(max),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdContract int, @IdContractType int
BEGIN
    SET NOCOUNT ON

	SET @IdContract = (SELECT IdContract FROM TB_Request WHERE IdRequest = @IdRequest)
	SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)

	IF NOT EXISTS (SELECT IdRequest FROM TB_RequestResultAlternative WHERE IdRequest = @IdRequest) AND NOT EXISTS (SELECT C.IdResults FROM TB_Request A INNER JOIN TR_Patient_Exam B ON B.IdRequest = A.IdRequest INNER JOIN ANT.TB_Results C ON C.IdPatient_Exam = B.IdPatient_Exam WHERE A.IdRequest = @IdRequest)
		BEGIN
			UPDATE TB_Request
				SET IdRequestStatus = 2,
					IdCancellationReason = @IdRequestCancelReason,
					CancellationReason = @RequestCancelReason,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdRequest = @IdRequest

			UPDATE C
				SET C.IdBillingOfSaleStatus = 7
			FROM TB_Request A
			INNER JOIN TR_BillingOfSale_Request B
				ON B.IdRequest = A.IdRequest
			INNER JOIN TB_BillingOfSale C
				ON C.IdBillingOfSale = B.IdBillingOfSale
			WHERE A.IdRequest = @IdRequest

			IF @IdContractType = 3
				BEGIN
					-- Reintegrar el valor total del servicio del monto contrato
					UPDATE A
						SET A.ContractAmount = A.ContractAmount + C.TotalValueCompany
					FROM TB_Contract A
					INNER JOIN TB_Request B
						ON B.IdContract = A.IdContract
					INNER JOIN TR_BillingOfSale_Request C
						ON C.IdRequest = B.IdRequest
					WHERE A.IdContract = @IdContract
						AND B.IdRequest = @IdRequest
				END
			ELSE IF @IdContractType IN (2,4) 
				BEGIN
					IF @IdContractType = 2
						BEGIN
							-- Reintegrar el valor total del servicio del saldo contrato
							UPDATE A
								SET A.ContractBalance = A.ContractBalance + C.TotalValueCompany
							FROM TB_Contract A
							INNER JOIN TB_Request B
								ON B.IdContract = A.IdContract
							INNER JOIN TR_BillingOfSale_Request C
								ON C.IdRequest = B.IdRequest
							WHERE A.IdContract = @IdContract
								AND B.IdRequest = @IdRequest
						END
					ELSE IF @IdContractType = 4
						BEGIN
							UPDATE A
								SET A.ContractBalance = A.ContractBalance  + C.TotalValueCompany,
									A.PositiveBalance = A.PositiveBalance - C.TotalValuePatient
							FROM TB_Contract A
							INNER JOIN TB_Request B
								ON B.IdContract = A.IdContract
							INNER JOIN TR_BillingOfSale_Request C
								ON C.IdRequest = B.IdRequest
							WHERE A.IdContract = @IdContract
								AND C.IdRequest = @IdRequest
						END
				END

			SET @Message = 'Successfully cancel request'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Request already has result'
			SET @Flag = 0
		END
END
GO
