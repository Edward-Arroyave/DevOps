SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/09/2022
-- Description: Procedimiento almacenado para consultar solicitudes.
-- =============================================
-- EXEC [sp_Consult_BillingOfSale] '','','1','1','','JOSE BENITO ESCOBAR SOTO'
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_BillingOfSale]
(
	@InitialDate datetime,
	@FinalDate datetime,
	@IdAdmissionSource varchar(1),
	@IdBillingOfSaleStatus varchar(1),
	@AttentionCenter varchar(5),
	@PatientName varchar (50) = '',
	@PageSize INT = 200,
	@NumberPage int = 1
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
	declare @SKIPPEDROWS INT, @OriginalSize int
BEGIN
    SET NOCOUNT ON

	SET @OriginalSize = 200
	SET @SKIPPEDROWS = (@NumberPage-1)*@OriginalSize

	IF @InitialDate != '' AND @FinalDate != ''
		BEGIN
			SET @InitialDateTime = @InitialDate
			SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		END
	ELSE
		BEGIN
			SET @InitialDateTime = '' 
			SET @FinalDateTime = ''
		END
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 06/02/2024
-- Description: Se quita el top en la consulta debido a agregacion de paginacion de resultados y se agrega a la consulta COUNT(*) OVER () TotalRecords
-- Pruebas:		Realizadas con El Inge Willinton Morales
-- Antes:	SELECT TOP 400 C.IdBillingOfSale
-- Ahora:	SELECT C.IdBillingOfSale
-- =============================================
-- EXEC [sp_Consult_BillingOfSale] '','','','',''

	SELECT IdentificationNumber,IdPatient, IdIdentificationType,FirstName, SecondName, FirstLastName, SecondLastName 
	INTO #Patient
	FROM carehis.TB_Patient_Ext

	SELECT	 C.IdBillingOfSale, I.InvoiceNumber, I.InvoiceFile, A.IdRequest, A.RequestNumber, M.AttentionCenterName, A.IdPatient, C.IdElectronicBilling, C.BillingOfSaleDate, 
			I.ERPBillingDate, I.ElectronicBillingDate, E.AdmissionSource, G.IdBillingOfSaleStatus, G.BillingOfSaleStatus, I.IdInvoiceStatus, J.InvoiceStatus, I.IdTransactionStatus, 
			K.TransactionStatus, A.RequestNumAlternative, L.IdContractType, CONCAT_WS(' ', P.FirstName, P.SecondName, P.FirstLastName, P.SecondLastName) AS PatientName, 
			CONCAT_WS(' - ', O.IdentificationTypeCode, P.IdentificationNumber) AS IdentificationNumber, count(C.IdBillingOfSale) OVER() TotalRecords
	FROM TB_Request A
	INNER JOIN TR_BillingOfSale_Request B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TB_BillOfSalePayment D
		ON D.IdBillingOfSale = C.IdBillingOfSale
	INNER JOIN TB_AdmissionSource E
		ON E.IdAdmissionSource = A.IdAdmissionSource
	INNER JOIN TB_BillingOfSaleStatus G
		ON G.IdBillingOfSaleStatus = C.IdBillingOfSaleStatus
	INNER JOIN TB_Contract L
		ON L.IdContract = A.IdContract
	INNER JOIN TB_AttentionCenter M
		ON M.IdAttentionCenter = A.IdAttentionCenter
	--INNER JOIN carehis.TB_Patient_Ext P
	INNER JOIN #Patient P
		ON A.IdPatient=P.IdPatient
	INNER JOIN carehis.TB_IdentificationType_Ext O
		ON P.IdIdentificationType=O.IdIdentificationType
	LEFT JOIN TR_PreBilling_BillingOfSale F
		ON F.IdBillingOfSale = C.IdBillingOfSale
	LEFT JOIN TB_PreBilling H
		ON H.IdPreBilling = F.IdPreBilling
	LEFT JOIN TB_ElectronicBilling I
		ON I.IdElectronicBilling = H.IdElectronicBilling
			OR I.IdElectronicBilling = C.IdElectronicBilling
	LEFT JOIN TB_InvoiceStatus J
		ON J.IdInvoiceStatus = I.IdInvoiceStatus
	LEFT JOIN TB_TransactionStatus K
		ON K.IdTransactionStatus = I.IdTransactionStatus
	WHERE A.IdAdmissionSource != 5
		AND (((CASE WHEN L.IdContractType = 4 THEN C.IdBillingOfSaleStatus END IN (1,2))
			OR (CASE WHEN L.IdContractType IN (2,3) THEN C.IdBillingOfSaleStatus END != 1)
			OR (CASE WHEN L.IdContractType = 1 THEN C.IdBillingOfSaleStatus END ) BETWEEN 1 AND 7))
		AND ((RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
		AND (@InitialDateTime != '' OR @FinalDateTime != '')
			OR (@InitialDateTime = '' AND @FinalDateTime = ''))
	-- =============================================
	-- Author:      César Orlando Jiménez Muñoz
	-- Create Date: 06/02/2024
	-- Description: Se agrega filtro por los nombres y apellidos
	-- Pruebas:		Realizadas con El Inge Willinton Morales
	-- Antes:	SELECT TOP 400 C.IdBillingOfSale
	-- Ahora:	SELECT C.IdBillingOfSale
	-- =============================================
	-- EXEC [sp_Consult_BillingOfSale] '','','','','','pru'
			and (CONCAT_WS(' ', P.FirstName, P.SecondName, P.FirstLastName, P.SecondLastName) like '%'+@PatientName+'%'
			or A.RequestNumber like '%'+@PatientName+'%'
			or CONCAT_WS(' - ', O.IdentificationTypeCode, P.IdentificationNumber) like '%'+@PatientName+'%')
			AND CASE WHEN @IdAdmissionSource = '' THEN '' ELSE A.IdAdmissionSource END = @IdAdmissionSource
			AND CASE WHEN @IdBillingOfSaleStatus = '' THEN '' ELSE C.IdBillingOfSaleStatus END = @IdBillingOfSaleStatus
			AND CASE WHEN @AttentionCenter = '' THEN '' ELSE A.IdAttentionCenter END = @AttentionCenter	
	group by C.IdBillingOfSale, I.InvoiceNumber, I.InvoiceFile, A.IdRequest, A.RequestNumber, M.AttentionCenterName, A.IdPatient, C.IdElectronicBilling, C.BillingOfSaleDate, 
				I.ERPBillingDate, I.ElectronicBillingDate, E.AdmissionSource, G.IdBillingOfSaleStatus, G.BillingOfSaleStatus, I.IdInvoiceStatus, J.InvoiceStatus, I.IdTransactionStatus, 
				K.TransactionStatus, A.RequestNumAlternative, L.IdContractType, CONCAT_WS(' ', P.FirstName, P.SecondName, P.FirstLastName, P.SecondLastName) , 
				CONCAT_WS(' - ', O.IdentificationTypeCode, P.IdentificationNumber)
	ORDER BY 1 DESC

	OFFSET @SKIPPEDROWS ROWS
	FETCH NEXT @PageSize ROWS ONLY

END
GO
