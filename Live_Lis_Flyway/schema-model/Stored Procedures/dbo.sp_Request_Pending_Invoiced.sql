SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 02/08/2023
-- Description: Procedimiento almacenado para retornar las solicitudes pendientes por facturar
-- =============================================
-- EXEC [dbo].[sp_Request_Pending_Invoiced]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Request_Pending_Invoiced]
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT C.IdBillingOfSale, C.BillingOfSaleDate,
		CASE WHEN A.FamilyGroup IS NOT NULL THEN A.FamilyGroup ELSE A.RequestNumber END AS RequestNumber, 
		A.IdContract, D.IdContractType, D.ContractCode, D.ContractName, D.InitialValidity, D.ExpirationDate, D.IdContractOdoo,
		M.AttentionCenterCode, M.AttentionCenterName,
	    CASE WHEN A.IdAdmissionSource IN (4,5) THEN C.IdPatient WHEN A.IdAdmissionSource IN (1,2) THEN A.IdPatient END AS Patient_Vat, 
		N.AdmissionSource, 
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN K.IdentificationNumber WHEN L.IdPersonInCharge IS NOT NULL THEN L.IdentificationNumber ELSE CONVERT(varchar(10),C.IdPatient) END AS IdentificationNumber,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN O.IdentificationTypeCode_EB WHEN L.IdPersonInCharge IS NOT NULL THEN O2.IdentificationTypeCode_EB ELSE CONVERT(varchar(10),C.IdPatient) END AS IdentificationTypeCode_EB,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN K.Name WHEN A.IdPersonInCharge IS NOT NULL THEN L.FullName ELSE CONVERT(varchar(10),C.IdPatient) END AS ClientName,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN K.LastName WHEN A.IdPersonInCharge IS NOT NULL THEN L.FullName ELSE CONVERT(varchar(10),C.IdPatient) END AS ClientLastName,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN P.CityCode WHEN A.IdPersonInCharge IS NOT NULL THEN P2.CityCode ELSE CONVERT(varchar(10),C.IdPatient) END AS CityCode,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN K.TelephoneNumber WHEN A.IdPersonInCharge IS NOT NULL THEN L.TelephoneNumber ELSE CONVERT(varchar(10),C.IdPatient) END AS TelephoneNumber,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN K.Email WHEN A.IdPersonInCharge IS NOT NULL THEN L.Email ELSE CONVERT(varchar(10),C.IdPatient) END AS Email,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN K.Address WHEN A.IdPersonInCharge IS NOT NULL THEN L.Address ELSE CONVERT(varchar(10),C.IdPatient) END AS Address,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN C.IdThirdPerson WHEN A.IdPersonInCharge IS NOT NULL THEN NULL ELSE CONVERT(varchar(10),C.IdPatient) END AS TypeOfPerson,
	    CASE WHEN C.IdThirdPerson IS NOT NULL THEN 'Tercera persona' WHEN A.IdPersonInCharge IS NOT NULL THEN 'Acompañante' ELSE 'Paciente' END AS PersonType,
		D.ContractName,
		F.IdExam, G.ExamCode, G.ExamName, F.Value, B.TotalValuePatient AS TotalValue
	FROM TB_Request A
	INNER JOIN TR_BillingOfSale_Request B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TB_Contract D
		ON D.IdContract = A.IdContract
	INNER JOIN TB_ContractType E
		ON E.IdContractType = D.IdContractType
	INNER JOIN TR_Request_Exam F
		ON F.IdRequest = A.IdRequest
			AND F.Active = 'True'
			AND F.Value IS NOT NULL
	INNER JOIN TB_Exam G
		ON G.IdExam = F.IdExam
	INNER JOIN TB_AttentionCenter M
		ON M.IdAttentionCenter = A.IdAttentionCenter
	INNER JOIN TB_AdmissionSource N
		ON N.IdAdmissionSource = A.IdAdmissionSource
	LEFT JOIN TB_ThirdPerson K
		ON K.IdThirdPerson = C.IdThirdPerson
	LEFT JOIN TB_City P
		ON P.IdCity = K.IdCity
	LEFT JOIN TB_IdentificationType O
		ON O.IdIdentificationType = K.IdIdentificationType
	LEFT JOIN TB_PersonInCharge L
		ON L.IdPersonInCharge = A.IdPersonInCharge
	LEFT JOIN TB_IdentificationType O2
		ON O2.IdIdentificationType = L.IdIdentificationType
	LEFT JOIN TB_City P2
		ON P2.IdCity = L.IdCity
	WHERE E.IdContractType not in (1,2,3,4,5)
		AND C.BillingOfSaleDate > '2024-03-10' AND C.BillingOfSaleDate < '2024-04-01'
		AND C.IdElectronicBilling IS NULL
		AND C.IdBillingOfSaleStatus != 7

	UNION ALL
	
	SELECT DISTINCT C.IdBillingOfSale, C.BillingOfSaleDate, A.RequestNumber, 
		D.IdContract, E.IdContractType, D.ContractCode, D.ContractName, D.InitialValidity, D.ExpirationDate, D.IdContractOdoo, L.AttentionCenterCode, L.AttentionCenterName, 
		CASE WHEN A.IdAdmissionSource IN (4,5) THEN C.IdPatient WHEN A.IdAdmissionSource IN (1,2) THEN A.IdPatient END AS Patient_Vat, M.AdmissionSource,
		K.NIT, N.IdentificationTypeCode_EB, K.CompanyName, NULL, O.CityCode, K.TelephoneNumber, D.ElectronicUser, K.Address, NULL, 'Entidad-Tercero', D.ContractName,
		F.IdExam, G.ExamCode, G.ExamName, F.Value, B.TotalValueCompany
	FROM TB_Request A
	INNER JOIN TR_BillingOfSale_Request B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TB_Contract D
		ON D.IdContract = A.IdContract
	INNER JOIN TB_ContractType E
		ON E.IdContractType = D.IdContractType
	INNER JOIN TR_Request_Exam F
		ON F.IdRequest = A.IdRequest
			AND F.Active = 'True'
			AND F.Value IS NOT NULL
	INNER JOIN TB_Exam G
		ON G.IdExam = F.IdExam
	INNER JOIN TB_Company K
		ON K.IdCompany = D.IdCompany
	INNER JOIN TB_AttentionCenter L
		ON L.IdAttentionCenter = A.IdAttentionCenter
	INNER JOIN TB_AdmissionSource M
		ON M.IdAdmissionSource = A.IdAdmissionSource
	LEFT JOIN TB_IdentificationType N
		ON N.IdIdentificationType = K.IdIdentificationType
	LEFT JOIN TB_City O	
		ON O.IdCity = K.IdCity
	LEFT JOIN TB_ElectronicBilling P
		ON P.IdElectronicBilling = C.IdElectronicBilling
	WHERE E.IdContractType = 3
		AND C.BillingOfSaleDate > '2024-03-10' AND C.BillingOfSaleDate < '2024-04-01'
		AND (C.IdElectronicBilling IS NULL OR C.PreBilling = 0 OR P.Active=0 OR P.IdInvoiceStatus=3)
		AND C.IdBillingOfSaleStatus != 7 AND A.IdRequestStatus != 2
	ORDER BY C.BillingOfSaleDate ASC
END
GO
