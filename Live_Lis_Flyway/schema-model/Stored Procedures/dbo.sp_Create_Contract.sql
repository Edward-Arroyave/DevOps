SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 02/02/2022
-- Description: Procedimiento almacenado para crear contratos.
-- =============================================
/*
begin tran
declare @IdContractOut int,	@Message varchar(50),@Flag bit
exec dbo.sp_Create_Contract 4964,16712,'CORPORACION HOSPITALARIA JUAN CIUDAD.',4,3351,609,'2024-05-01',2,0,99942566800,
							0,'2021-12-03','2024-12-31',2,null,null,1,0,0,0,
							null,null,null,null,null,null,null,null,null,null,
							null,null,null,2,null,null,null,null,2,null,
							null,null,
							@IdContractOut, @Message, @Flag 
select @IdContractOut, @Message , @Flag

rollback
*/
CREATE PROCEDURE [dbo].[sp_Create_Contract]
(
	@IdContract int,
	@ContractCode varchar(100),
	@ContractName varchar(100),
	@IdContractType int,
	@IdCompany int,
	@IdTariffScheme int,
	@InitialValidityTariffServDate date = NULL,
	@IdContractAmountType int,
	@ContractAmount bigint,
	@ContractBalance bigint,

	@PatientAmount bigint,
	@InitialValidaty datetime,
	@ExpirationDate datetime,
	@IdUser int,
	@IdContractDeadline int = NULL,
	@BillToParticular bit = NULL,
	@IdGenerateCopay_CM int,
	@FileClinicHistory bit,
	@FileAuthorization bit,
	@FileMedicalOrder bit,

	@RequirementsForAttention varchar(150) = NULL,
	@IdAdditionalForm int = NULL,
	@IdQuoteValidity int = NULL, 
	@ElectronicUser varchar(100) = NULL,
	@IdPaymentMethod int = NULL,
	@IdBillingGroup int = NULL,
	@InitialPaymentDay int = NULL,
	@FinalPaymentDay int = NULL,
	@IdCommercialTeam int = NULL,
	@AttentPreRequisite bit = NULL,

	@AttentionPreRequisite varchar(max) = NULL,
	@BillRequirement bit = NULL,
	@BillingRequirements varchar(max) = NULL,
	@IdBusinessUnit int,
	@AccountingAccount varchar(20) = NULL,
	@UpdateReason varchar(max) = NULL,
	@WhoAuthorized varchar(255) = NULL,
	@IdAttentionModel int = NULL,
	@IdUserAction int,
	@SeparationOfServices bit = null,

	@IdCity int = null,
	@FilingAddress varchar (200) = null,
	@IdQuoteForm int = null,
	@ApplyDiscount bit = 0,

	@IdContractOut int out,
	@Message varchar(50) out,
	@Flag bit out

)
AS
	DECLARE @ContractNumber int = 1, @IdTariffSchemeOld int
