SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/09/2022
-- Description: Procedimientos almacenado para retornar información de comprobante de pago.
-- =============================================
--

/*
EXEC [sp_Print_ProofOfPayment] 510306
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Print_ProofOfPayment]
(
	@IdBillingOfSale int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdBillingOfSale, CASE WHEN C.FamilyGroup IS NOT NULL THEN C.FamilyGroup ELSE C.RequestNumber END AS RequestNumber, 
		A.BillingOfSaleDate, A.UpdateDate AS PaymentDate, 
		CASE WHEN A.IdThirdPerson IS NULL THEN 0 ELSE 1 END ThirdPerson,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN 'Tercera persona' WHEN C.IdPersonInCharge IS NOT NULL THEN 'Acompañante' ELSE 'Paciente' END AS PersonType, 
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN CONCAT_WS(' ', G.Name, G.LastName) WHEN C.IdPersonInCharge IS NOT NULL THEN J.FullName ELSE CONVERT(varchar(10),A.IdPatient) END AS Client,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN H.IdentificationTypeCode WHEN C.IdPersonInCharge IS NOT NULL THEN H2.IdentificationTypeCode ELSE CONVERT(varchar(10),A.IdPatient) END AS IdentificationType,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.IdentificationNumber WHEN C.IdPersonInCharge IS NOT NULL THEN J.IdentificationNumber ELSE CONVERT(varchar(10),A.IdPatient) END AS IdentificationNumber,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN NULL ELSE G.VerificationDigit END VerificationDigit,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.TelephoneNumber WHEN C.IdPersonInCharge IS NOT NULL THEN J.TelephoneNumber ELSE CONVERT(varchar(10),A.IdPatient) END AS TelephoneNumber,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.Email WHEN C.IdPersonInCharge IS NOT NULL THEN J.Email ELSE CONVERT(varchar(10),A.IdPatient) END AS Email,
		CASE WHEN A.IdThirdPerson IS NOT NULL THEN G.Address WHEN C.IdPersonInCharge IS NOT NULL THEN J.Address ELSE CONVERT(varchar(10),A.IdPatient) END AS Address,
		D.ContractCode, 'Bogotá' CityName, 
		CONCAT_WS(' ', K.LastName, K.Name) Produced_By, 
		STUFF((SELECT DISTINCT ' - ' + PM.PaymentMethodName
				FROM TB_BillOfSalePayment H
				INNER JOIN TB_PaymentMethod PM
					ON  PM.IdPaymentMethod = H.IdPaymentMethod
				WHERE H.IdBillingOfSale = A.IdBillingOfSale
				FOR XML PATH ('')),2,1,'') PaymentMethod, A.TotalValuePatient
	FROM TB_BillingOfSale A
	INNER JOIN TR_BillingOfSale_Request B
		ON B.IdBillingOfSale = A.IdBillingOfSale
	INNER JOIN TB_Request C
		ON C.IdRequest = B.IdRequest
	INNER JOIN TB_Contract D
		ON D.IdContract = C.IdContract
	INNER JOIN TB_User K
		ON K.IdUser = A.IdUserAction
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
	WHERE A.IdBillingOfSale = @IdBillingOfSale
	GROUP BY A.IdBillingOfSale, C.RequestNumber, C.FamilyGroup, A.BillingOfSaleDate, A.UpdateDate, A.IdThirdPerson, C.IdPersonInCharge, G.Name, G.LastName, J.FullName, A.IdPatient, H.IdentificationTypeCode, H2.IdentificationTypeCode,
		G.IdentificationNumber, J.IdentificationNumber, G.VerificationDigit, G.TelephoneNumber, J.TelephoneNumber, G.Email, J.Email, G.Address, J.Address, D.ContractCode, K.Name, K.LastName, A.TotalValuePatient


	SELECT A.IdBillingOfSale, D.ExamCode, D.ExamName, C.Value AS ServiceValue, B.IdPatient
	FROM TB_BillingOfSale A
	INNER JOIN TR_BillingOfSale_Request F
		ON F.IdBillingOfSale = A.IdBillingOfSale
	INNER JOIN TB_Request B
		ON B.IdRequest = F.IdRequest
	INNER JOIN TR_Request_Exam C
		ON C.IdRequest = B.IdRequest AND C.Active = 1
	INNER JOIN TB_Exam D
		ON D.IdExam = C.IdExam
	WHERE A.IdBillingOfSale = @IdBillingOfSale
	GROUP BY A.IdBillingOfSale, D.ExamCode, D.ExamName, C.Value, B.IdPatient

	UNION ALL

	SELECT A.IdBillingOfSale, D.ExamGroupCode, D.ExamGroupName, C.Value AS ServiceValue, B.IdPatient
	FROM TB_BillingOfSale A
	INNER JOIN TR_BillingOfSale_Request F
		ON F.IdBillingOfSale = A.IdBillingOfSale
	INNER JOIN TB_Request B
		ON B.IdRequest = F.IdRequest
	INNER JOIN TR_Request_Exam C
		ON C.IdRequest = B.IdRequest AND C.Active = 1
	INNER JOIN TB_ExamGroup D
		ON D.IdExamGroup = C.IdExamGroup
	WHERE A.IdBillingOfSale = @IdBillingOfSale
	GROUP BY A.IdBillingOfSale, D.ExamGroupCode, D.ExamGroupName, C.Value, B.IdPatient
END
GO
