SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 07/02/2023
-- Description: Procedimiento almacenado para consultar información de Empresa.
-- =============================================
-- EXEC [sp_Consult_Business]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Business]
AS
BEGIN
    SET NOCOUNT ON

    SELECT A.IdBusiness, A.BusinessName, A.Name, CONCAT(A.NIT, '-',A.VerificationDigit) AS NIT, A.Email, A.Address, A.PostalCode, A.IdCountry, C.CountryName, B.IdDepartment, D.DepartmentName, A.IdCity, B.CityName, A.TelephoneNumber,
		A.Logo, A.DataProcessingDocument, A.DataProcessingDocumentName
	FROM TB_Business A
	INNER JOIN TB_City B
		ON B.IdCity = A.IdCity
	INNER JOIN TB_Country C
		ON A.IdCountry = C.IdCountry
	INNER JOIN TB_Department D
		ON D.IdDepartment = B.IdDepartment 
END
GO
