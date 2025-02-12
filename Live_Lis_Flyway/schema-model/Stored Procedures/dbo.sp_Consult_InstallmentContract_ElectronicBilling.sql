SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 04/10/2022
-- Description: Procedimiento almacenado para consultar facturas con las que se ha cruzado un abono y montos correspondientes.
-- =============================================
-- [sp_Consult_InstallmentContract_ElectronicBilling] 53
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_InstallmentContract_ElectronicBilling]
(
	@IdInstallmentContract int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdInstallmentContract, A.InstallmentContractNumber, A.ContractAmount, B2.InstallmentBalance, D.InvoiceNumber, B.PreBillingValue - B.PreBillingBalance CrossValue
	FROM TB_InstallmentContract A
	INNER JOIN TR_InstallmentContract_Contract E
        ON E.IdInstallmentContract = A.IdInstallmentContract
	INNER JOIN TR_InstallmentContract_PreBilling B
		ON B.IdInstallmentContract_Contract = E.IdInstallmentContract_Contract
	INNER JOIN (
				SELECT B.IdInstallmentContract, MIN(A.InstallmentBalance) AS InstallmentBalance
				FROM TR_InstallmentContract_PreBilling A
				INNER JOIN TR_InstallmentContract_Contract B
                    ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract
                WHERE B.IdInstallmentContract = @IdInstallmentContract
                GROUP BY B.IdInstallmentContract
				) B2
		ON B2.IdInstallmentContract = E.IdInstallmentContract
	INNER JOIN TB_PreBilling C
		ON C.IdPreBilling = B.IdPreBilling
	INNER JOIN TB_ElectronicBilling D
		ON D.IdElectronicBilling = C.IdElectronicBilling
	WHERE A.IdInstallmentContract = @IdInstallmentContract
END
GO
