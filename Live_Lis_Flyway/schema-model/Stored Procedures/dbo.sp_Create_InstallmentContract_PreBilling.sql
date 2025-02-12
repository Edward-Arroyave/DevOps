SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/09/2022
-- Description: Procedimiento almacenado para consultar y cruzar abono con factura.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_InstallmentContract_PreBilling]
(
	@IdContract int,
	@IdPreBilling int,
	@IdUserAction int,
	@PreBillingBalance bigint = NULL,
	@PreBillingBalanceOut bigint out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @TotalValue bigint, @IdInstallmentContract_Contract int, @InstallmentContractValue bigint, @InstallmentBalance bigint, @IdInstallmentContract_PreBilling int
BEGIN
    SET NOCOUNT ON
	
	-- @PreBillingBalance IS NULL → Retorna el valor total del pre factura 
	IF @PreBillingBalance IS NULL
		BEGIN
			SET @TotalValue = (SELECT SUM(C.TotalValueCompany) FROM TB_PreBilling A INNER JOIN TR_PreBilling_BillingOfSale B ON B.IdPreBilling = A.IdPreBilling INNER JOIN TB_BillingOfSale C ON C.IdBillingOfSale = B.IdBillingOfSale WHERE A.IdPreBilling = @IdPreBilling)

			IF EXISTS (SELECT IdInstallmentContract_PreBilling FROM TR_InstallmentContract_PreBilling WHERE IdPreBilling=@IdPreBilling AND Active=1)
			BEGIN 
				UPDATE TR_InstallmentContract_PreBilling SET Active = 0 WHERE IdPreBilling=@IdPreBilling
				UPDATE A	
						SET Crossway = 'False'
					FROM TR_InstallmentContract_Contract A
					INNER JOIN TR_InstallmentContract_PreBilling B
						ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract
					WHERE B.IdPreBilling = @IdPreBilling
			END
		END
	--- @PreBillingBalance IS NOT NULL → Retorna el valor del saldo de la  pre factura 
	ELSE
		BEGIN
			SET @TotalValue = @PreBillingBalance
		END

	IF EXISTS (SELECT IdInstallmentContract FROM TR_InstallmentContract_Contract WHERE IdContract = @IdContract AND Active = 'True' AND Crossway = 'False')
		BEGIN
			SET @IdInstallmentContract_Contract = (SELECT TOP 1 IdInstallmentContract_Contract FROM TR_InstallmentContract_Contract WHERE IdContract = @IdContract AND Active = 'True' AND Crossway = 'False' ORDER BY 1 ASC)
			SET @InstallmentContractValue = (SELECT A.ContractAmount - ISNULL(SUM(PreBillingValue - PreBillingBalance),0) 
												FROM TR_InstallmentContract_Contract A
												LEFT JOIN TR_InstallmentContract_PreBilling B
													ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract
														AND B.Active = 'True'
												WHERE A.IdInstallmentContract_Contract = @IdInstallmentContract_Contract
												GROUP BY A.ContractAmount)

			IF @InstallmentContractValue >= @TotalValue
				BEGIN
					INSERT INTO TR_InstallmentContract_PreBilling (IdInstallmentContract_Contract, IdPreBilling, InstallmentValue, PreBillingValue, InstallmentBalance, PreBillingBalance, Active, IdUserAction, CreationDate)
					VALUES (@IdInstallmentContract_Contract, @IdPreBilling, @InstallmentContractValue, @TotalValue, (@InstallmentContractValue - @TotalValue), 0, 1, @IdUserAction, DATEADD(HOUR,-5,GETDATE()))
				
					SET @IdInstallmentContract_PreBilling = SCOPE_IDENTITY ()

					UPDATE A
						SET A.Crossway = CASE WHEN Total = A.ContractAmount THEN 'True' ELSE 'False' END
					FROM TR_InstallmentContract_Contract A
					INNER JOIN (
								SELECT A.IdInstallmentContract_Contract, SUM(B.PreBillingValue - B.PreBillingBalance) as Total
								FROM TR_InstallmentContract_Contract A
								INNER JOIN TR_InstallmentContract_PreBilling B
									ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract
								WHERE B.IdInstallmentContract_Contract = @IdInstallmentContract_Contract
									AND A.Active = 'True'
									AND B.Active = 'True'
								GROUP BY A.IdInstallmentContract_Contract 
							) B
						ON A.IdInstallmentContract_Contract = B.IdInstallmentContract_Contract
					WHERE A.IdInstallmentContract_Contract = @IdInstallmentContract_Contract

					SET @PreBillingBalanceOut = (SELECT PreBillingBalance FROM TR_InstallmentContract_PreBilling WHERE IdInstallmentContract_PreBilling = @IdInstallmentContract_PreBilling AND Active = 'True')
					SET @Message = 'Successfully cross invoice1'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					INSERT INTO TR_InstallmentContract_PreBilling (IdInstallmentContract_Contract, IdPreBilling, InstallmentValue, PreBillingValue, InstallmentBalance, PreBillingBalance, Active, IdUserAction, CreationDate)
					VALUES (@IdInstallmentContract_Contract, @IdPreBilling, @InstallmentContractValue, @TotalValue, 0, (@TotalValue - @InstallmentContractValue), 1,  @IdUserAction, DATEADD(HOUR,-5,GETDATE()))
					
					SET @IdInstallmentContract_PreBilling = SCOPE_IDENTITY ()

					UPDATE A
						SET A.Crossway = 'True'
					FROM TR_InstallmentContract_Contract A
					INNER JOIN TR_InstallmentContract_PreBilling B
						ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract  
					WHERE B.IdInstallmentContract_Contract = @IdInstallmentContract_Contract
						AND B.Active = 'True'
						AND B.InstallmentBalance = 0

					SET @PreBillingBalanceOut = (SELECT PreBillingBalance FROM TR_InstallmentContract_PreBilling WHERE IdInstallmentContract_PreBilling = @IdInstallmentContract_PreBilling AND Active = 'True')
					SET @Message = 'Successfully cross invoice3'
					SET @Flag = 1
				END

		END
	ELSE
		BEGIN
			SET @Message = 'Contract has no installment'
			SET @Flag = 0
		END
END
GO
