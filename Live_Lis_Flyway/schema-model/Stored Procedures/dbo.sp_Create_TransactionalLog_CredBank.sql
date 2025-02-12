SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/08/2022
-- Description: Procedimiento almacenado para almacenar información de transacciones.
-- =============================================
-- EXEC [sp_Create_TransactionalLog_CredBank]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_TransactionalLog_CredBank]
(
	@IdBillingOfSale int = NULL,
	@TransactionProcess varchar(25),
	@TransactionResponseCode varchar(10), 
	@ResponseTransaction varchar(120),
	@IdTransaction varchar(10),
	@ApprovalNumber varchar(10),
	@IdUser int,
	@ReceiptNumber varchar(10),
	@DataResponse varchar(100),
	@TotalValue bigint,
	@IdTransactionalLog int out, 
	@IdTransactionOut varchar(10) out
)
AS
BEGIN
    SET NOCOUNT ON

	INSERT INTO TB_TransactionalLog_CredBank
	VALUES (@IdBillingOfSale, @TransactionProcess, @TransactionResponseCode, @ResponseTransaction, @IdTransaction, CASE WHEN @TransactionProcess = '' THEN NULL 
																														ELSE @ApprovalNumber END, @IdUser, DATEADD(HOUR,-5,GETDATE()), @ReceiptNumber, @DataResponse, @TotalValue)

	SET @IdTransactionalLog = SCOPE_IDENTITY ()
	SET @IdTransactionOut = (SELECT IdTransaction FROM TB_TransactionalLog_CredBank WHERE IdTransactionalLog = @IdTransactionalLog)
END
GO
