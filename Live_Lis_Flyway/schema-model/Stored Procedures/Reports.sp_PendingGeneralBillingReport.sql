SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec [Reports].[sp_PendingGeneralBillingReport] '2024-05-01','2024-05-30'
*/
CREATE PROCEDURE [Reports].[sp_PendingGeneralBillingReport]
(
	@InitialDate date = '',
	@FinalDate date = ''
)
AS
	DECLARE @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

		--SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		SET @FinalDateTime = DATEADD(DAY,1,@FinalDate)
		set @FinalDate = DATEADD(DAY,1,@FinalDate)

		--select IdentificationNumber,IdPatient, IdIdentificationType,FirstName, SecondName, FirstLastName, SecondLastName 
		--into #Patient
		--from carehis.TB_Patient_Ext

	SELECT	YEAR(A.RequestDate) ANO, MONTH(A.RequestDate) MES, CONCAT(YEAR(A.RequestDate),MONTH(A.RequestDate)) ANO_MES, I.CompanyName, I.NIT, 
			K.PaymentMethodName FORMA_DE_PAGO, H.IDSELLERCODE CODIGO_VENDEDOR, L.BillingGroup GRUPO_DE_FACTURACION, CT.CommercialZoneName ZONA, CIU.CITYNAME CIUDAD, 
			SUM(B.Value) PRECIO_ITEM, H.CONTRACTCODE IDPLAN, H.CONTRACTNAME NOMBRE_PLAN, DL.ContractDeadline PLAZO_DE_CREDITO,
			concat(SC.SellerCode ,' - ', sc.advisory) CODIGO_VENDEDOR
	FROM TB_Request A
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
	--INNER JOIN carehis.TB_Patient_Ext PA
	--INNER JOIN #Patient PA
	--	ON A.IdPatient = PA.IdPatient
	--INNER JOIN TB_IdentificationType IT
	--	ON PA.IdIdentificationType = IT.IdIdentificationType
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest
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
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	LEFT JOIN TB_CommercialZone CT 
		ON I.IdCommercialZone = CT.IdCommercialZone
	LEFT JOIN TB_City CIU 
		ON CIU.IDCITY = H.IDCITY
	LEFT JOIN TB_ContractDeadline DL
		ON DL.IdContractDeadline = H.IdContractDeadline
	LEFT JOIN TB_SELLERCODE SC
		ON H.IDSELLERCODE = SC.IDSELLERCODE
	WHERE	--A.RequestDate BETWEEN @InitialDate AND @FinalDate
			A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDate
	AND (G.ElectronicBillingDate IS NULL OR J.InvoiceStatus IS NULL AND F.IdElectronicBilling IS NULL OR J.IdInvoiceStatus =3)
	GROUP BY YEAR(A.RequestDate) , MONTH(A.RequestDate) , CONCAT(YEAR(A.RequestDate),MONTH(A.RequestDate)) , I.CompanyName, I.NIT, K.PaymentMethodName , 
			H.IDSELLERCODE , L.BillingGroup , CT.CommercialZoneName , CIU.CITYNAME , H.CONTRACTCODE ,	H.CONTRACTNAME , DL.ContractDeadline ,
			concat(SC.SellerCode ,' - ', sc.advisory) 

	UNION ALL

	SELECT	YEAR(A.RequestDate) ANO, MONTH(A.RequestDate) MES, CONCAT(YEAR(A.RequestDate),MONTH(A.RequestDate)) ANO_MES, I.CompanyName, I.NIT, K.PaymentMethodName FORMA_DE_PAGO, 
			H.IDSELLERCODE CODIGO_VENDEDOR, L.BillingGroup GRUPO_DE_FACTURACION, CT.CommercialZoneName ZONA, CIU.CITYNAME CIUDAD, SUM(B.Value) PRECIO_ITEM, H.CONTRACTCODE IDPLAN,
			H.CONTRACTNAME NOMBRE_PLAN, DL.ContractDeadline PLAZO_DE_CREDITO,
			concat(SC.SellerCode ,' - ', sc.advisory) CODIGO_VENDEDOR
	FROM TB_Request A
	INNER JOIN TB_AttentionCenter bc 
		ON A.idattentioncenter = bc.IdAttentionCenter
	LEFT JOIN TB_RequestStatus N 
		ON N.IdRequestStatus = A.IdRequestStatus
	--INNER JOIN carehis.TB_Patient_Ext PA
	--INNER JOIN #Patient PA
	--	ON A.IdPatient = PA.IdPatient
	--INNER JOIN TB_IdentificationType IT
	--	ON PA.IdIdentificationType = IT.IdIdentificationType
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest
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
	LEFT JOIN TB_Service D
		ON D.IdService = B.IdService
	LEFT JOIN TB_PaymentMethod K
		ON K.IdPaymentMethod = H.IdPaymentMethod
	LEFT JOIN TB_BillingGroup L
		ON L.IdBillingGroup = H.IdBillingGroup
	LEFT JOIN TB_CommercialZone CT 
		ON I.IdCommercialZone = CT.IdCommercialZone
	LEFT JOIN TB_City CIU 
		ON CIU.IDCITY = H.IDCITY
	LEFT JOIN TB_ContractDeadline DL
		ON DL.IdContractDeadline = H.IdContractDeadline
	LEFT JOIN TB_SELLERCODE SC
		ON H.IDSELLERCODE = SC.IDSELLERCODE
	WHERE	--A.RequestDate BETWEEN @InitialDate AND @FinalDate
			A.RequestDate >= @InitialDate AND A.RequestDate < @FinalDate
	AND (G.ElectronicBillingDate IS NULL OR J.InvoiceStatus IS NULL AND F.IdElectronicBilling IS NULL OR J.IdInvoiceStatus =3)
	GROUP BY YEAR(A.RequestDate) , MONTH(A.RequestDate) ,CONCAT(YEAR(A.RequestDate),MONTH(A.RequestDate)) ,I.CompanyName,  I.NIT, K.PaymentMethodName , 
			H.IDSELLERCODE , L.BillingGroup , CT.CommercialZoneName , CIU.CITYNAME , H.CONTRACTCODE ,	H.CONTRACTNAME , DL.ContractDeadline ,
			concat(SC.SellerCode ,' - ', sc.advisory) 
END
GO
