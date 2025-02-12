CREATE TABLE [dbo].[TR_BillingOfSale_Request]
(
[IdBillingOfSale_Request] [int] NOT NULL IDENTITY(1, 1),
[IdBillingOfSale] [int] NOT NULL,
[IdRequest] [int] NOT NULL,
[RequestNumber] [varchar] (20) NOT NULL,
[TotalValuePatient] [decimal] (20, 2) NULL,
[TotalValueCompany] [decimal] (20, 2) NULL,
[OriginalValue] [decimal] (20, 2) NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==============================================
-- Create dml trigger template Azure SQL Database 
-- ==============================================
CREATE TRIGGER [dbo].[TG_Request_Contract]
   ON  [dbo].[TR_BillingOfSale_Request] 
   AFTER INSERT, UPDATE
AS
	DECLARE @IdContract int, @IdContractType int, @IdRequest int, @TotalValuePatient bigint--, @GenerateCopayCM int, @IdAdmissionSource int, @FamilyGroup varchar(100), @IdBillingOfSale int
BEGIN
	SET NOCOUNT ON;

	SET @IdRequest = (SELECT IdRequest FROM inserted)
	SET @IdContract = (SELECT IdContract FROM TB_Request WHERE IdRequest = @IdRequest)
	SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)
	--SET @TotalValuePatient = (SELECT TotalValuePatient FROM inserted WHERE IdRequest = @IdRequest)

	IF UPDATE (TotalValuePatient) OR UPDATE (TotalValueCompany)
		BEGIN
			IF (SELECT TotalValuePatient FROM deleted) IS NULL AND (SELECT TotalValueCompany FROM deleted) IS NULL
				BEGIN
					IF @IdContractType = 3
						BEGIN
							IF (SELECT ContractAmount FROM TB_Contract WHERE IdContract = @IdContract) >= (SELECT TotalValueCompany FROM inserted WHERE IdRequest = @IdRequest)
								BEGIN
									-- Descuenta el valor total del servicio del monto contrato
									UPDATE A
										SET A.ContractAmount = A.ContractAmount - C.TotalValueCompany
									FROM TB_Contract A
									INNER JOIN TB_Request B
										ON B.IdContract = A.IdContract
									INNER JOIN inserted C
										ON C.IdRequest = B.IdRequest
									WHERE A.IdContract = @IdContract
										AND B.IdRequest = @IdRequest
								END
							ELSE
								BEGIN
									Print 'Insufficient contract amount'
								END
						END
					ELSE IF @IdContractType IN (2,4) 
						BEGIN
							IF (SELECT ContractBalance FROM TB_Contract WHERE IdContract = @IdContract) >= (SELECT TotalValueCompany FROM inserted WHERE IdRequest = @IdRequest)
								BEGIN
									IF @IdContractType = 2
										BEGIN
											-- Descuenta el valor total del servicio del saldo contrato
											UPDATE A
												SET A.ContractBalance = A.ContractBalance - C.TotalValueCompany
											FROM TB_Contract A
											INNER JOIN TB_Request B
												ON B.IdContract = A.IdContract
											INNER JOIN inserted C
												ON C.IdRequest = B.IdRequest
											WHERE A.IdContract = @IdContract
												AND B.IdRequest = @IdRequest
										END
									ELSE IF @IdContractType = 4
										BEGIN
											UPDATE A
												SET A.ContractBalance = A.ContractBalance  - C.TotalValueCompany,
													A.PositiveBalance = A.PositiveBalance + C.TotalValuePatient
											FROM TB_Contract A
											INNER JOIN TB_Request B
												ON B.IdContract = A.IdContract
											INNER JOIN inserted C
												ON C.IdRequest = B.IdRequest
											WHERE A.IdContract = @IdContract
												AND C.IdRequest = @IdRequest
										END
								END
							ELSE
								BEGIN
									Print 'Insufficient contract amount'
								END
						END
				END
			ELSE
				BEGIN
					SET @TotalValuePatient = (SELECT TotalValuePatient FROM inserted WHERE IdRequest = @IdRequest)
					----- Reintegrar dinero a contratos.
					--IF @IdContractType = 3
					--	BEGIN
					--		-- Reintegrar el valor total del servicio del monto contrato
					--		UPDATE A
					--			SET A.ContractAmount = A.ContractAmount + C.TotalValueCompany
					--		FROM TB_Contract A
					--		INNER JOIN TB_Request B
					--			ON B.IdContract = A.IdContract
					--		INNER JOIN deleted C
					--			ON C.IdRequest = B.IdRequest
					--		WHERE A.IdContract = @IdContract
					--			AND B.IdRequest = @IdRequest
					--	END
					--ELSE IF @IdContractType IN (2,4) 
					--	BEGIN
					--		IF @IdContractType = 2
					--			BEGIN
					--				-- Reintegrar el valor total del servicio del saldo contrato
					--				UPDATE A
					--					SET A.ContractBalance = A.ContractBalance + C.TotalValueCompany
					--				FROM TB_Contract A
					--				INNER JOIN TB_Request B
					--					ON B.IdContract = A.IdContract
					--				INNER JOIN deleted C
					--					ON C.IdRequest = B.IdRequest
					--				WHERE A.IdContract = @IdContract
					--					AND B.IdRequest = @IdRequest
					--			END
					--		ELSE IF @IdContractType = 4
					--			BEGIN
					--				UPDATE A
					--					SET A.ContractBalance = A.ContractBalance  + C.TotalValueCompany,
					--						A.PositiveBalance = A.PositiveBalance - C.TotalValuePatient
					--				FROM TB_Contract A
					--				INNER JOIN TB_Request B
					--					ON B.IdContract = A.IdContract
					--				INNER JOIN deleted C
					--					ON C.IdRequest = B.IdRequest
					--				WHERE A.IdContract = @IdContract
					--					AND C.IdRequest = @IdRequest
					--			END
					--	END


					----- Realizar descuento a contratos
					--IF @IdContractType = 3
					--	BEGIN
					--		IF (SELECT ContractAmount FROM TB_Contract WHERE IdContract = @IdContract) >= (SELECT TotalValueCompany FROM inserted WHERE IdRequest = @IdRequest)
					--			BEGIN
					--				-- Descuenta el valor total del servicio del monto contrato
					--				UPDATE A
					--					SET A.ContractAmount = A.ContractAmount - C.TotalValueCompany
					--				FROM TB_Contract A
					--				INNER JOIN TB_Request B
					--					ON B.IdContract = A.IdContract
					--				INNER JOIN inserted C
					--					ON C.IdRequest = B.IdRequest
					--				WHERE A.IdContract = @IdContract
					--					AND B.IdRequest = @IdRequest
					--			END
					--		ELSE
					--			BEGIN
					--				Print 'Insufficient contract amount'
					--			END
					--	END
					--ELSE IF @IdContractType IN (2,4) 
					--	BEGIN
					--		IF (SELECT ContractBalance FROM TB_Contract WHERE IdContract = @IdContract) >= (SELECT TotalValueCompany FROM inserted WHERE IdRequest = @IdRequest)
					--			BEGIN
					--				IF @IdContractType = 2
					--					BEGIN
					--						-- Descuenta el valor total del servicio del saldo contrato
					--						UPDATE A
					--							SET A.ContractBalance = A.ContractBalance - C.TotalValueCompany
					--						FROM TB_Contract A
					--						INNER JOIN TB_Request B
					--							ON B.IdContract = A.IdContract
					--						INNER JOIN inserted C
					--							ON C.IdRequest = B.IdRequest
					--						WHERE A.IdContract = @IdContract
					--							AND B.IdRequest = @IdRequest
					--					END
					--				ELSE IF @IdContractType = 4
					--					BEGIN
					--						UPDATE A
					--							SET A.ContractBalance = A.ContractBalance  - C.TotalValueCompany,
					--								A.PositiveBalance = A.PositiveBalance + C.TotalValuePatient
					--						FROM TB_Contract A
					--						INNER JOIN TB_Request B
					--							ON B.IdContract = A.IdContract
					--						INNER JOIN inserted C
					--							ON C.IdRequest = B.IdRequest
					--						WHERE A.IdContract = @IdContract
					--							AND C.IdRequest = @IdRequest
					--					END
					--			END
					--		ELSE
					--			BEGIN
					--				Print 'Insufficient contract amount'
					--			END
					--	END
				END
		END
