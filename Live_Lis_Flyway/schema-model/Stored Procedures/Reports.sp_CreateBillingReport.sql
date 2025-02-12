SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Reports].[sp_CreateBillingReport]
    @InitialDate DATE,
    @FinalDate DATE
AS
-- =============================================
-- Author:      Rodolfo Enrique Torres Caballero
-- Create Date: 30/10/2024
-- Description: Procedimiento almacenado para generar la información del reporte de facturación.
-- =============================================
/*
EXEC [Reports].[sp_CreateBillingReport] '2024-06-01','2024-06-01'
*/
-- =============================================
BEGIN
    INSERT INTO Reports.TB_BillingReport (
        FechaFactura, FechaRecepcion, FechaSolicitud, NumeroSolicitud, SolicitudExterna, IdPaciente, Paciente, TipoIdentificacion,
        NumeroIdentificacion, CodigoExamen, NombreExamen, CUPS, NumeroFactura, Valor, Copago, CM, CodigoPlan, NombrePlan, Tercero,
        EstadoSolicitud, EstadoFactura, Sede, FormaDePago, GrupoFacturacion, CodigoContratacion
    )
    SELECT	G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, 
			A.RequestNumAlternative AS SolicitudExterna, A.IdPatient, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamCode AS CodigoExamen, C.ExamName AS NombreExamen, 
			ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 S.CUPS 
														from	TR_Service_Exam E 
																inner join TB_Service S on E.IdService = S.IdService 
														where	E.IdExam = C.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN B.Copay_CM ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN B.Copay_CM ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus AS EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion, tss.Hiring CodigoContratacion
	FROM TB_Request A
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
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
	WHERE cast(A.RequestDate as date) BETWEEN @InitialDate AND @FinalDate
	UNION ALL

	SELECT	G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, 
			A.RequestNumAlternative SolicitudExterna, A.IdPatient, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamGroupCode CodigoExamen, C.ExamGroupName NombreExamen, 
			ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 S.CUPS 
														from	TR_Service_Exam E 
																inner join TB_Service S on E.IdService = S.IdService 
														where	E.IdExam = C.IdExamGroup And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN B.Copay_CM ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN B.Copay_CM ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion, tss.Hiring CodigoContratacion
	FROM TB_Request A
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
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
	WHERE cast(A.RequestDate as date) BETWEEN @InitialDate AND @FinalDate
	
END;
GO
