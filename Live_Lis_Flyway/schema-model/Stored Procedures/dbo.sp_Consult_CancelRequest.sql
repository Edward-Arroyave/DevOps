SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/09/2022
-- Description: Procedimiento almacenado para consultar solicitud para .
-- =============================================
/*
DECLARE @Message varchar(50), @Flag bit 
EXEC [sp_Consult_CancelRequest] '2024041805701',0, @Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_CancelRequest]
(
	@RequestNumber varchar(15),
	@Type bit = 0,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdContract int, @IdContractType int
BEGIN
    SET NOCOUNT ON

	SET @IdContract = (SELECT DISTINCT IdContract FROM TB_Request WHERE RequestNumber = @RequestNumber)
	SET @IdContractType = (SELECT DISTINCT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)
	
	
	IF EXISTS (SELECT RequestNumber FROM TB_Request WHERE CASE WHEN @Type = 1 THEN RequestNumalternative ELSE RequestNumber END = @RequestNumber)
		BEGIN
			IF EXISTS (SELECT RequestNumber FROM TB_Request WHERE CASE WHEN @Type = 1 THEN RequestNumalternative ELSE RequestNumber END = @RequestNumber AND IdRequestStatus != 2)
				BEGIN
					IF NOT EXISTS (SELECT A.IdRequest FROM TB_Request A INNER JOIN TB_RequestResultAlternative B ON B.IdRequest = A.IdRequest WHERE CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber) AND NOT EXISTS (SELECT C.IdResults FROM TB_Request A INNER JOIN TR_Patient_Exam B ON B.IdRequest = A.IdRequest INNER JOIN ANT.TB_Results C ON C.IdPatient_Exam = B.IdPatient_Exam WHERE CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber)
						BEGIN
							IF @IdContractType = 1
								BEGIN
									SELECT A.IdRequest, A.RequestDate, A.RequestNumber, A.IdAdmissionSource, D.AdmissionSource, A.IdPatient, I.InvoiceNumber, B.IdPaymentMethod, C.PaymentMethodName, I.IdTransaction, I.TransactionDate, J.IdContractType, A.IdRequestAlternative, A.RequestNumAlternative
									FROM TB_Request A
									INNER JOIN TR_BillingOfSale_Request G
										ON G.IdRequest = A.IdRequest
									INNER JOIN TB_BillingOfSale H
										ON H.IdBillingOfSale = G.IdBillingOfSale
									INNER JOIN TB_AdmissionSource D
										ON D.IdAdmissionSource = A.IdAdmissionSource
									INNER JOIN TB_Contract J
										ON J.IdContract = A.IdContract
									LEFT JOIN TB_BillOfSalePayment B
										ON B.IdBillingOfSale = H.IdBillingOfSale
									LEFT JOIN TB_PaymentMethod C
										ON C.IdPaymentMethod = B.IdPaymentMethod
									LEFT JOIN TB_ElectronicBilling I
										ON I.IdElectronicBilling = H.IdElectronicBilling
											AND I.Active = 1
									WHERE CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber
										AND A.IdRequestStatus != 2

									SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, G.TypeOfProcedure, B.IdExam, C.IdAdditionalForm, C.ExamCode, C.ExamName, C.IdSection, B.AdditionalForm, C.PreparationOrObservation, B.Value, B.IdBodyPart, D.Description AS BodyPart, B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium
									FROM TB_Request A
									INNER JOIN TR_Request_Exam B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_Exam C
										ON C.IdExam = B.IdExam
									INNER JOIN TB_TypeOfProcedure G
										ON G.IdTypeOfProcedure = B.IdTypeOfProcedure
									LEFT JOIN PTO.TB_BodyPart D
										ON D.IdBodyPart = B.IdBodyPart
									LEFT JOIN PTO.TB_PathologyExamType E
										ON E.IdPathologyExamType = B.IdPathologyExamType
									LEFT JOIN PTO.TB_FixingMedium F
										ON F.IdFixingMedium = B.IdFixingMedium
									WHERE CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber
										AND B.Active = 'True'
										AND A.IdRequestStatus != 2
									
									UNION ALL

									SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, G.TypeOfProcedure, B.IdExamGroup, NULL, C.ExamGroupCode, C.ExamGroupName, NULL, B.AdditionalForm, NULL, B.Value, B.IdBodyPart, D.Description AS BodyPart, B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium
									FROM TB_Request A
									INNER JOIN TR_Request_Exam B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_ExamGroup C
										ON C.IdExamGroup = B.IdExamGroup
									INNER JOIN TB_TypeOfProcedure G
										ON G.IdTypeOfProcedure = B.IdTypeOfProcedure
									LEFT JOIN PTO.TB_BodyPart D
										ON D.IdBodyPart = B.IdBodyPart
									LEFT JOIN PTO.TB_PathologyExamType E
										ON E.IdPathologyExamType = B.IdPathologyExamType
									LEFT JOIN PTO.TB_FixingMedium F
										ON F.IdFixingMedium = B.IdFixingMedium
									WHERE CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber
										AND B.Active = 'True'
										AND A.IdRequestStatus != 2

									SET @Message = 'Request information found'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SELECT A.IdRequest, A.RequestDate, A.RequestNumber, A.IdAdmissionSource, D.AdmissionSource, A.IdPatient, K.InvoiceNumber, B.IdPaymentMethod, C.PaymentMethodName, K.IdTransaction, K.TransactionDate, L.IdContractType, A.IdRequestAlternative, A.RequestNumAlternative
									FROM TB_Request A
									INNER JOIN TR_BillingOfSale_Request G
										ON G.IdRequest = A.IdRequest
									INNER JOIN TB_BillingOfSale H
										ON H.IdBillingOfSale = G.IdBillingOfSale
									INNER JOIN TB_AdmissionSource D
										ON D.IdAdmissionSource = A.IdAdmissionSource
									INNER JOIN TB_Contract L
										ON L.IdContract = A.IdContract
									LEFT JOIN TB_BillOfSalePayment B	
										ON B.IdBillingOfSale = H.IdBillingOfSale
									LEFT JOIN TB_PaymentMethod C
										ON C.IdPaymentMethod = B.IdPaymentMethod
									LEFT JOIN TR_PreBilling_BillingOfSale I
										ON I.IdBillingOfSale = H.IdBillingOfSale
										and I.Active = 1

									LEFT JOIN TB_PreBilling J
										ON J.IdPreBilling = I.IdPreBilling
									LEFT JOIN TB_ElectronicBilling K
										ON K.IdElectronicBilling = J.IdElectronicBilling
										AND K.Active = 1
									WHERE CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber
										AND A.IdRequestStatus != 2

									SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, G.TypeOfProcedure, B.IdExam, C.IdAdditionalForm, C.ExamCode, C.ExamName, C.IdSection, B.AdditionalForm, C.PreparationOrObservation, B.Value, B.IdBodyPart, D.Description AS BodyPart, B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium
									FROM TB_Request A
									INNER JOIN TR_Request_Exam B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_Exam C
										ON C.IdExam = B.IdExam
									INNER JOIN TB_TypeOfProcedure G
										ON G.IdTypeOfProcedure = B.IdTypeOfProcedure
									LEFT JOIN PTO.TB_BodyPart D
										ON D.IdBodyPart = B.IdBodyPart
									LEFT JOIN PTO.TB_PathologyExamType E
										ON E.IdPathologyExamType = B.IdPathologyExamType
									LEFT JOIN PTO.TB_FixingMedium F
										ON F.IdFixingMedium = B.IdFixingMedium
									WHERE 
										CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber
										AND B.Active = 'True'
										AND A.IdRequestStatus != 2

									UNION ALL

									SELECT B.IdRequest_Exam, A.RequestNumber, B.IdTypeOfProcedure, G.TypeOfProcedure, B.IdExamGroup, NULL, C.ExamGroupCode, C.ExamGroupName, NULL, B.AdditionalForm, NULL, B.Value, B.IdBodyPart, D.Description AS BodyPart, B.IdPathologyExamType, E.Description AS PathologyExamType, B.IdFixingMedium, F.Description AS FixingMedium
									FROM TB_Request A
									INNER JOIN TR_Request_Exam B
										ON B.IdRequest = A.IdRequest
									INNER JOIN TB_ExamGroup C
										ON C.IdExamGroup = B.IdExamGroup
									INNER JOIN TB_TypeOfProcedure G
										ON G.IdTypeOfProcedure = B.IdTypeOfProcedure
									LEFT JOIN PTO.TB_BodyPart D
										ON D.IdBodyPart = B.IdBodyPart
									LEFT JOIN PTO.TB_PathologyExamType E
										ON E.IdPathologyExamType = B.IdPathologyExamType
									LEFT JOIN PTO.TB_FixingMedium F
										ON F.IdFixingMedium = B.IdFixingMedium
									WHERE CASE WHEN @Type = 1 THEN A.RequestNumalternative ELSE A.RequestNumber END = @RequestNumber
										AND B.Active = 'True'
										AND A.IdRequestStatus != 2

									SET @Message = 'Request information found'
									SET @Flag = 1
								END
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
GO
