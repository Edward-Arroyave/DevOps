SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 28/08/2023
-- Description: Procedimiento almacenado para generar reporte de facturación.
-- =============================================
/*
EXEC [Reports].[sp_BillingReport] '2024-06-01','2024-06-01'
*/
-- =============================================
CREATE PROCEDURE [Reports].[sp_BillingReport]
(
	@InitialDate date,
	@FinalDate date
)
AS
	DECLARE @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

		--SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		SET @FinalDateTime = DATEADD(DAY,1,@FinalDate)
		
		--select IdentificationNumber,IdPatient, IdIdentificationType,FirstName, SecondName, FirstLastName, SecondLastName 
		--into #Patient
		--from carehis.TB_Patient_Ext

	SELECT	G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, A.OrderingNumber NumeroDeOrden,
			A.RequestNumAlternative AS SolicitudExterna, A.IdPatient, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamCode AS CodigoExamen, C.ExamName AS NombreExamen, 
			--D.CUPS CUPS, 
			ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 S.CUPS 
														from	TR_Service_Exam E 
																inner join TB_Service S on E.IdService = S.IdService 
														where	E.IdExam = C.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN B.Copay_CM ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN B.Copay_CM ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus AS EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion
	FROM TB_Request A
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
	--INNER JOIN carehis.TB_Patient_Ext PA
	INNER JOIN TB_Patient_Copi PA
		ON A.IdPatient = PA.IdPatient
	INNER JOIN TB_IdentificationType IT
		ON PA.IdIdentificationType = IT.IdIdentificationType
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest and B.Active=1
	INNER JOIN TB_Exam C
		ON C.IdExam = B.IdExam
	INNER JOIN TR_BillingOfSale_Request E
		ON E.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale F
		ON F.IdBillingOfSale = E.IdBillingOfSale
	INNER JOIN TB_Contract H
		ON H.IdContract = A.IdContract
	INNER JOIN TB_Company I
		ON I.IdCompany = H.IdCompany
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = F.IdElectronicBilling
	LEFT JOIN TB_InvoiceStatus J
		ON J.IdInvoiceStatus = G.IdInvoiceStatus
	INNER JOIN TB_TariffScheme TS 
		ON H.idtariffscheme = TS.idtariffscheme
	LEFT JOIN TR_TariffScheme_Service TSS 
		ON ts.IdTariffScheme = TSS.idtariffscheme and C.IdExam = TSS.IdExam and H.idtariffscheme = tss.idtariffscheme
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	--WHERE A.RequestDate BETWEEN @InitialDate AND @FinalDateTime
	WHERE A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDateTime
	
	UNION ALL

	SELECT	G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, A.OrderingNumber NumeroDeOrden,
			A.RequestNumAlternative SolicitudExterna, A.IdPatient, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamGroupCode CodigoExamen, C.ExamGroupName NombreExamen, 
			--D.CUPS CUPS, 
			ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 S.CUPS 
														from	TR_Service_Exam E 
																inner join TB_Service S on E.IdService = S.IdService 
														where	E.IdExam = C.IdExamGroup And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN B.Copay_CM ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN B.Copay_CM ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion
	FROM TB_Request A
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
	--INNER JOIN carehis.TB_Patient_Ext PA
	INNER JOIN TB_Patient_Copi PA
		ON A.IdPatient = PA.IdPatient
	INNER JOIN TB_IdentificationType IT
		ON PA.IdIdentificationType = IT.IdIdentificationType
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest and B.Active=1
	INNER JOIN TB_ExamGroup C
		ON C.IdExamGroup = B.IdExamGroup
	INNER JOIN TR_BillingOfSale_Request E
		ON E.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale F
		ON F.IdBillingOfSale = E.IdBillingOfSale
	INNER JOIN TB_Contract H
		ON H.IdContract = A.IdContract
	INNER JOIN TB_Company I
		ON I.IdCompany = H.IdCompany
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = F.IdElectronicBilling
	LEFT JOIN TB_InvoiceStatus J
		ON J.IdInvoiceStatus = G.IdInvoiceStatus
	INNER JOIN TB_TariffScheme TS 
		ON H.idtariffscheme = TS.idtariffscheme
	LEFT JOIN TR_TariffScheme_Service TSS 
		ON ts.IdTariffScheme = TSS.idtariffscheme and C.IdExamGroup = TSS.IdExamGroup and H.idtariffscheme = tss.idtariffscheme
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	--WHERE A.RequestDate BETWEEN @InitialDate AND @FinalDateTime
	WHERE A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDateTime
	ORDER BY A.RequestDate ASC
END
GO
