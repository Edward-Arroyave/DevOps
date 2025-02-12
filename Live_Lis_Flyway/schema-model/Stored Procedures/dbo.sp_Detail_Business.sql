SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez 
-- Create Date: 07/02/2023
-- Description: Procedimiento almacenado para listar los datos de una Empresa creada.
/*
exec  [dbo].[sp_Detail_Business]
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Business]
AS
BEGIN 
	SET NOCOUNT ON

	SELECT	A.IdBusiness, A.Name, a.BusinessName, A.Email, a.Address, A.IdCity, F.CityName, A.IdCountry, G.CountryName, D.IdDepartment, D.DepartmentName, a.Logo, 
			A.NIT, A.PostalCode, A.TelephoneNumber, A.DataProcessingDocument,a.DataProcessingDocumentName, A.VerificationDigit,
			STUFF((SELECT ', ' +CONVERT(varchar(5),IdFiscalResponsibility)
					FROM TR_Business_FiscalResponsibility C
					WHERE C.IdBusiness = A.IdBusiness
						AND C.Active = 'True'
					FOR XML PATH('')),1,1,'') IdFiscalResponsibility,
			STUFF((SELECT '| ' +CONVERT(varchar(MAX), b.FiscalResponsibility)
					FROM TR_Business_FiscalResponsibility C
					INNER JOIN TB_FiscalResponsibility B
					ON B.IdFiscalResponsibility = C.IdFiscalResponsibility
					WHERE C.IdBusiness = A.IdBusiness
						AND C.Active = 'True'
					FOR XML PATH('')),1,1,'') FiscalResponsibility,
			A.Interoperability, A.IVA, A.IVApercentage, A.IdAttentionCenter, AC.AttentionCenterName, A.IdIdentificationType, 
			CONCAT(isnull(IT.IdentificationTypeCode,''), ' - ', isnull(IT.IdentificationTypeDesc,'')) AS IdentificationTypeName,
			A.RFC
	FROM TB_Business A
	left JOIN TB_City F
		ON F.IdCity = A.IdCity
	left JOIN TB_Department D
		ON D.IdDepartment = F.IdDepartment 
	left JOIN TB_Country G
		ON G.IdCountry = A.IdCountry
	LEFT JOIN TB_IdentificationType IT 
		ON IT.IdIdentificationType = A.IdIdentificationType 
	LEFT JOIN TB_AttentionCenter AC 
		ON A.IdAttentionCenter = AC.IdAttentionCenter
END

GO
