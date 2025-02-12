SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 03/04/2024
-- Description: Procedimiento almacenado para crear Notas Débito
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_DebitNote]
(
	@DebitNoteNumber int = null,
	@IdContract int,
	@Amount int,
	@IdDebitNoteConcept int,
	@AuthorizesName varchar (200),
	@PaymentReason varchar (max),
	@IdCreationUser int,
	@Message varchar(50) out,
	@Flag bit out
)
AS

BEGIN TRY

BEGIN
	
	DECLARE @ContractAmount Bigint

    SET NOCOUNT ON

	SET @ContractAmount = (select ISNULL(ContractAmount,0) from TB_Contract where idcontract = @IdContract)

	IF @Amount > 0
		BEGIN
			IF @AuthorizesName is not null and @PaymentReason is not null
				BEGIN			
					INSERT INTO TB_DebitNote(DebitNoteNumber, IdContract, CreateDate, Amount, BalanceReceivable, IdDebitNoteState, IdDebitNoteConcept, AuthorizesName, PaymentReason,IdCreationUser)
					VALUES (@DebitNoteNumber, @IdContract, DATEADD(HOUR,-5,GETDATE()), @Amount, @Amount, 1, @IdDebitNoteConcept, @AuthorizesName, @PaymentReason, @IdCreationUser)

					UPDATE	TB_Contract set ContractAmount = @ContractAmount+@Amount
					where	idcontract = @IdContract


					SET @Message = 'Successfully created Debit Note'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'You must fill out who authorizes and the reason'
					SET @Flag = 0
				END				
		END
	ELSE
		BEGIN
			SET @Message = 'The value must be greater than zero'
			SET @Flag = 0
		END
	END

END TRY
BEGIN CATCH
			SET @Message = 'Error creating DebitNote, please verify the data entered'
			SET @Flag = 0
END CATCH

GO
