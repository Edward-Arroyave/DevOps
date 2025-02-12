SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 27/09/2023
-- Description: Procedimiento almacenado para retornar información de paciente.
-- =============================================
--EXEC [sp_Consult_Info_Patient] 91
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Info_Patient]
(
	@IdPatient int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdPatient, A.IdIdentificationType, B.IdentificationTypeCode, B.IdentificationTypeDesc, A.IdentificationNumber, A.IdPatientOdoo,
		CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) AS PatientName, A.IdNationality, D.CountryName AS Nationality, A.BirthDate, DATEDIFF(YEAR, A.BirthDate, GETDATE()) Age, A.IdBiologicalSex,
		C.BiologicalSex, A.IdGenderIdentity, T.GenderIdentity, C.Abbreviation AS BiologicalSex, A.IdCountry, E.CountryName AS Country,
		F.IdDepartment, F.DepartmentName, A.IdResidenceCity, G.CityName, G.CityCode, A.IdResidenceArea, O.ResidenceArea, A.IdNeighborhood, J.Neighborhood, K.IdLocality, K.Locality, 
		A.IdSocialStratum, L.SocialStratum, A.Address, A.TelephoneNumber, A.TelephoneNumber2, A.Email, A.IdOccupation, I.Occupation, A.IdEthnicCommunity, P.EthnicCommunity, A.IdEthnicity,
		Q.Ethnicity, A.IdDisabilityCategory, R.DisbilityCategory, A.IdCivilStatus, H.CivilStatus, A.Pregnancy, A.IdHealthProviderEntity, CONCAT_WS('-', S.SocialSecurityCompanyCode, S.SocialSecurityCompanyName) CompanyName,
		A.IdAffiliationType, M.AffiliationType, A.IdAffiliationCategory, N.AffiliationCategory, A.PhotoNameContainer, A.DataProcessingPolicySignature, A.IdThirdPersonOdoo, A.Active_LIS AS Active
	FROM carehis.TB_Patient_Ext A 
	INNER JOIN carehis.TB_IdentificationType_Ext B 
		ON B.IdIdentificationType = A.IdIdentificationType
	INNER JOIN carehis.TB_BiologicalSex_Ext C 
		ON C.IdBiologicalSex = A.IdBiologicalSex
	LEFT JOIN carehis.TB_Country_Ext D 
		ON D.IdCountry = A.IdNationality 
	LEFT JOIN carehis.TB_Country_Ext E 
		ON E.IdCountry = A.IdCountry 
	LEFT JOIN carehis.TB_City_Ext G 
		ON G.IdCity = A.IdResidenceCity 
	LEFT JOIN carehis.TB_Department_Ext F 
		ON F.IdDepartment = G.IdDepartment 
	LEFT JOIN carehis.TB_CivilStatus_Ext H 
		ON H.IdCivilStatus = A.IdCivilStatus 
	LEFT JOIN carehis.TB_Occupation_Ext I 
		ON I.IdOccupation = A.IdOccupation 
	LEFT JOIN carehis.TB_Neighborhood_Ext J 
		ON J.IdNeighborhood = A.IdNeighborhood 
	LEFT JOIN carehis.TB_Locality_Ext K 
		ON K.IdLocality = J.IdLocality 
	LEFT JOIN carehis.TB_SocialStratum_Ext L 
		ON L.IdSocialStratum = A.IdSocialStratum 
	LEFT JOIN carehis.TB_AffiliationType_Ext M 
		ON M.IdAffiliationType = A.IdAffiliationType 
	LEFT JOIN carehis.TB_AffiliationCategory_Ext N 
		ON N.IdAffiliationCategory = A.IdAffiliationCategory 
	LEFT JOIN carehis.TB_ResidenceArea_Ext O 
		ON O.IdResidenceArea = A.IdResidenceArea 
	LEFT JOIN carehis.TB_EthnicCommunity_Ext P 
		ON P.IdEthnicCommunity = A.IdEthnicCommunity 
	LEFT JOIN carehis.TB_Ethnicity_Ext Q 
		ON Q.IdEthnicity = A.IdEthnicity 
	LEFT JOIN carehis.TB_DisabilityCategory_Ext R 
		ON R.IdDisabilityCategory = A.IdDisabilityCategory
	LEFT JOIN carehis.TB_SocialSecurityCompany_Ext S 
		ON S.IdSocialSecurityCompany = A.IdHealthProviderEntity
	LEFT JOIN carehis.TB_GenderIdentity_Ext T 
		ON T.IdGenderIdentity = A.IdGenderIdentity
	WHERE A.IdPatient = @IdPatient
END
GO
