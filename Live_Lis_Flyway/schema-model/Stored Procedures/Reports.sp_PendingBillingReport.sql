SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 30/04/2024
-- Description: Procedimiento almacenado para generar reporte de facturación con factura electronica.
-- =============================================
-- EXEC [Reports].[sp_PendingBillingReport] '2024-05-01','2024-05-15','',''
-- =============================================
CREATE PROCEDURE [Reports].[sp_PendingBillingReport]
(
	@InitialDate date = '',
	@FinalDate date = '',
	@IdCompany varchar (20) = '',
	@IdContract varchar(10) = ''
)
AS
	DECLARE @FinalDateTime datetime, @FinalBillingDateTime datetime
BEGIN
    SET NOCOUNT ON

	IF @InitialDate != '' AND @FinalDate != ''
	BEGIN 
		--SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		SET @FinalDateTime = DATEADD(DAY,1,@FinalDate)
		set @FinalDate = DATEADD(DAY,1,@FinalDate)
	END
	ELSE
	BEGIN
		SET @FinalDateTime = ''
	END

	--SELECT IdentificationNumber,IdPatient, IdIdentificationType,FirstName, SecondName, FirstLastName, SecondLastName 
	--INTO #Patient
	--FROM carehis.TB_Patient_Ext

	SELECT	YEAR(A.RequestDate) ANO, MONTH(A.RequestDate) MES, CONCAT(YEAR(A.RequestDate),MONTH(A.RequestDate)) ANO_MES,
			I.NIT, G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, 
			A.RequestNumAlternative AS SolicitudExterna, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamCode AS CodigoExamen, C.ExamName AS NombreExamen, 
			--D.CUPS CUPS, 
			ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 S.CUPS 
														from	TR_Service_Exam E 
																inner join TB_Service S on E.IdService = S.IdService 
														where	E.IdExam = C.IdExam And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN E.TotalValuePatient ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN E.TotalValuePatient ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus AS EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion, DL.ContractDeadline PLAZO_DE_CREDITO, 
			concat(SC.SellerCode ,' - ', sc.advisory) CODIGO_VENDEDOR,
			A.OrderingNumber NumeroOrdenamiento, CONCAT(CI.CIE10_Code4 , ' - ', CI.CIE10_Code4Name) Diagnostico, TSS.Hiring CodigoContratacion
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
	LEFT JOIN TB_ContractDeadline DL
		ON DL.IdContractDeadline = H.IdContractDeadline
	LEFT JOIN TB_CIE10_Code4 CI 
		ON A.idCIE10_Code4 = CI.IdCIE10_Code4
	LEFT JOIN TB_SELLERCODE SC
		ON H.IDSELLERCODE = SC.IDSELLERCODE
	WHERE	--(((A.RequestDate BETWEEN @InitialDate AND @FinalDateTime)
			(((A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDateTime)
				AND (@InitialDate != '' OR @FinalDateTime != '')
					OR (@InitialDate = '' AND @FinalDateTime = '')))
	AND CASE WHEN @IdCompany = '' THEN '' ELSE I.IdCompany END = @IdCompany
	AND CASE WHEN @IdContract = '' THEN '' ELSE H.IdContract END = @IdContract
	AND (G.ElectronicBillingDate IS NULL OR J.InvoiceStatus IS NULL AND F.IdElectronicBilling IS NULL OR J.IdInvoiceStatus =3)
	AND A.IdRequestStatus<>2


	UNION ALL

	SELECT	YEAR(A.RequestDate) ANO, MONTH(A.RequestDate) MES, CONCAT(YEAR(A.RequestDate),MONTH(A.RequestDate)) ANO_MES,
			I.NIT, G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, 
			A.RequestNumAlternative SolicitudExterna, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamGroupCode CodigoExamen, C.ExamGroupName NombreExamen, 
			--D.CUPS CUPS, 
			ISNULL(case when TSS.Hiring = '' then null else TSS.Hiring end,ISNULL(case when D.CUPS = '' then null else D.CUPS end, (	SELECT	TOP 1 S.CUPS 
														from	TR_Service_Exam E 
																inner join TB_Service S on E.IdService = S.IdService 
														where	E.IdExam = C.IdExamGroup And E.Active=1 and E.Principal=1))) AS CUPS,
			G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN E.TotalValuePatient ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN E.TotalValuePatient ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion, DL.ContractDeadline PLAZO_DE_CREDITO, 
			concat(SC.SellerCode ,' - ', sc.advisory) CODIGO_VENDEDOR,
			A.OrderingNumber NumeroOrdenamiento, CONCAT(CI.CIE10_Code4 , ' - ', CI.CIE10_Code4Name) Diagnostico, TSS.Hiring CodigoContratacion
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
	INNER JOIN TB_TariffScheme TS 
		ON H.idtariffscheme = TS.idtariffscheme
	LEFT JOIN TR_TariffScheme_Service TSS 
		ON ts.IdTariffScheme = TSS.idtariffscheme and C.IdExamGroup = TSS.IdExam and H.idtariffscheme = tss.idtariffscheme
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	LEFT JOIN TB_ContractDeadline DL
		ON DL.IdContractDeadline = H.IdContractDeadline
	LEFT JOIN TB_CIE10_Code4 CI 
		ON A.idCIE10_Code4 = CI.IdCIE10_Code4
	LEFT JOIN TB_SELLERCODE SC
		ON H.IDSELLERCODE = SC.IDSELLERCODE
	WHERE	--(((A.RequestDate BETWEEN @InitialDate AND @FinalDateTime)
			(((A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDateTime)
				AND (@InitialDate != '' OR @FinalDateTime != '')
					OR (@InitialDate = '' AND @FinalDateTime = '')))
	AND CASE WHEN @IdCompany = '' THEN '' ELSE I.IdCompany END = @IdCompany
	AND CASE WHEN @IdContract = '' THEN '' ELSE H.IdContract END = @IdContract
	AND (G.ElectronicBillingDate IS NULL OR J.InvoiceStatus IS NULL AND F.IdElectronicBilling IS NULL OR J.IdInvoiceStatus =3)
	AND A.IdRequestStatus<>2
	ORDER BY A.RequestDate ASC
END
GO
