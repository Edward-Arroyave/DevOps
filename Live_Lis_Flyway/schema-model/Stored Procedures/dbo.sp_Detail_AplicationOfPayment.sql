SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/03/2023
-- Description: Procedimiento almacenado para consultar aplicación de pagos.
-- =============================================
--EXEC [sp_Detail_AplicationOfPayment] 40,'2023-03-01','2023-03-22'
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_AplicationOfPayment]
(
	@IdInstallmentContract int,
	@IdContrato int,
	@InitialDate date,
	@FinalDate date
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT D.CompanyName, C.ContractName, MIN(InstallmentBalance) AS InstallmentBalance
	FROM TR_InstallmentContract_PreBilling A
	INNER JOIN TR_InstallmentContract_Contract B
		ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract
	INNER JOIN TB_Contract C
		ON C.IdContract = B.IdContract
	INNER JOIN TB_Company D
		ON D.IdCompany = C.IdCompany
	WHERE B.IdInstallmentContract = @IdInstallmentContract
		AND B.IdContract = @IdContrato
		AND A.Active = 'True'
		AND B.Active = 'True'
	GROUP BY D.CompanyName, C.ContractName

    SELECT D.IdInstallmentContract, C.IdElectronicBilling, C.InvoiceNumber, C.TotalValue AS InvoiceAmount, SUM(A.PreBillingValue) AS CrossAmount, CONVERT(DATE,A.CreationDate) As CrossingDate, C.InvoiceFile
	FROM TR_InstallmentContract_PreBilling A
	INNER JOIN TB_PreBilling B
		ON B.IdPreBilling = A.IdPreBilling
	INNER JOIN TB_ElectronicBilling C
		ON C.IdElectronicBilling = B.IdElectronicBilling
	INNER JOIN TR_InstallmentContract_Contract D
		ON D.IdInstallmentContract_Contract=A.IdInstallmentContract_Contract
	WHERE A.Active = 'True'
		AND D.IdInstallmentContract = @IdInstallmentContract
		AND D.IdContract = @IdContrato
		AND ((CONVERT(varchar(10),A.CreationDate,20) BETWEEN CONVERT(VARCHAR(10),@InitialDate,20) AND CONVERT(VARCHAR(10),@FinalDate,20))
		AND (@InitialDate != '' OR @FinalDate != '')   
			OR (@InitialDate = '' AND @FinalDate = ''))
	GROUP BY D.IdInstallmentContract, C.IdElectronicBilling, C.InvoiceNumber, C.TotalValue, A.CreationDate, C.InvoiceFile
END
GO