BEGIN
    SET NOCOUNT ON

	IF @IdContract = 0
		BEGIN
			IF NOT EXISTS (SELECT IdContract FROM TB_Contract WHERE ContractCode = @ContractCode AND ContractName = @ContractName)
				BEGIN
					IF NOT EXISTS (SELECT ContractCode FROM TB_Contract WHERE ContractCode = @ContractCode)
						BEGIN
							IF NOT EXISTS (SELECT ContractName FROM TB_Contract WHERE ContractName = @ContractName)
								BEGIN
									SET @ContractNumber =  @ContractNumber + (SELECT COUNT(ContractNumber) FROM TB_Contract WHERE IdCompany = @IdCompany)

									INSERT INTO TB_Contract (ContractCode, ContractNumber, ContractName, IdContractType, IdCompany, IdTariffScheme, IdContractAmountType, 
									ContractAmount, ContractBalance, PositiveBalance, PatientAmount, CustomerBalance, InitialValidity, ExpirationDate, IdSellerCode, 
									IdContractDeadline, BillToParticular, IdGenerateCopay_CM, FileClinicHistory, FileAuthorization, FileMedicalOrder, RequirementsForAttention, 
									IdAdditionalForm, IdQuoteValidity, ElectronicUser, IdPaymentMethod, IdBillingGroup, InitialPaymentDay, FinalPaymentDay, IdCommercialTeam, 
									AttentPreRequisite, AttentionPreRequisite, BillRequirement, BillingRequirements, IdBusinessUnit, AccountingAccount, IdAttentionModel, 
									Active, CreationDate, IdUserAction, SeparationOfServices, IdCity, FilingAddress, IdQuoteForm, ApplyDiscount)
									VALUES (@ContractCode, @ContractNumber, @ContractName, @IdContractType, @IdCompany, @IdTariffScheme, @IdContractAmountType, 
									@ContractAmount, @ContractBalance, 0, @PatientAmount, 0, @InitialValidaty, @ExpirationDate, @IdUser, 
									@IdContractDeadline, @BillToParticular, @IdGenerateCopay_CM, @FileClinicHistory, @FileAuthorization, @FileMedicalOrder, @RequirementsForAttention, 
									@IdAdditionalForm, @IdQuoteValidity, @ElectronicUser, @IdPaymentMethod, @IdBillingGroup, @InitialPaymentDay, @FinalPaymentDay, @IdCommercialTeam, 
									@AttentPreRequisite, @AttentionPreRequisite, @BillRequirement, @BillingRequirements, @IdBusinessUnit, @AccountingAccount, @IdAttentionModel, 
									1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, @SeparationOfServices, @IdCity, @FilingAddress, @IdQuoteForm, @ApplyDiscount)

									SET @Message = 'Successfully created contract'
									SET @Flag = 1
									SET @IdContractOut = SCOPE_IDENTITY()
								END
							ELSE
								BEGIN
									SET @Message = 'Contract name already exists'
									SET @Flag = 0
									SET @IdContractOut = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Contract number already exists'
							SET @Flag = 0
							SET @IdContractOut = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Contract number and name already exists'
					SET @Flag = 0
					SET @IdContractOut = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT ContractCode FROM TB_Contract WHERE ContractCode = @ContractCode AND IdContract != @IdContract)
				BEGIN
					IF NOT EXISTS (SELECT ContractName FROM TB_Contract WHERE ContractName = @ContractName AND IdContract != @IdContract)
						BEGIN
							SET @IdTariffSchemeOld = (SELECT IdTariffScheme FROM TB_Contract WHERE IdContract = @IdContract)
							SET @ContractNumber =  @ContractNumber + (SELECT COUNT(ContractNumber) FROM TB_Contract WHERE IdCompany = @IdCompany AND IdContract != @IdContract)

							UPDATE TB_Contract
								SET ContractCode = @ContractCode, 
									ContractNumber = @ContractNumber,
									ContractName = @ContractName,
									IdContractType = @IdContractType, 
									IdCompany = @IdCompany,
									IdContractAmountType = @IdContractAmountType,
									ContractAmount = @ContractAmount,
									ContractBalance = @ContractBalance,
									PatientAmount = @PatientAmount, 
									InitialValidity = @InitialValidaty,
									ExpirationDate = @ExpirationDate,
									IdSellerCode = @IdUser,
									IdContractDeadline = @IdContractDeadline,
									BillToParticular = @BillToParticular,
									IdGenerateCopay_CM = @IdGenerateCopay_CM,
									FileClinicHistory = @FileClinicHistory,
									FileAuthorization = @FileAuthorization,
									FileMedicalOrder = @FileMedicalOrder,
									IdAdditionalForm = @IdAdditionalForm,
									IdQuoteValidity = @IdQuoteValidity,
									ElectronicUser = @ElectronicUser, 
									IdPaymentMethod = @IdPaymentMethod, 
									IdBillingGroup = @IdBillingGroup, 
									InitialPaymentDay = @InitialPaymentDay, 
									FinalPaymentDay = @FinalPaymentDay,
									IdCommercialTeam = @IdCommercialTeam,
									AttentPreRequisite = @AttentPreRequisite,
									AttentionPreRequisite = @AttentionPreRequisite,
									BillRequirement = @BillRequirement,
									BillingRequirements = @BillingRequirements,
									IdBusinessUnit = @IdBusinessUnit,
									AccountingAccount = @AccountingAccount,
									UpdateReason = @UpdateReason,
									WhoAuthorized = @WhoAuthorized,
									IdAttentionModel = @IdAttentionModel,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction,
									SeparationOfServices = @SeparationOfServices,
									IdCity = @IdCity,
									FilingAddress = @FilingAddress,
									IdQuoteForm = @IdQuoteForm,
									ApplyDiscount = @ApplyDiscount
							WHERE IdContract = @IdContract

							--- CAMBIO DE ESQUEMA TARIFARIO					
							IF @IdTariffSchemeOld != @IdTariffScheme
								BEGIN
									IF @InitialValidityTariffServDate IS NOT NULL
										BEGIN	
											--IF @InitialValidityTariffServDate <= CONVERT(DATE,DATEADD(HOUR,-5,GETDATE()))
												--BEGIN
											--		UPDATE TB_Contract
											--			SET IdTariffScheme = @IdTariffScheme,
											--				InitialValidityTariffServDate = @InitialValidityTariffServDate
											--		WHERE IdContract = @IdContract
											--	END
											--ELSE
											--	BEGIN
											
											IF (select COUNT(*) from TB_ContractTariffScheme where idcontract = @IdContract and IdTariffScheme = @IdTariffScheme)>0
												BEGIN
													UPDATE	TB_ContractTariffScheme 
													SET		Executed = 0, 
															Obs = NULL, 
															CreationDate=DATEADD(HOUR,-5,GETDATE()) ,
															InitialValidityTariffServDate = ISNULL(@InitialValidityTariffServDate,DATEADD(HOUR,-5,GETDATE()))
													WHERE	IdContract = @IdContract AND IdTariffScheme = @IdTariffScheme
