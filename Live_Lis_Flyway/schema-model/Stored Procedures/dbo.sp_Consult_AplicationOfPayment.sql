SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/03/2023
-- Description: Procedimiento almacenado para consultar aplicación de pagos.
-- =============================================
--EXEC [sp_Consult_AplicationOfPayment] '','','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_AplicationOfPayment]
(
	@IdCompany int,
	@IdContract int,
	@InitialDate date,
	@FinalDate date
)
AS
BEGIN
    SET NOCOUNT ON

    SELECT A.IdInstallmentContract, A.InstallmentContractNumber, A.CreationDate AS InstallmentContractDate, D.ContractAmount AS InstallmentContractAmount, B.PaymentMethodName, A.IdCompany, D.IdContract
	FROM TB_InstallmentContract A
	INNER JOIN TR_InstallmentContract_Contract D
		ON A.IdInstallmentContract=D.IdInstallmentContract
	INNER JOIN TB_PaymentMethod B
		ON B.IdPaymentMethod = A.IdPaymentMethod
	INNER JOIN TB_Contract C
		ON C.IdContract = D.IdContract
	WHERE A.Active = 'True'
		AND C.Active = 'True'
		AND C.IdCompany = @IdCompany
		AND C.IdContract = @IdContract
		AND ((CONVERT(varchar(10),A.CreationDate,20) BETWEEN CONVERT(VARCHAR(10),@InitialDate,20) AND CONVERT(VARCHAR(10),@FinalDate,20))
		AND (@InitialDate != '' OR @FinalDate != '')   
			OR (@InitialDate = '' AND @FinalDate = ''))
END
GO
