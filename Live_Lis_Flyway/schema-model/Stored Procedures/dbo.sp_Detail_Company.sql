SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/04/2022
-- Description: Procedimiento almacenado para retornar los datos de entidad especifico.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Company]
(
	@IdCompany int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdCompany FROM TB_Company WHERE IdCompany = @IdCompany)
		BEGIN
			SELECT A.IdCompany, A.CompanyCode, A.CompanyName, A.IdEconomicActivity, A.NIT, A.VerificationDigit, A.Address, A.TelephoneNumber, A.Email, A.CreditQuota, A.CreditBalance, 
					A.IdCommercialZone, B.IdDepartment, A.IdCity, A.PortfolioContact, A.PortfolioContactTelephoneNumber, A.PolicyNumber, A.BillingContact, 
				STUFF((SELECT ', ' + CONVERT(VARCHAR(5), C.IdFiscalResponsibility)
						FROM TR_Company_FiscalResponsibility C
						WHERE C.IdCompany = A.IdCompany
							AND C.Active = 'True'
						FOR XML PATH('')),1,1,'') IdFiscalResponsibility,
				STUFF((SELECT ', ' + CONVERT(VARCHAR(50), D.FiscalResponsibility)
						FROM TR_Company_FiscalResponsibility C
						INNER JOIN TB_FiscalResponsibility D
							ON D.IdFiscalResponsibility = C.IdFiscalResponsibility
						WHERE C.IdCompany = A.IdCompany
							AND C.Active = 'True'
						FOR XML PATH('')),1,1,'') FiscalResponsibility,
				A.ValidateCreditQuota, A.AttentPreRequisite, A.AttentionPreRequisite, A.BillRequirement, A.BillingRequirements, A.IdCompanySegment, C.CompanySegment, A.IdCompanySubSegment, 
				C2.CompanySegment AS CompanySubSegment, A.IdMarketGroup, D.MarketGroup, A.TelephoneNumberQuality, A.CompanyIntranet, A.IdIdentificationType
			FROM TB_Company A
			LEFT JOIN TB_City B
				ON B.IdCity = A.IdCity
			LEFT JOIN TB_CompanySegment C
				ON C.IdCompanySegment = A.IdCompanySegment
			LEFT JOIN TB_CompanySegment C2
				ON C2.IdCompanySegment = A.IdCompanySubSegment
			LEFT JOIN TB_MarketGroup D
				ON D.IdMarketGroup = A.IdMarketGroup
			WHERE A.IdCompany = @IdCompany

			SET @Message = 'Company found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Company does not exists'
			SET @Flag = 0
		END
END

GO
