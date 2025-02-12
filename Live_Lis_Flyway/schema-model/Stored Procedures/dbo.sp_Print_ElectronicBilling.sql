SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/09/2022
-- Description: Procedimientos almacenado para retornar información de factura electrónica y/o tiquete de compra.
---- =============================================
/*
DECLARE @Salida varchar(100), @Bandera varchar(100)
EXEC [sp_Print_ElectronicBilling] 13690, @Salida out, @Bandera out
SELECT @Salida, @Bandera
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Print_ElectronicBilling]
(
	@IdBillingOfSale int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdPatient int
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT F.Prefix, F.PrefixCN, F.DetailName,
		CASE WHEN C.FamilyGroup IS NOT NULL THEN C.FamilyGroup ELSE C.RequestNumber END AS RequestNumber, C.IdAdmissionSource, M.DataResponse,
		D.IdContract, D.ContractCode, D.ContractNumber, D.ContractName, D.InitialValidity, D.ExpirationDate, D.IdContractOdoo, CD.OdooPaymentTerm, AM.AttentionModel, MG.MarketGroup,
		K.IdCompany, K.CompanyName, IT.IdentificationTypeCode_EB AS IdentificationThird ,K.NIT, K.Address, D.ElectronicUser, K.PortfolioContact, K.IdPartnerOdoo, L.CityCode AS CityCodeCompany, 
		A.IdPatient, A.IdPatient AS Patient_Vat,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN 'Tercera persona' WHEN C.IdPersonInCharge IS NOT NULL THEN 'Acompañante' ELSE 'Paciente' END AS PersonType, 
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN A.IdThirdPerson WHEN C.IdPersonInCharge IS NOT NULL THEN NULL ELSE CONVERT(varchar(10),A.IdPatient) END AS TypeOfPerson,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.IdentificationNumber WHEN C.IdPersonInCharge IS NOT NULL THEN J.IdentificationNumber ELSE CONVERT(varchar(10),A.IdPatient) END AS IdentificationNumber,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN H.IdentificationTypeCode_EB WHEN C.IdPersonInCharge IS NOT NULL THEN H2.IdentificationTypeCode_EB ELSE CONVERT(varchar(10),A.IdPatient) END AS IdentificationTypeCode_EB,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.Name WHEN C.IdPersonInCharge IS NOT NULL THEN J.FullName ELSE CONVERT(varchar(10),A.IdPatient) END AS ClientName,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.LastName WHEN C.IdPersonInCharge IS NOT NULL THEN J.FullName ELSE CONVERT(varchar(10),A.IdPatient) END AS ClientLastName,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN I.CityCode WHEN C.IdPersonInCharge IS NOT NULL THEN I2.CityCode ELSE CONVERT(varchar(10),A.IdPatient) END AS CityCode,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.TelephoneNumber WHEN C.IdPersonInCharge IS NOT NULL THEN J.TelephoneNumber ELSE CONVERT(varchar(10),A.IdPatient) END AS TelephoneNumber,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.Email WHEN C.IdPersonInCharge IS NOT NULL THEN J.Email ELSE CONVERT(varchar(10),A.IdPatient) END AS Email,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.Address WHEN C.IdPersonInCharge IS NOT NULL THEN J.Address ELSE CONVERT(varchar(10),A.IdPatient) END AS Address, A.Observation,
		STUFF((SELECT DISTINCT ',' + CONVERT(VARCHAR(2),PM.PaymentMethodCode)
			     FROM TB_BillOfSalePayment H
			     INNER JOIN TB_PaymentMethod PM
			         ON PM.IdPaymentMethod = H.IdPaymentMethod
			     WHERE H.IdBillingOfSale = A.IdBillingOfSale
			     FOR XML PATH ('')),1,1,'') PaymentMethodCode,
		D.IdBusinessUnit, BU.BusinessUnit
	FROM TB_BillingOfSale A
	INNER JOIN TR_BillingOfSale_Request B
		ON B.IdBillingOfSale = A.IdBillingOfSale
	INNER JOIN TB_Request C
		ON C.IdRequest = B.IdRequest
	INNER JOIN TB_Contract D
		ON D.IdContract = C.IdContract
	INNER JOIN TB_Company K
		ON D.IdCompany = K.IdCompany
	INNER JOIN TB_IdentificationType IT
		ON K.IdIdentificationType = IT.IdIdentificationType
	INNER JOIN TB_City L
		ON L.IdCity = K.IdCity
	INNER JOIN TB_AttentionCenter E
		ON E.IdAttentionCenter = C.IdAttentionCenter
    	LEFT JOIN TB_DetailBillingResolution F	
		ON F.IdDetailBillingResolution = E.IdDetailBillingResolution
	LEFT JOIN TB_ThirdPerson G
		ON G.IdThirdPerson = A.IdThirdPerson
	LEFT JOIN TB_IdentificationType H
		ON  H.IdIdentificationType = G.IdIdentificationType
	LEFT JOIN TB_City I
		ON I.IdCity = G.IdCity
	LEFT JOIN TB_PersonInCharge J
		ON J.IdPersonInCharge = C.IdPersonInCharge
	LEFT JOIN TB_IdentificationType H2
		ON  H2.IdIdentificationType = J.IdIdentificationType
	LEFT JOIN TB_City I2
		ON I2.IdCity = J.IdCity
	LEFT JOIN TB_ContractDeadline CD 
		ON CD.IdContractDeadline = D.IdContractDeadline
	LEFT JOIN TB_AttentionModel AM 
		ON AM.IdAttentionModel = D.IdAttentionModel
	LEFT JOIN TB_MarketGroup MG 
		ON MG.IdMarketGroup = K.IdMarketGroup
	LEFT JOIN TB_TransactionalLog_CredBank M
		ON M.IdBillingOfSale = A.IdBillingOfSale
	LEFT JOIN TB_BusinessUnit BU
		ON BU.IdBusinessUnit = D.IdBusinessUnit
	WHERE A.IdBillingOfSale = @IdBillingOfSale

	/*
	SELECT A.IdBillingOfSale, --(SELECT TOP 1 G.CUPS) AS CUPS,
	(SELECT TOP 1 G.CUPS from TR_Service_Exam E inner join TB_Service G on E.IdService = G.IdService where E.IdExam = D.IdExam And E.Active=1) AS CUPS,
		D.ExamCode, D.ExamName, C.Value, C.IdGenerateCopay_CM, C.Copay_CM, B.IdPatient
	FROM TB_BillingOfSale A
	INNER JOIN TR_BillingOfSale_Request F
		ON F.IdBillingOfSale = A.IdBillingOfSale
	INNER JOIN TB_Request B
		ON B.IdRequest = F.IdRequest
	INNER JOIN TR_Request_Exam C
		ON C.IdRequest = B.IdRequest
	INNER JOIN TB_Exam D
		ON D.IdExam = C.IdExam
	--LEFT JOIN TR_Service_Exam E
	--	ON D.IdExam = E.IdExam
	--		AND E.Active = 1
	--LEFT JOIN TB_Service G
	--	ON E.IdService = G.IdService
	WHERE A.IdBillingOfSale = @IdBillingOfSale
	*/
	SELECT	distinct A.IdBillingOfSale, --(SELECT TOP 1 G.CUPS) AS CUPS,
		ISNULL(case when TS.Hiring = '' then null else ts.Hiring end,ISNULL(case when G.CUPS = '' then null else G.CUPS end, (	SELECT	TOP 1 G.CUPS 
											from	TR_Service_Exam E 
													inner join TB_Service G on E.IdService = G.IdService 
											where	E.IdExam = D.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,		
		D.ExamCode, D.ExamName, C.Value, C.IdGenerateCopay_CM, C.Copay_CM, B.IdPatient
	FROM TB_BillingOfSale A
		INNER JOIN TR_BillingOfSale_Request F 		ON F.IdBillingOfSale = A.IdBillingOfSale
		INNER JOIN TB_Request B 		ON B.IdRequest = F.IdRequest
		INNER JOIN TR_Request_Exam C 		ON C.IdRequest = B.IdRequest
		INNER JOIN TB_Exam D 		ON D.IdExam = C.IdExam
	--	LEFT JOIN TR_Service_Exam E 		ON D.IdExam = E.IdExam			AND E.Active = 1	
		INNER JOIN TB_CONTRACT H 		on b.idcontract = h.idcontract
		INNER JOIN TB_TariffScheme t 		on h.idtariffscheme = t.idtariffscheme
		INNER JOIN TR_TariffScheme_Service ts		ON t.IdTariffScheme = ts.idtariffscheme and D.IdExam = ts.IdExam and H.idtariffscheme = ts.idtariffscheme
		LEFT JOIN TB_Service G		ON TS.IdService = G.IdService
	WHERE A.IdBillingOfSale = @IdBillingOfSale


	UNION ALL

	SELECT A.IdBillingOfSale, NULL, D.ExamGroupCode, D.ExamGroupName, C.Value, C.IdGenerateCopay_CM, C.Copay_CM, B.IdPatient
	FROM TB_BillingOfSale A
	INNER JOIN TR_BillingOfSale_Request F
		ON F.IdBillingOfSale = A.IdBillingOfSale
	INNER JOIN TB_Request B
		ON B.IdRequest = F.IdRequest
	INNER JOIN TR_Request_Exam C
		ON C.IdRequest = B.IdRequest
	INNER JOIN TB_ExamGroup D
		ON D.IdExamGroup = C.IdExamGroup
	WHERE A.IdBillingOfSale = @IdBillingOfSale

	SET @Message = 'Successfully updated Purchase'
	SET @Flag = 1
END
GO