/*	
begin tran
declare @IdContractOut int,	@Message varchar(50),@Flag bit
exec dbo.sp_Create_Contract 4964,16712,'CORPORACION HOSPITALARIA JUAN CIUDAD.',4,3351,609,'2024-05-01',2,0,99942566800,
							0,'2021-12-03','2024-12-31',2,null,null,1,0,0,0,
							null,null,null,null,null,null,null,null,null,null,
							null,null,null,2,null,null,null,null,2,null,
							null,null,
							@IdContractOut, @Message, @Flag 
select @IdContractOut, @Message , @Flag

rollback
*/
--print @InitialValidityTariffServDate							
												END
											ELSE
												BEGIN
													INSERT INTO TB_ContractTariffScheme (IdContract, IdTariffScheme, InitialValidityTariffServDate, CreationDate, IdUserAction)
													VALUES (@IdContract, @IdTariffScheme, ISNULL(@InitialValidityTariffServDate,DATEADD(HOUR,-5,GETDATE())), DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
				
												END
										END
									ELSE
										BEGIN
											UPDATE TB_Contract
												SET IdTariffScheme = @IdTariffScheme,
													InitialValidityTariffServDate = ISNULL(@InitialValidityTariffServDate,DATEADD(HOUR,-5,GETDATE()))
											WHERE IdContract = @IdContract

										--	INSERT INTO TB_ContractTariffScheme (IdContract, IdTariffScheme, InitialValidityTariffServDate, CreationDate, IdUserAction)
										--	VALUES (@IdContract, @IdTariffScheme, ISNULL(@InitialValidityTariffServDate,DATEADD(HOUR,-5,GETDATE())), DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

										END
								END
							ELSE
								BEGIN
									IF (select COUNT(*) from TB_ContractTariffScheme where idcontract = @IdContract and IdTariffScheme = @IdTariffScheme)>0
										BEGIN
											UPDATE	TB_ContractTariffScheme 
											SET		Executed = 0, 
													Obs = NULL, 
													CreationDate=DATEADD(HOUR,-5,GETDATE()) ,
													InitialValidityTariffServDate = ISNULL(@InitialValidityTariffServDate,DATEADD(HOUR,-5,GETDATE()))
											WHERE	IdContract = @IdContract AND IdTariffScheme = @IdTariffScheme
								
										END
									ELSE
										BEGIN
											INSERT INTO TB_ContractTariffScheme (IdContract, IdTariffScheme, InitialValidityTariffServDate, CreationDate, IdUserAction)
											VALUES (@IdContract, @IdTariffScheme, ISNULL(@InitialValidityTariffServDate,DATEADD(HOUR,-5,GETDATE())), DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
				
										END
								END
							SET @Message = 'Successfully updated contract'
							SET @Flag = 1
							SET @IdContractOut = @IdContract 
						END      
					ELSE
						BEGIN
							SET @Message = 'Contract name already exists'
							SET @Flag = 0
							SET @IdContractOut = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Contract number already exists'
					SET @Flag = 0
					SET @IdContractOut = 0
				END
		END
END
GO
