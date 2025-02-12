SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 23/08/2022
-- Description: Procedimiento almacenado para 
-- =============================================
 --EXEC [sp_Detail_BillingOfSale] 3224, 71580
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_BillingOfSale]
(
	@IdBillingOfSale int,
	@IdRequest varchar(10)
)
AS
BEGIN
    SET NOCOUNT ON

    SELECT DISTINCT F.IdBillingOfSale, A.IdPatient, A.IdPatient AS Patient, '' AppointmentDate, 
		STUFF((SELECT DISTINCT ',' + PM.PaymentMethodName
				FROM TB_BillOfSalePayment H
				LEFT JOIN TB_PaymentMethod PM
					ON  PM.IdPaymentMethod = H.IdPaymentMethod
				WHERE H.IdBillingOfSale = F.IdBillingOfSale
				FOR XML PATH ('')),1,1,'') PaymentMethodName, 
		STUFF((SELECT DISTINCT ',' + PM.Image
				FROM TB_BillOfSalePayment H
				LEFT JOIN TB_PaymentMethod PM
					ON  PM.IdPaymentMethod = H.IdPaymentMethod
				WHERE H.IdBillingOfSale = F.IdBillingOfSale
				FOR XML PATH ('')),1,1,'') PaymentMethodImage, 
		ST.ServiceType, BS.BillingOfSaleStatus, F.Observation, C.IdTypeOfProcedure, L.TypeOfProcedure, B.IdService, SR.CUPS, B.IdExam, C.ExamCode, C.ExamName, C.ClinicalImportance, B.Value, F.TotalValuePatient, G.ElectronicBillingDate, CONCAT_WS(' ', U.Name, U.LastName) AS ResponsibleCollection
	FROM TB_Request A
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TR_BillingOfSale_Request BR	
		ON BR.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale F
		ON F.IdBillingOfSale = BR.IdBillingOfSale
	INNER JOIN TB_User U
		ON U.IdUser = F.IdUserAction
	INNER JOIN TB_Exam C
		ON C.IdExam = B.IdExam
	INNER JOIN TB_TypeOfProcedure L
		ON C.IdTypeOfProcedure = C.IdTypeOfProcedure
	LEFT JOIN TB_Service SR
		ON SR.IdService = B.IdService
	LEFT JOIN TB_ServiceType ST
		ON ST.IdServiceType = SR.IdServiceType	
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = F.IdElectronicBilling
	LEFT JOIN TB_BillingOfSaleStatus BS
		ON BS.IdBillingOfSaleStatus = F.IdBillingOfSaleStatus
	WHERE F.IdBillingOfSale = @IdBillingOfSale
		AND L.IdTypeOfProcedure = 1
		AND CASE WHEN @IdRequest = '' THEN '' ELSE A.IdRequest END = @IdRequest
		AND B.Active = 'True'

	UNION ALL

	SELECT DISTINCT F.IdBillingOfSale, A.IdPatient, A.IdPatient AS Patient, '' AppointmentDate, 
		STUFF((SELECT DISTINCT ',' + PM.PaymentMethodName
				FROM TB_BillOfSalePayment H
				LEFT JOIN TB_PaymentMethod PM
					ON  PM.IdPaymentMethod = H.IdPaymentMethod
				WHERE H.IdBillingOfSale = F.IdBillingOfSale
				FOR XML PATH ('')),1,1,'') PaymentMethodName, 
		STUFF((SELECT DISTINCT ',' + PM.Image
				FROM TB_BillOfSalePayment H
				LEFT JOIN TB_PaymentMethod PM
					ON  PM.IdPaymentMethod = H.IdPaymentMethod
				WHERE H.IdBillingOfSale = F.IdBillingOfSale
				FOR XML PATH ('')),1,1,'') PaymentMethodImage, 
		ST.ServiceType, BS.BillingOfSaleStatus, F.Observation, L.IdTypeOfProcedure, M.TypeOfProcedure,B.IdService, SR.CUPS, B.IdExamGroup, L.ExamGroupCode, L.ExamGroupName, '',  B.Value, F.TotalValuePatient, G.ElectronicBillingDate, CONCAT_WS(' ', U.Name, U.LastName)
	FROM TB_Request A
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TR_BillingOfSale_Request BR	
		ON BR.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale F
		ON F.IdBillingOfSale = BR.IdBillingOfSale
	INNER JOIN TB_User U
		ON U.IdUser = F.IdUserAction
	INNER JOIN TB_ExamGroup L
		ON L.IdExamGroup = B.IdExamGroup
	INNER JOIN TB_TypeOfProcedure M
		ON L.IdTypeOfProcedure = M.IdTypeOfProcedure
	LEFT JOIN TB_Service SR
		ON SR.IdService = B.IdService
	LEFT JOIN TB_ServiceType ST
		ON ST.IdServiceType = SR.IdServiceType	
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = F.IdElectronicBilling
	LEFT JOIN TB_BillingOfSaleStatus BS
		ON BS.IdBillingOfSaleStatus = F.IdBillingOfSaleStatus
	WHERE F.IdBillingOfSale = @IdBillingOfSale
		AND L.IdTypeOfProcedure != 1
		AND CASE WHEN @IdRequest = '' THEN '' ELSE A.IdRequest END = @IdRequest
		AND B.Active = 'True'
END
GO
