SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/09/2022
-- Description: Procedimiento almacenado para consultar solicitud para ser modificada.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Consult_UpdateRequest]'2023081500031', @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_UpdateRequest]
(
	@RequestNumber varchar(15),
	@Type Bit = 0,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
		IF @Type = 0
			BEGIN

			IF EXISTS(SELECT IdRequest FROM TB_Request WHERE RequestNumber = @RequestNumber)
				BEGIN
					IF (SELECT IdRequestStatus FROM TB_Request WHERE RequestNumber = @RequestNumber) != 2
						BEGIN
							IF NOT EXISTS (SELECT * FROM TB_Request A INNER JOIN TB_RequestResultAlternative B ON B.IdRequest = A.IdRequest WHERE A.RequestNumber = @RequestNumber)
								BEGIN
									SELECT	A.IdRequest, A.AuthorityRequest, A.LegalDocument, A.OrderingNumber, A.RequestNumber, A.NumberOfPatients, A.IdPatient, A.IdCIE10_Code4, B.CIE10_Code4Name, A.IsEmergency, A.IdRequestServiceType, C.RequestServiceType, A.Observations, A.AdditionalForm,
											D.IdRequestFile, D.IdRequestFileType, F.RequestFileType, D.RequestFileName, I.InvoiceNumber, J.RequirementsForAttention, J.IdContract, CONCAT_WS(' - ', J.ContractCode,J.ContractName) AS ContractName, J.IdContractType, J.IdAdditionalForm,
											L.Fridgereference,L.GuideNumber,L.Transporter, COALESCE(A.IdAttentionCenterOrigin,A.IdAttentionCenter) AS IdAttentionCenter, A.IdAttentionCenterOrigin, M.AttentionCenterName, N.AttentionCenterName AS AttentionNameOrigin, A.IdRequestAlternative, 
											A.RequestNumAlternative, H.TotalValuePatient, A.OrderingNumber, REF.ReferenceName,
											P.IdDiscount, P.Percentage, P.Cumulative, A.RecoveryFee, J.IdGenerateCopay_CM
									FROM TB_Request A
									LEFT JOIN TB_ReferenceType REF ON  A.IdReferenceType = REF.IdReferenceType
									INNER JOIN TR_BillingOfSale_Request G
										ON G.IdRequest = A.IdRequest
									INNER JOIN TB_BillingOfSale H
										ON H.IdBillingOfSale = G.IdBillingOfSale
									INNER JOIN TB_Contract J
										ON J.IdContract = A.IdContract
									INNER JOIN TB_AttentionCenter M
										ON M.IdAttentionCenter = COALESCE(A.IdAttentionCenterOrigin,A.IdAttentionCenter)
									LEFT JOIN TB_RequestServiceType C
										ON C.IdRequestServiceType = A.IdRequestServiceType
									LEFT JOIN TB_ElectronicBilling I
										ON I.IdElectronicBilling = H.IdElectronicBilling
											AND I.IdInvoiceStatus != 3
									LEFT JOIN TB_CIE10_Code4 B
										ON B.IdCIE10_Code4 = A.IdCIE10_Code4
									LEFT JOIN TB_RequestFile D
										ON D.IdRequest = A.IdRequest
									LEFT JOIN TB_RequestFileType F
										ON F.IdRequestFileType = D.IdRequestFileType
									LEFT JOIN TB_PackageTransport L
										ON L.IdRequest = A.IdRequest
									LEFT JOIN TB_AttentionCenter N
										ON N.IdAttentionCenter = A.IdAttentionCenterOrigin
									LEFT JOIN TR_Request_Discount O
										ON O.IdRequest = A.IdRequest
									LEFT JOIN TB_Discount P
										ON P.IdDiscount = O.IdDiscount
										AND P.IdDiscountCategory = 2
									WHERE A.RequestNumber = @RequestNumber

									SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, H.TypeOfProcedure, B.IdExam, C.IdAdditionalForm, C.ExamCode, C.ExamName, C.IdSection, B.AdditionalForm, C.PreparationOrObservation, 
										B.Value, 
										CASE WHEN I.IdDiscount IS NULL THEN NULL ELSE B.Value - (B.Value * I.Percentage/100.0) END ValueDiscount,
										B.IdBodyPart, D.Description AS BodyPart, 
										B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium, A.CreationDate, B.IdService, G.CUPS, B.IdGenerateCopay_CM, REF.ReferenceName,
										I.IdDiscount, J.Cumulative, B.IdDiscount_Service, B.OriginalValue, I.Percentage, A.RecoveryFee
									FROM TB_Request A
									LEFT JOIN TB_ReferenceType REF 
										ON  A.IdReferenceType = REF.IdReferenceType
									INNER JOIN TR_Request_Exam B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_Exam C
										ON C.IdExam = B.IdExam
									INNER JOIN TB_TypeOfProcedure H
										ON H.IdTypeOfProcedure = B.IdTypeOfProcedure
									INNER JOIN TB_Contract CON
										ON CON.IdContract = A.IdContract
									LEFT JOIN PTO.TB_BodyPart D
										ON D.IdBodyPart = B.IdBodyPart
									LEFT JOIN PTO.TB_PathologyExamType E
										ON E.IdPathologyExamType = B.IdPathologyExamType
									LEFT JOIN PTO.TB_FixingMedium F
										ON F.IdFixingMedium = B.IdFixingMedium
									LEFT JOIN TB_Service G
										ON G.IdService = B.IdService
									LEFT JOIN TR_Discount_Service I
										ON I.IdDiscount_Service = B.IdDiscount_Service
									LEFT JOIN TB_Discount J
										ON I.IdDiscount = J.IdDiscount
									WHERE A.RequestNumber = @RequestNumber
										AND B.Active = 'True'

									UNION ALL

									SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, C.TypeOfProcedure, B.IdExamGroup, NULL, H.ExamGroupCode, H.ExamGroupName, NULL, B.AdditionalForm, NULL, 
										B.Value, 
										CASE WHEN I.IdDiscount IS NULL THEN NULL ELSE B.Value - (B.Value * I.Percentage/100.0) END ValueDiscount,
										B.IdBodyPart, D.Description AS BodyPart, 
										B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium, A.CreationDate, B.IdService, G.CUPS, B.IdGenerateCopay_CM, REF.ReferenceName,
										I.IdDiscount, J.Cumulative, B.IdDiscount_Service, B.OriginalValue, I.Percentage, A.RecoveryFee
									FROM TB_Request A
									LEFT JOIN TB_ReferenceType REF 
										ON  A.IdReferenceType = REF.IdReferenceType
									INNER JOIN TR_Request_Exam B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_ExamGroup H
										ON H.IdExamGroup = B.IdExamGroup
									INNER JOIN TB_TypeOfProcedure C
										ON C.IdTypeOfProcedure = B.IdTypeOfProcedure
									INNER JOIN TB_Contract CON
										ON CON.IdContract = A.IdContract
									LEFT JOIN PTO.TB_BodyPart D
										ON D.IdBodyPart = B.IdBodyPart
									LEFT JOIN PTO.TB_PathologyExamType E
										ON E.IdPathologyExamType = B.IdPathologyExamType
									LEFT JOIN PTO.TB_FixingMedium F
										ON F.IdFixingMedium = B.IdFixingMedium
									LEFT JOIN TB_Service G
										ON G.IdService = B.IdService
									LEFT JOIN TR_Discount_Service I
										ON I.IdDiscount_Service = B.IdDiscount_Service
									LEFT JOIN TB_Discount J
										ON I.IdDiscount = J.IdDiscount
									WHERE A.RequestNumber = @RequestNumber
										AND B.Active = 'True'

									----- Información de consentimientos informados
									SELECT B.IdInformedConsent, C.InformedConsent AS InformedConsentName, B.InformedConsent, A.RequestDate
									FROM TB_Request A
									INNER JOIN TR_ReqExam_InformConsent B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_InformedConsent C
										ON C.IdInformedConsent = B.IdInformedConsent
									WHERE A.RequestNumber = @RequestNumber

									SET @Message = 'Successfully returned information'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'Request already has result'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Request is in canceled status'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Request not found'
					SET @Flag = 0
				END
			
			END
			ELSE
				BEGIN
					IF EXISTS(SELECT IdRequest FROM TB_Request WHERE RequestNumAlternative = @RequestNumber)
						BEGIN
							IF (SELECT IdRequestStatus FROM TB_Request WHERE RequestNumAlternative = @RequestNumber) != 2
								BEGIN
									IF NOT EXISTS (SELECT * FROM TB_Request A INNER JOIN TB_RequestResultAlternative B ON B.IdRequest = A.IdRequest WHERE A.RequestNumber = @RequestNumber)
										BEGIN
											SELECT	A.IdRequest, A.AuthorityRequest, A.LegalDocument, A.OrderingNumber, A.RequestNumber, A.NumberOfPatients, A.IdPatient, A.IdCIE10_Code4, B.CIE10_Code4Name, A.IsEmergency, A.IdRequestServiceType, C.RequestServiceType, A.Observations, A.AdditionalForm,
													D.IdRequestFile, D.IdRequestFileType, F.RequestFileType, D.RequestFileName, I.InvoiceNumber, J.RequirementsForAttention, J.IdContract, CONCAT_WS(' - ', J.ContractCode,J.ContractName) AS ContractName, J.IdContractType, J.IdAdditionalForm,
													L.Fridgereference,L.GuideNumber,L.Transporter, A.IdAttentionCenter, A.IdAttentionCenterOrigin, M.AttentionCenterName, N.AttentionCenterName AS AttentionNameOrigin, A.IdRequestAlternative, 
													A.RequestNumAlternative, H.TotalValuePatient, A.OrderingNumber, REF.ReferenceName,
													P.IdDiscount, P.Percentage, P.Cumulative, A.RecoveryFee, J.IdGenerateCopay_CM
											FROM TB_Request A
											LEFT JOIN TB_ReferenceType REF 
												ON  A.IdReferenceType = REF.IdReferenceType
											INNER JOIN TR_BillingOfSale_Request G
												ON G.IdRequest = A.IdRequest
											INNER JOIN TB_BillingOfSale H
												ON H.IdBillingOfSale = G.IdBillingOfSale
											INNER JOIN TB_Contract J
												ON J.IdContract = A.IdContract
											INNER JOIN TB_AttentionCenter M
												ON M.IdAttentionCenter = A.IdAttentionCenter
											LEFT JOIN TB_RequestServiceType C
												ON C.IdRequestServiceType = A.IdRequestServiceType
											LEFT JOIN TB_ElectronicBilling I
												ON I.IdElectronicBilling = H.IdElectronicBilling
												AND I.IdInvoiceStatus != 3
											LEFT JOIN TB_CIE10_Code4 B
												ON B.IdCIE10_Code4 = A.IdCIE10_Code4
											LEFT JOIN TB_RequestFile D
												ON D.IdRequest = A.IdRequest
											LEFT JOIN TB_RequestFileType F
												ON F.IdRequestFileType = D.IdRequestFileType
											LEFT JOIN TB_PackageTransport L
												ON L.IdRequest = A.IdRequest
											LEFT JOIN TB_AttentionCenter N
												ON N.IdAttentionCenter = A.IdAttentionCenterOrigin
											LEFT JOIN TR_Request_Discount O
												ON O.IdRequest = A.IdRequest
											LEFT JOIN TB_Discount P
												ON P.IdDiscount = O.IdDiscount
												AND P.IdDiscountCategory = 2
											WHERE A.RequestNumAlternative = @RequestNumber

											SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, H.TypeOfProcedure, B.IdExam, C.IdAdditionalForm, C.ExamCode, C.ExamName, C.IdSection, B.AdditionalForm, C.PreparationOrObservation, 
												B.Value, 
												CASE WHEN I.IdDiscount IS NULL THEN NULL ELSE B.Value - (B.Value * I.Percentage/100.0) END ValueDiscount,
												B.IdBodyPart, D.Description AS BodyPart, 
												B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium, A.CreationDate, B.IdService, G.CUPS, B.IdGenerateCopay_CM, REF.ReferenceName,
												I.IdDiscount, J.Cumulative, B.IdDiscount_Service, B.OriginalValue, I.Percentage, A.RecoveryFee
											FROM TB_Request A
											LEFT JOIN TB_ReferenceType REF 
												ON  A.IdReferenceType = REF.IdReferenceType
											INNER JOIN TR_Request_Exam B
												ON B.IdRequest = A.IdRequest
											INNER JOIN TB_Exam C
												ON C.IdExam = B.IdExam
											INNER JOIN TB_TypeOfProcedure H
												ON H.IdTypeOfProcedure = B.IdTypeOfProcedure
											INNER JOIN TB_Contract CON
												ON CON.IdContract = A.IdContract
											LEFT JOIN PTO.TB_BodyPart D
												ON D.IdBodyPart = B.IdBodyPart
											LEFT JOIN PTO.TB_PathologyExamType E
												ON E.IdPathologyExamType = B.IdPathologyExamType
											LEFT JOIN PTO.TB_FixingMedium F
												ON F.IdFixingMedium = B.IdFixingMedium
											LEFT JOIN TB_Service G
												ON G.IdService = B.IdService
											LEFT JOIN TR_Discount_Service I
												ON I.IdDiscount_Service = B.IdDiscount_Service
											LEFT JOIN TB_Discount J
												ON I.IdDiscount = J.IdDiscount
											WHERE A.RequestNumAlternative = @RequestNumber
												AND B.Active = 'True'

											UNION ALL

											SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, C.TypeOfProcedure, B.IdExamGroup, NULL, H.ExamGroupCode, H.ExamGroupName, NULL, B.AdditionalForm, NULL, 
												B.Value, 
												CASE WHEN I.IdDiscount IS NULL THEN NULL ELSE B.Value - (B.Value * I.Percentage/100.0) END ValueDiscount,
												B.IdBodyPart, D.Description AS BodyPart, 
												B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium, A.CreationDate, B.IdService, G.CUPS, B.IdGenerateCopay_CM, REF.ReferenceName,
												I.IdDiscount, J.Cumulative, B.IdDiscount_Service, B.OriginalValue, I.Percentage, A.RecoveryFee
											FROM TB_Request A
											LEFT JOIN TB_ReferenceType REF 
												ON  A.IdReferenceType = REF.IdReferenceType
											INNER JOIN TR_Request_Exam B
												ON B.IdRequest = A.IdRequest
											INNER JOIN TB_ExamGroup H
												ON H.IdExamGroup = B.IdExamGroup
											INNER JOIN TB_TypeOfProcedure C
												ON C.IdTypeOfProcedure = B.IdTypeOfProcedure
											INNER JOIN TB_Contract CON
												ON CON.IdContract = A.IdContract
											LEFT JOIN PTO.TB_BodyPart D
												ON D.IdBodyPart = B.IdBodyPart
											LEFT JOIN PTO.TB_PathologyExamType E
												ON E.IdPathologyExamType = B.IdPathologyExamType
											LEFT JOIN PTO.TB_FixingMedium F
												ON F.IdFixingMedium = B.IdFixingMedium
											LEFT JOIN TB_Service G
												ON G.IdService = B.IdService
											LEFT JOIN TR_Discount_Service I
												ON I.IdDiscount_Service = B.IdDiscount_Service
											LEFT JOIN TB_Discount J
												ON I.IdDiscount = J.IdDiscount
											WHERE A.RequestNumAlternative = @RequestNumber
												AND B.Active = 'True'

											----- Información de consentimientos informados
											SELECT B.IdInformedConsent, C.InformedConsent AS InformedConsentName, B.InformedConsent, A.RequestDate
											FROM TB_Request A
											INNER JOIN TR_ReqExam_InformConsent B
												ON B.IdRequest = A.IdRequest
											INNER JOIN TB_InformedConsent C
												ON C.IdInformedConsent = B.IdInformedConsent
											WHERE A.RequestNumAlternative = @RequestNumber

											SET @Message = 'Successfully returned information'
											SET @Flag = 1
										END
									ELSE
										BEGIN
											SET @Message = 'Request already has result'
											SET @Flag = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Request is in canceled status'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Request not found'
							SET @Flag = 0
						END
				END	
END

--SELECT IdRequest, COUNT(*)
--FROM TR_ReqExam_InformConsent
--GROUP BY IdRequest
--ORDER BY 2 DESC

--SELECT *
--FROM TB_Request
--WHERE IdRequest = 70841
GO
