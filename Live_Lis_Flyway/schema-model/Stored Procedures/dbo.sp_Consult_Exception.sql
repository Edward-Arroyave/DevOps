SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 18/01/2023
-- Description: Procedimiento almacenado para consultar excepciones creadas a contratos.
-- =============================================
--EXEC [sp_Consult_Exception]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Exception]
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT C.IdCompany, C.CompanyName, B.IdContract, B.ContractCode, B.ContractName
	FROM TB_ContractException A
	INNER JOIN TB_Contract B
		ON B.IdContract = A.IdContract
	INNER JOIN TB_Company C
		ON C.IdCompany = B.IdCompany
	WHERE A.Active = 'True'
	ORDER BY C.IdCompany,  B.IdContract
END
GO
