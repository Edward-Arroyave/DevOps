SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 29/08/2022
-- Description: Procedimiento almacenado para anular abono a entidad.
-- =============================================
/*
DECLARE @Message varchar(50), @Flag bit
EXEC [sp_Annul_InstallmentContract] 46,'',2
SELECT  @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Annul_InstallmentContract]
(
    @IdInstallmentContract int,
	@CancellationReason varchar(max),
    @IdUserAction int,
    @Message varchar(50) out,
    @Flag bit out
)
AS
    DECLARE @IdContract int, @IdContractType int, @ContractAmount bigint, @Aux int = 1, @Exit bit = 0
    DECLARE @InstallmentContractContract table (Id int identity, IdInstallmentContract int, IdContract int, ContractAmount bigint )
BEGIN

    SET NOCOUNT ON  

	DECLARE @IDCOUNTRY INT, @SYSTEMDATE DATETIME

	SELECT @IDCOUNTRY= IDCOUNTRY FROM TB_BUSINESS

	SELECT @SYSTEMDATE = (GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE TIMEZONE)
	FROM TB_COUNTRY
	WHERE IDCOUNTRY = @IDCOUNTRY;
			
			INSERT INTO @InstallmentContractContract (IdInstallmentContract, IdContract, ContractAmount)
   			SELECT	IdInstallmentContract, IdContract, ContractAmount
   			FROM	TR_InstallmentContract_Contract
   			WHERE	IdInstallmentContract = @IdInstallmentContract  

			WHILE @Aux <= (SELECT TOP 1 Id FROM @InstallmentContractContract WHERE Id = @Aux ORDER BY Id)
    		   		BEGIN
					SET @IdContract = (SELECT IdContract FROM @InstallmentContractContract WHERE Id = @Aux)

    		       		IF (SELECT	(b.ContractAmount- a.ContractAmount)
   						FROM	@InstallmentContractContract a
								INNER JOIN TB_Contract b on a.IdContract = b.IdContract
   						WHERE	IdInstallmentContract = @IdInstallmentContract
						AND		a.IdContract=@IdContract)<0
						begin
							set @Exit = 1
							set @Aux = (SELECT count(*) FROM @InstallmentContractContract )+1
						end
						SET @Aux = @Aux + 1
    		        END		

		set @Aux = 1

		IF  @Exit =0				

				BEGIN
					if (SELECT COUNT(*) FROM	TR_InstallmentContract_Contract WHERE	IdInstallmentContract = @IdInstallmentContract )>=1
						begin
							if NOT EXISTS (select Visible from TB_InstallmentContract WHERE IdInstallmentContract = @IdInstallmentContract and isnull(visible,1) = (0))
								BEGIN
									IF NOT EXISTS (	SELECT	IdInstallmentContract 
													FROM	TR_InstallmentContract_Contract B 
															INNER JOIN TR_InstallmentContract_PreBilling C ON C.IdInstallmentContract_Contract = B.IdInstallmentContract_Contract 
													WHERE	B.IdInstallmentContract = @IdInstallmentContract)
										BEGIN
										
											UPDATE TB_InstallmentContract
    		   									SET CancellationReason = @CancellationReason,
													Active = 'False',
    		       									UpdateDate = @SYSTEMDATE,
    		       									IdUserCanceled = @IdUserAction
   											WHERE IdInstallmentContract = @IdInstallmentContract     
			 
											UPDATE TR_InstallmentContract_Contract
    		   									SET Active = 'False',
    		       									UpdateDate = @SYSTEMDATE,
    		       									IdUserAction = @IdUserAction
   											WHERE IdInstallmentContract = @IdInstallmentContract     
			
											UPDATE A
    		   									SET A.Active = 'False',
    		       									A.UpdateDate = @SYSTEMDATE,
    		       									A.IdUserAction = @IdUserAction
   											--SELECT *
   											FROM TR_InstallmentContract_PreBilling A
   											INNER JOIN TR_InstallmentContract_Contract B
    		   									ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract
   											WHERE B.IdInstallmentContract = @IdInstallmentContract 


   					/*						INSERT INTO @InstallmentContractContract (IdInstallmentContract, IdContract, ContractAmount)
   											SELECT IdInstallmentContract, IdContract, ContractAmount
   											FROM TR_InstallmentContract_Contract
   											WHERE IdInstallmentContract = @IdInstallmentContract     
					*/
											---- Cuando tipo de contrato es facturación por abono = Valor de abono se resta a monto contrato.
   											WHILE @Aux <= (SELECT TOP 1 Id FROM @InstallmentContractContract WHERE Id = @Aux ORDER BY Id)
    		   									BEGIN
    		       									SET @IdContract = (SELECT IdContract FROM @InstallmentContractContract WHERE Id = @Aux)
    		       									SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)          

													--- Cuando tipo de contrato es facturación por abono = Valor de abono se resta a monto contrato.
    		       									IF (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract) = 3
    		           									BEGIN
    		               									UPDATE B    
    		                   									SET B.ContractAmount = B.ContractAmount - A.ContractAmount
    		               									--SELECT B.ContractAmount, A.ContractAmount
    		               									FROM @InstallmentContractContract A
    		               									INNER JOIN TB_Contract B
    		                   									ON B.IdContract = A.IdContract
    		               									WHERE B.IdContract = @IdContract
    		                   									AND A.IdContract = @IdContract
																AND A.Id = @Aux
    		           									END           
													SET @Aux = @Aux + 1
    		   									END     

											SET @Message = 'Contract installment successfully annul'
   											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'It is not possible to anunul contract installment'
											SET @Flag = 0
										END
								END
							ELSE 
								BEGIN
									SET @Message = 'It is not possible to anunul contract installment'
									SET @Flag = 0
								END
						end
					else
						BEGIN
							SET @Message = 'El abono ya se encuentra anulado'
						SET @Flag = 0
						END
				END
				ELSE
				BEGIN
					SET @Message = 'No es posible anular por resultante negativo'
					SET @Flag = 0
				END
END
GO
