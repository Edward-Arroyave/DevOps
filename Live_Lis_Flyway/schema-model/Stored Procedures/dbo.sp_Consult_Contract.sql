SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 04/04/2022
-- Description: Procedimiento almacenado para consultar contratos creados.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Contract]
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdContract, A.ContractCode, A.ContractName, C.CompanyName, B.TariffSchemeName, A.ContractBalance, A.ContractAmount, 
		   A.IdContractAmountType, A.IdContractType, A.InitialValidity, A.ExpirationDate, A.Active
	FROM TB_Contract A
	INNER JOIN TB_TariffScheme B
		ON B.IdTariffScheme = A.IdTariffScheme
	INNER JOIN TB_Company C
		ON C.IdCompany = A.IdCompany
END
GO
