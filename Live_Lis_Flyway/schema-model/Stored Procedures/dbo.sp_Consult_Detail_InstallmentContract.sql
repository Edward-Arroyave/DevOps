SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/03/2023
-- Description: Procedimiento almacenado para detalle abono a entidad.
-- =============================================
--EXEC [sp_Consult_Detail_InstallmentContract] ''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Detail_InstallmentContract]
(
    @IdInstallmentContract int
)
AS
BEGIN
    SET NOCOUNT ON     SELECT A.IdInstallmentContract, A.IdCompany, C.CompanyName, 
        A.InstallmentContractNumber, A.IdPaymentMethod, E.PaymentMethodName, A.ReferenceNumber, A.IdBankAccount, CONCAT_WS(' ', F.Bank, F.Account) AS BankAccount, A.ContractAmount
    FROM TB_InstallmentContract A
    INNER JOIN TB_Company C
        ON C.IdCompany = A.IdCompany
    INNER JOIN TB_PaymentMethod E
        ON E.IdPaymentMethod = A.IdPaymentMethod
    LEFT JOIN TB_BankAccount F
        ON F.IdBankAccount = A.IdBankAccount
    WHERE A.IdInstallmentContract = @IdInstallmentContract

    SELECT B.IdInstallmentContract_Contract, D.ContractCode, D.ContractName, B.ContractAmount
    FROM TB_InstallmentContract A
    INNER JOIN TR_InstallmentContract_Contract B
        ON B.IdInstallmentContract = A.IdInstallmentContract
    INNER JOIN TB_Contract D
        ON D.IdContract = B.IdContract
    WHERE A.IdInstallmentContract = @IdInstallmentContract 
END
GO