END
GO
ALTER TABLE [dbo].[TR_BillingOfSale_Request] ADD CONSTRAINT [PK_TR_BillingOfSale_Request] PRIMARY KEY CLUSTERED ([IdBillingOfSale_Request])
GO
CREATE NONCLUSTERED INDEX [IDX_IdBillingOfSale] ON [dbo].[TR_BillingOfSale_Request] ([IdBillingOfSale]) INCLUDE ([IdRequest])
GO
CREATE NONCLUSTERED INDEX [IDX_TR_BillingOfSale_Request_ITT] ON [dbo].[TR_BillingOfSale_Request] ([IdRequest]) INCLUDE ([IdBillingOfSale], [TotalValueCompany], [TotalValuePatient])
GO
ALTER TABLE [dbo].[TR_BillingOfSale_Request] ADD CONSTRAINT [FK_TR_BillingOfSale_Request_TB_BillingOfSale] FOREIGN KEY ([IdBillingOfSale]) REFERENCES [dbo].[TB_BillingOfSale] ([IdBillingOfSale])
GO
ALTER TABLE [dbo].[TR_BillingOfSale_Request] ADD CONSTRAINT [FK_TR_BillingOfSale_Request_TB_Request] FOREIGN KEY ([IdRequest]) REFERENCES [dbo].[TB_Request] ([IdRequest])
GO
