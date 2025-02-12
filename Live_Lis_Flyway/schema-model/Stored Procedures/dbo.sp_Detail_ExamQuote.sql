SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 23/01/2023
-- Description: Procedimiento almacenado para retornar detalle de cotización de exámenes.
-- =============================================
/*
EXEC [sp_Detail_ExamQuote] 618
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_ExamQuote]
(
	@IdExamQuote int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT	A.IdExamQuote, A.IdContract, C.ContractName, C.IdContractType, CONCAT(' ', CONCAT_WS(' ', A.Names, A.LastNames),' - ', 
			CONCAT(B.IdentificationTypeCode, ' ', A.IdentificationNumber)) Name_Identification, A.TelephoneNumber, 
			A.Email, A.Address, A.Observations, A.BeContacted, A.QuoteWhatsapp, A.ExpirationDate, R.RequestNumber, A.ExamQuoteNumber, A.AdditionalForm,			
			CASE WHEN C.IdContractType = 3 THEN C.ContractAmount ELSE C.ContractBalance END AS ContractBalance, 
			CASE WHEN C.ExpirationDate < DATEADD(HOUR, -5, GETDATE()) THEN 1 ELSE 0 END AS ContractExpiration,
			A.IdUser, A.IdUserAction, U.Name, U.LastName, A.CreationDate, A.Names, A.LastNames, A.IdDiscount, D.Percentage, A.IdDoctor, A.Points
	FROM TB_ExamQuote A
	INNER JOIN TB_IdentificationType B
		ON B.IdIdentificationType = A.IdIdentificationType
	INNER JOIN TB_Contract C
		ON A.IdContract = C.IdContract
	INNER JOIN TB_User U
		ON A.IdUserAction = U.IdUser
	LEFT JOIN TB_Request R
		ON A.IdRequest = R.IdRequest
	LEFT JOIN TB_Discount D
		ON D.IdDiscount = A.IdDiscount
	WHERE A.IdExamQuote = @IdExamQuote


	SELECT DISTINCT B.IdExamQuote_Exam, D.IdTypeOfProcedure, B.IdService, H.CUPS, B.IdExam, C.ExamCode, C.ExamName, B.Value, C.IdSection, C.IdAdditionalForm, 
					F.IdGenerateCopay_CM, STUFF((SELECT ',' + CONVERT(varchar(6), I.IdInformedConsent)
													FROM TR_Exam_InformedConsent I
													WHERE I.IdExam = C.IdExam
													FOR XML PATH('')),1,1,'') InformedConsent,
				CASE WHEN F.IdContractType = 3 THEN F.ContractAmount ELSE F.ContractBalance END AS ContractBalance, 
				CASE WHEN F.ExpirationDate < DATEADD(HOUR, -5, GETDATE()) THEN 1 ELSE 0 END AS ContractExpiration, C.DeliveryOpportunity, i.Percentage, B.IVA, 
				B.OriginalValue, B.IdDiscount_Service, I.Percentage, I.IdDiscount
	FROM TB_ExamQuote A
	INNER JOIN TR_ExamQuote_Exam B
		ON B.IdExamQuote = A.IdExamQuote
	INNER JOIN TB_Contract F
		ON F.IdContract = A.IdContract
	INNER JOIN TB_TariffScheme E
		ON E.IdTariffScheme = F.IdTariffScheme
	INNER JOIN TR_TariffScheme_Service D
		ON D.IdTariffScheme = E.IdTariffScheme
			AND D.IdExam = B.IdExam and D.Active=1
	--		AND ISNULL(D.IdService,0) = ISNULL(B.IdService,0)
	INNER JOIN TB_Exam C
		ON C.IdExam = B.IdExam
	LEFT JOIN TB_Service H
		ON ISNULL(H.IdService,0) = ISNULL(B.IdService,0)	
	LEFT JOIN TR_Discount_Service I
		ON 
			I.IdDiscount_Service = B.IdDiscount_Service
			AND I.IdExam = B.IdExam
	WHERE A.IdExamQuote = @IdExamQuote

	UNION ALL

	SELECT DISTINCT B.IdExamQuote_Exam, D.IdTypeOfProcedure, NULL, NULL, B.IdExamGroup, C.ExamGroupCode, C.ExamGroupName, B.Value, NULL, NULL, F.IdGenerateCopay_CM,
		STUFF((SELECT DISTINCT ',' + CONVERT(varchar(6), I.IdInformedConsent)
				FROM TR_ExamGroup_Exam G
				INNER JOIN TB_Exam H
					ON H.IdExam = G.IdExam
				INNER JOIN TR_Exam_InformedConsent I
					ON I.IdExam = H.IdExam
				WHERE G.IdExamGroup = C.IdExamGroup
				FOR XML PATH('')),1,1,'') InformedConsent,
				CASE WHEN F.IdContractType = 3 THEN F.ContractAmount ELSE F.ContractBalance END AS ContractBalance, 
				CASE WHEN F.ExpirationDate < DATEADD(HOUR, -5, GETDATE()) THEN 1 ELSE 0 END AS ContractExpiration, NULL DeliveryOpportunity,  i.Percentage, B.IVA, 
				B.OriginalValue, B.IdDiscount_Service, I.Percentage, I.IdDiscount
	FROM TB_ExamQuote A
	INNER JOIN TR_ExamQuote_Exam B
		ON B.IdExamQuote = A.IdExamQuote
	INNER JOIN TB_Contract F
		ON F.IdContract = A.IdContract
	INNER JOIN TB_TariffScheme E
		ON E.IdTariffScheme = F.IdTariffScheme
	INNER JOIN TR_TariffScheme_Service D
		ON D.IdTariffScheme = E.IdTariffScheme
			AND D.IdExamGroup = B.IdExamGroup
	INNER JOIN TB_ExamGroup C
		ON C.IdExamGroup = B.IdExamGroup
	LEFT JOIN TR_Discount_Service I
		ON 
			I.IdDiscount_Service = B.IdDiscount_Service
			AND I.IdExamGroup = B.IdExamGroup
	WHERE A.IdExamQuote = @IdExamQuote
END
GO
