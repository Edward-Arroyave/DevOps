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
EXEC [Reports].[sp_BillingReport2] '2022-06-01','2024-10-01'
*/
-- =============================================
CREATE PROCEDURE [Reports].[sp_BillingReport2]
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

	SELECT	G.ElectronicBillingDate FechaFactura, G.InvoiceNumber NumeroFactura, FI.FilingDate Fecha_Radicacion, FI.IdFiling Numero_Radicacion, SUM(B.Value) Valor,
			H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.NIT, L.BillingGroup GrupoFacturacion, K.PaymentMethodName FormaDePago, SE.Advisory Nombre_Codigo_Vendedor,
			MG.Marketgroup Nombre_Grupo_De_Mercado, CS.CompanySegment Nombre_Segmento, U.UserName, J.InvoiceStatus EstadoFactura
			/*G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, 
			A.RequestNumAlternative AS SolicitudExterna, A.IdPatient, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamCode AS CodigoExamen, C.ExamName AS NombreExamen, 
			D.CUPS CUPS, G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN B.Copay_CM ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN B.Copay_CM ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus AS EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion*/
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
	LEFT JOIN tb_sellercode SE 
		ON H.IdSellerCode = SE.idsellercode
	INNER JOIN TB_Company I
		ON I.IdCompany = H.IdCompany
	LEFT JOIN tb_marketgroup MG
		ON I.idmarketgroup = MG.idmarketgroup
	LEFT JOIN tb_companysegment CS
		ON I.IdCompanySegment = CS.IdCompanySegment
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = F.IdElectronicBilling
	LEFT JOIN TB_User U
		ON G.IdUserAction = U.IdUser
	LEFT JOIN TB_InvoiceFiling FIL
		ON G.IdElectronicBilling = FIL.IdElectronicBilling
	LEFT JOIN TB_Filing FI 
		ON FI.IdFiling = FIL.IdFiling
	LEFT JOIN TB_InvoiceStatus J
		ON J.IdInvoiceStatus = G.IdInvoiceStatus
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	--WHERE A.RequestDate BETWEEN @InitialDate AND @FinalDateTime
	WHERE A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDateTime
	group by G.ElectronicBillingDate , G.InvoiceNumber , FI.FilingDate , FI.IdFiling ,
			H.ContractCode , H.ContractName , I.NIT, L.BillingGroup , K.PaymentMethodName , SE.Advisory ,
			MG.Marketgroup , CS.CompanySegment , U.UserName, J.InvoiceStatus 

	UNION ALL

	SELECT	G.ElectronicBillingDate FechaFactura, G.InvoiceNumber NumeroFactura, FI.FilingDate Fecha_Radicacion, FI.IdFiling Numero_Radicacion, SUM(B.Value) Valor,
			H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.NIT, L.BillingGroup GrupoFacturacion, K.PaymentMethodName FormaDePago, SE.Advisory Nombre_Codigo_Vendedor,
			MG.Marketgroup Nombre_Grupo_De_Mercado, CS.CompanySegment Nombre_Segmento, U.UserName, J.InvoiceStatus EstadoFactura
			/*G.ElectronicBillingDate FechaFactura, G.ERPBillingDate FechaRecepcion, A.RequestDate FechaSolicitud, A.RequestNumber NumeroSolicitud, 
			A.RequestNumAlternative SolicitudExterna, A.IdPatient, CONCAT_WS('', pa.FirstName, ' ', pa.SecondName, ' ', pa.FirstLastName, ' ', pa.SecondLastName) AS Paciente, 
			it.IdentificationTypeCode Identificacion, pa.identificationnumber NumeroIdentificacion,	C.ExamGroupCode CodigoExamen, C.ExamGroupName NombreExamen, 
			D.CUPS CUPS, G.InvoiceNumber NumeroFactura, B.Value Valor, CASE WHEN B.IdGenerateCopay_CM = 2 THEN B.Copay_CM ELSE 0 END Copago,
			CASE WHEN B.IdGenerateCopay_CM = 3 THEN B.Copay_CM ELSE 0 END CM, H.ContractCode CodigoPlan, H.ContractName NombrePlan, I.CompanyName Tercero, N.RequestStatus EstadoSoliciutd,
			J.InvoiceStatus EstadoFactura, bc.AttentionCenterName Sede, K.PaymentMethodName FormaDePago, L.BillingGroup GrupoFacturacion*/
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
	LEFT JOIN tb_sellercode SE 
		ON H.IdSellerCode = SE.idsellercode
	INNER JOIN TB_Company I 
		ON I.IdCompany = H.IdCompany
	LEFT JOIN tb_marketgroup MG
		ON I.idmarketgroup = MG.idmarketgroup
	LEFT JOIN tb_companysegment CS
		ON I.IdCompanySegment = CS.IdCompanySegment
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = F.IdElectronicBilling
	LEFT JOIN TB_User U
		ON G.IdUserAction = U.IdUser
	LEFT JOIN TB_InvoiceFiling FIL
		ON G.IdElectronicBilling = FIL.IdElectronicBilling
	LEFT JOIN TB_Filing FI 
		ON FI.IdFiling = FIL.IdFiling
	LEFT JOIN TB_InvoiceStatus J
		ON J.IdInvoiceStatus = G.IdInvoiceStatus
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	--WHERE A.RequestDate BETWEEN @InitialDate AND @FinalDateTime
	WHERE A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDateTime
	group by G.ElectronicBillingDate , G.InvoiceNumber , FI.FilingDate , FI.IdFiling ,
			H.ContractCode , H.ContractName , I.NIT, L.BillingGroup , K.PaymentMethodName , SE.Advisory ,
			MG.Marketgroup , CS.CompanySegment , U.UserName, J.InvoiceStatus 
--	ORDER BY A.RequestDate ASC
END
GO
