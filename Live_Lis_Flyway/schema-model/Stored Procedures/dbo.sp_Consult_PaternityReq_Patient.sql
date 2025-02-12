SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/04/2023
-- Description: Procedimiento almacenado para consultar información de pacientes relacionados en solicitud de Paternidad.
-- =============================================
-- EXEC [sp_Consult_PaternityReq_Patient] 69562
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_PaternityReq_Patient]
(
	@IdRequest int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdRequest, A.RequestNumber, K.InvoiceNumber, CASE WHEN A.AuthorityRequest = 'True' THEN 'Autoridad' ELSE 'Particular' END AS RequestType, A.OrderingNumber, A.LegalDocument, A.RequestDate, G.IdExam, CONCAT(H.ExamCode, ' - ', H.ExamName) ExamName, A.ModificationReason AS Observations
	FROM TB_Request A
	INNER JOIN TR_Request_Exam G
		ON G.IdRequest = A.IdRequest
	INNER JOIN TB_Exam H
		ON H.IdExam = G.IdExam
	LEFT JOIN TR_BillingOfSale_Request I
		ON I.IdRequest = A.IdRequest
	LEFT JOIN TB_BillingOfSale J
		ON J.IdBillingOfSale = I.IdBillingOfSale
	LEFT JOIN TB_ElectronicBilling K
		ON K.IdElectronicBilling = J.IdElectronicBilling
	WHERE A.IdRequest = @IdRequest

    SELECT DISTINCT B.IdRequest_Patient, B.IdPatient, B.Titular, B.IdRelationship, C.Relationship, B.IdPlaceDeliveryResults, D.PlaceDeliveryResults, B.IdSampleType, E.SampleType, F.LabelCode, F.ReceptionDate
	FROM TB_Request A
	INNER JOIN TR_Request_Patient B
		ON B.IdRequest = A.IdRequest
	LEFT JOIN TB_Relationship C
		ON C.IdRelationship = B.IdRelationship
	LEFT JOIN TB_PlaceDeliveryResults D
		ON D.IdPlaceDeliveryResults = B.IdPlaceDeliveryResults
	LEFT JOIN TB_SampleType E
		ON E.IdSampleType = B.IdSampleType
	LEFT JOIN TB_SampleRegistration F
		ON F.IdRequest = A.IdRequest
			AND F.Active = 'True'
			AND F.IdPatient = B.IdPatient
	WHERE A.IdRequest = @IdRequest
		AND B.Active = 'True'
END
GO
