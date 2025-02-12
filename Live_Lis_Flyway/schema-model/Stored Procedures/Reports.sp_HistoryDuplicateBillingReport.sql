SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 30/04/2024
-- Description: Procedimiento almacenado para generar reporte de facturación con factura electronica.
-- =============================================
/*
EXEC [Reports].[sp_HistoryDuplicateBillingReport] '2024-04-01','2024-06-30','','','',''
*/
-- =============================================
CREATE PROCEDURE [Reports].[sp_HistoryDuplicateBillingReport]
(
	@InitialDate date = '',
	@FinalDate date = '',
	@InitialBillingDate date = '',
	@FinalBillingDate date = '',
	@IdCompany varchar (20) = '',
	@IdContract varchar(10) = ''
)
AS
	DECLARE @FinalDateTime datetime, @FinalBillingDateTime datetime
BEGIN
    SET NOCOUNT ON

	IF @InitialDate != '' AND @FinalDate != ''
	BEGIN 
		SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
	END
	ELSE
	BEGIN 
		SET @FinalDateTime = ''
	END
	
	IF @InitialBillingDate != '' AND @FinalBillingDate != ''
	BEGIN
		SET @FinalBillingDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@InitialBillingDate)))
	END
	ELSE
	BEGIN 
		SET @FinalBillingDateTime = ''
	END

	--SELECT IdentificationNumber,IdPatient, IdIdentificationType,FirstName, SecondName, FirstLastName, SecondLastName 
	--INTO #Patient
	--FROM carehis.TB_Patient_Ext

	SELECT	I.NIT, YEAR(G.ElectronicBillingDate) ANO, MONTH(G.ElectronicBillingDate) MES, DAY(G.ElectronicBillingDate) DIA, 
			G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, --A.RequestNumber NumeroSolicitud, 
			vd.requestnumber1,-- vd.requestnumber2,
			A.RequestNumAlternative AS SolicitudExterna, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamCode AS CodigoExamen, C.ExamName AS NombreExamen, 
			--D.CUPS CUPS, 
			ISNULL(case when TS.Hiring = '' then null else ts.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 G.CUPS 
											from	TR_Service_Exam E 
													inner join TB_Service G on E.IdService = G.IdService 
											where	E.IdExam = C.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN E.TotalValuePatient ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN E.TotalValuePatient ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus AS EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion
	FROM TB_Request A
	INNER JOIN V_DuplicateRequest vd 
		on A.IdRequest = vd.idrequest1 or A.IdRequest = vd.idrequest2
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
	--INNER JOIN carehis.TB_Patient_Ext PA
	LEFT JOIN TB_Patient_Copi PA
		ON A.IdPatient = PA.IdPatient
	LEFT JOIN TB_IdentificationType IT
		ON PA.IdIdentificationType = IT.IdIdentificationType
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest AND B.Active=1 AND B.Value IS NOT NULL
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
	LEFT JOIN TB_TariffScheme t 
		on h.idtariffscheme = t.idtariffscheme
	LEFT JOIN TR_TariffScheme_Service ts 
		ON t.IdTariffScheme = ts.idtariffscheme and C.IdExam = ts.IdExam and H.idtariffscheme = ts.idtariffscheme
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	WHERE    (
        (@InitialDate != '' AND @FinalDate != '' AND A.RequestDate BETWEEN @InitialDate AND @FinalDate)
        OR
        (@InitialDate = '' AND @FinalDate = '')
    ) AND
    (
        (@InitialBillingDate != '' AND @FinalBillingDate != '' AND G.ElectronicBillingDate BETWEEN @InitialBillingDate AND @FinalBillingDate)
        OR
        (@InitialBillingDate = '' AND @FinalBillingDate = '')
    )
	AND CASE WHEN @IdCompany = '' THEN '' ELSE I.IdCompany END = @IdCompany
	AND CASE WHEN @IdContract = '' THEN '' ELSE H.IdContract END = @IdContract
	--and A.IdRequest = 313228

-- EXEC [Reports].[sp_HistoryDuplicateBillingReport] '2024-05-01','2024-05-30'

	UNION ALL

	SELECT	I.NIT, YEAR(G.ElectronicBillingDate) ANO, MONTH(G.ElectronicBillingDate) MES, DAY(G.ElectronicBillingDate) DIA,
			G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud,  --A.RequestNumber NumeroSolicitud, 
			vd.requestnumber1,-- vd.requestnumber2,
			A.RequestNumAlternative SolicitudExterna, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamGroupCode CodigoExamen, C.ExamGroupName NombreExamen, 
			--D.CUPS CUPS, 
			ISNULL(case when TS.Hiring = '' then null else ts.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 G.CUPS 
											from	TR_Service_Exam E 
													inner join TB_Service G on E.IdService = G.IdService 
											where	E.IdExam = C.IdExamGroup And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN E.TotalValuePatient ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN E.TotalValuePatient ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion
	FROM TB_Request A
	INNER JOIN V_DuplicateRequest vd 
		on A.IdRequest = vd.idrequest1 or A.IdRequest = vd.idrequest2
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
--	INNER JOIN carehis.TB_Patient_Ext PA
	LEFT JOIN TB_Patient_Copi PA
		ON A.IdPatient = PA.IdPatient
	LEFT JOIN TB_IdentificationType IT
		ON PA.IdIdentificationType = IT.IdIdentificationType
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest AND B.Active=1 AND B.Value IS NOT NULL
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
	LEFT JOIN TB_TariffScheme t 
		on h.idtariffscheme = t.idtariffscheme
	LEFT JOIN TR_TariffScheme_Service ts 
		ON t.IdTariffScheme = ts.idtariffscheme and C.IdExamGroup = ts.IdExam and H.idtariffscheme = ts.idtariffscheme
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	WHERE (
        (@InitialDate != '' AND @FinalDate != '' AND A.RequestDate BETWEEN @InitialDate AND @FinalDate)
        OR
        (@InitialDate = '' AND @FinalDate = '')
    ) AND
    (
        (@InitialBillingDate != '' AND @FinalBillingDate != '' AND G.ElectronicBillingDate BETWEEN @InitialBillingDate AND @FinalBillingDate)
        OR
        (@InitialBillingDate = '' AND @FinalBillingDate = '')
    )
	AND CASE WHEN @IdCompany = '' THEN '' ELSE I.IdCompany END = @IdCompany
	AND CASE WHEN @IdContract = '' THEN '' ELSE H.IdContract END = @IdContract
	--and A.IdRequest = 313228

	ORDER BY A.RequestDate ASC
END
GO
