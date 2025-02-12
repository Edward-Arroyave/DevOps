SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 29/08/2022
-- Description: Procedimiento almacenado para crear abono a entidad.
-- =============================================
/*
begin tran
DECLARE @InstallmentContract_Contract InstallmentContract_Contract
DECLARE @Message varchar(50), @Flag bit
insert into @InstallmentContract_Contract (IdContract, IdContractType, ContractAmount)
values (237,3,1000000)
EXEC [sp_Create_InstallmentContract]'55555',125,@InstallmentContract_Contract,1000000,1,'3666666',null,2,@Message out, @Flag out
SELECT @Message, @Flag

rollback
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_InstallmentContract]
(
	@InstallmentNumber varchar(20),
	@IdCompany int, 
	@InstallmentContract_Contract InstallmentContract_Contract READONLY,
	@ContractAmount bigint, 
	@IdPaymentMethod int, 
	@ReferenceNumber varchar(20),
	@IdBankAccount bigint = NULL,
	@IdUserAction int,
	@Message varchar(60) out,
	@Flag bit out
)
AS
--begin try
	DECLARE @IdContractType int, @IdInstallmentContract int, @IdInstallmentContratType int, @IdBillingBox int, @Aux int = 1, @IdInstallmentContract_PreBilling int, 
			@InstallmentContratBalance bigint, @IdContract int, @IdDebitNote Int
	DECLARE @InstallmentContractContract table (Id int identity, IdInstallmentContract int, IdContract int, ContractAmount bigint )
BEGIN
    SET NOCOUNT ON

	SET @IdBillingBox = (SELECT IdBillingBox FROM TB_BillingBox WHERE IdUser = @IdUserAction AND BillingBoxStatus = 1)

	--IF NOT EXISTS (SELECT InstallmentContractNumber FROM TB_InstallmentContract WHERE InstallmentContractNumber = @InstallmentNumber)
	--	BEGIN
			INSERT INTO TB_InstallmentContract (InstallmentContractNumber, IdCompany, IdBankAccount, ContractAmount, IdPaymentMethod, ReferenceNumber, Crossway, IdBillingBox, Active, CreationDate, IdUserAction)
			VALUES (@InstallmentNumber, @IdCompany, @IdBankAccount, @ContractAmount, @IdPaymentMethod, @ReferenceNumber, 0, @IdBillingBox, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
			
			SET @IdInstallmentContract = SCOPE_IDENTITY ()
			
			MERGE TR_InstallmentContract_Contract AS TARGET
			USING
				(SELECT IdContract, ContractAmount, (CASE WHEN IdContractType = 3 THEN 1 WHEN IdContractType IN (2,4) THEN 2 END) AS IdInstallmentContractType FROM @InstallmentContract_Contract) SOURCE
			ON TARGET.IdInstallmentContract = @IdInstallmentContract
				AND TARGET.IdContract = SOURCE.IdContract
			WHEN NOT MATCHED BY TARGET
			THEN
				INSERT (IdInstallmentContract, IdContract, IdInstallmentContractType, ContractAmount, Crossway, Active, CreationDate, IdUserAction)
				VALUES
					(
					@IdInstallmentContract, 
					SOURCE.IdContract,
					SOURCE.IdInstallmentContractType,
					SOURCE.ContractAmount,
					0,
					1,
					DATEADD(HOUR,-5,GETDATE()),
					@IdUserAction
					)
			WHEN NOT MATCHED BY SOURCE AND TARGET.IdInstallmentContract = @IdInstallmentContract AND TARGET.Active = 1
				THEN
					UPDATE
						SET TARGET.Active = 0,
							TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHEN MATCHED
				THEN
					UPDATE
						SET TARGET.ContractAmount = SOURCE.ContractAmount,
							TARGET.Active = 1,
							TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE());


			INSERT INTO @InstallmentContractContract (IdInstallmentContract, IdContract, ContractAmount)
			SELECT @IdInstallmentContract, IdContract, ContractAmount
			FROM @InstallmentContract_Contract


			WHILE @Aux <= (SELECT TOP 1 Id FROM @InstallmentContractContract WHERE Id = @Aux ORDER BY Id)
				BEGIN
					SET @IdContract = (SELECT IdContract FROM @InstallmentContractContract WHERE Id = @Aux)
					SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)

					--- Cuando tipo de contrato es facturación por abono = Valor de abono se suma a monto contrato.
					IF (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract) = 3
						BEGIN
						
							declare @TB_DebitNote table (IdDebitNote int, IdContract int, Amount bigint, BalanceReceivable bigint)

							insert into @TB_DebitNote 
							select	IdDebitNote , IdContract , Amount , BalanceReceivable 
							from	TB_DebitNote 
							where	IdContract = @IdContract
							and		IdDebitNoteState in (1,4)
							order by IdDebitNote

							declare @count int = (select COUNT(*) from @TB_DebitNote)

							declare @ContractAmountC bigint = (select ContractAmount from TR_InstallmentContract_Contract where IdContract = @IdContract and IdInstallmentContract = @IdInstallmentContract)
							declare @ContractAmountContract bigint = (select ContractAmount from TR_InstallmentContract_Contract where IdContract = @IdContract and IdInstallmentContract = @IdInstallmentContract)

							WHILE @count >0
								BEGIN
									set @IdDebitNote  = (select top 1 IdDebitNote from @TB_DebitNote where IdContract=@IdContract order by IdDebitNote asc)
									declare @BalanceReceivable bigint = (select BalanceReceivable from @TB_DebitNote where IdDebitNote = @IdDebitNote)
					
										if @BalanceReceivable > @ContractAmountC
										begin
											update TB_DebitNote set BalanceReceivable = @BalanceReceivable - @ContractAmountC,
																	IdDebitNoteState=4
											where IdDebitNote = @IdDebitNote

											insert into TR_DebitNote_InstallmentContract_Contract (iddebitnote, idinstallmentcontract_contract)
											select	@IdDebitNote,IdInstallmentContract_Contract
											from	TR_InstallmentContract_Contract A
													INNER JOIN TB_Contract B
														ON B.IdContract = A.IdContract
											WHERE	A.IdContract = @IdContract
                 							 AND		A.IdInstallmentContract = @IdInstallmentContract

											set @ContractAmountC = 0
										end
										else 
										begin
											update TB_DebitNote set BalanceReceivable = 0,
																	IdDebitNoteState=3
											where IdDebitNote = @IdDebitNote

											insert into TR_DebitNote_InstallmentContract_Contract (iddebitnote, idinstallmentcontract_contract)
											select	@IdDebitNote,IdInstallmentContract_Contract
											from	TR_InstallmentContract_Contract A
													INNER JOIN TB_Contract B
														ON B.IdContract = A.IdContract
											WHERE	A.IdContract = @IdContract
                 							 AND		A.IdInstallmentContract = @IdInstallmentContract

											set @ContractAmountC = @ContractAmountC - @BalanceReceivable
										end

									Delete from @TB_DebitNote where IdDebitNote = @IdDebitNote

									if @ContractAmountC >0
									begin
										SET @count = (select COUNT(*) from @TB_DebitNote)
									end
									else
									begin
										set @ContractAmountContract = @ContractAmountC
										set @count = 0
									end
								END


								UPDATE B	
									SET B.ContractAmount = B.ContractAmount + @ContractAmountC--A.ContractAmount
								--SELECT *
								FROM TR_InstallmentContract_Contract A
								INNER JOIN TB_Contract B
									ON B.IdContract = A.IdContract
								WHERE A.IdContract = @IdContract
                               		AND A.IdInstallmentContract = @IdInstallmentContract
						END

						SET @Aux = @Aux + 1
				END

			SET @Message = 'Successfully created installment contract'
			SET @Flag = 1
END
--end try
--begin catch
--			SET @Message = 'Error creando el abono'
--			SET @Flag = 1
--end catch

--select * from TB_CIE10_Code4
GO
