SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Reports].[sp_CreateHistoryBillingReport]
(
	@InitialDate date = null,
	@FinalDate date = null
)
AS
-- =============================================
-- Author:      Rodolfo Enrique Torres Caballero
-- Create Date: 28/10/2024
-- Description: Procedimiento almacenado para generar información que se guarda en la tabla principal del reporte historico de facturación con factura electronica.
-- =============================================
/*
EXEC [Reports].[sp_CreateHistoryBillingReport]
*/
-- =============================================
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.TB_HistoryBillingReport
    SELECT 
        I.IdCompany, 
        H.IdContract, 
        B.IdRequest_Exam,
        E.IdBillingOfSale_Request,
        I.NIT, 
        YEAR(G.ElectronicBillingDate) AS ANO, 
        MONTH(G.ElectronicBillingDate) AS MES, 
        DAY(G.ElectronicBillingDate) AS DIA, 
        G.ElectronicBillingDate AS FechaFactura, 
        G.ERPBillingDate AS FechaRecepcion, 
        A.RequestDate AS FechaSolicitud, 
        A.RequestNumber AS NumeroSolicitud, 
        A.RequestNumAlternative AS SolicitudExterna, 
        CONCAT_WS('', PA.FirstName, ' ', PA.SecondName, ' ', PA.FirstLastName, ' ', PA.SecondLastName) AS Paciente, 
        IT.IdentificationTypeCode AS Identificacion, 
        PA.IdentificationNumber AS NumeroIdentificacion, 
        C.ExamCode AS CodigoExamen, 
        C.ExamName AS NombreExamen,
        ISNULL(CASE WHEN TSS.Hiring = '' THEN NULL ELSE TSS.Hiring END, 
               ISNULL(CASE WHEN D.CUPS = '' THEN NULL ELSE D.CUPS END, 
                      (SELECT TOP 1 S.CUPS 
                       FROM dbo.TR_Service_Exam E 
                       INNER JOIN dbo.TB_Service S ON E.IdService = S.IdService 
                       WHERE E.IdExam = C.IdExam AND E.Active = 1 AND E.Principal = 1))) AS CUPS,
        G.InvoiceNumber AS NumeroFactura, 
        B.Value AS Valor, 
        CASE WHEN B.IdGenerateCopay_CM = 2 THEN E.TotalValuePatient ELSE 0 END AS Copago,
        CASE WHEN B.IdGenerateCopay_CM = 3 THEN E.TotalValuePatient ELSE 0 END AS CM, 
        H.ContractCode AS CodigoPlan, 
        H.ContractName AS NombrePlan, 
        I.CompanyName AS Tercero, 
        N.RequestStatus AS EstadoSolicitud, 
        J.InvoiceStatus AS EstadoFactura, 
        BC.AttentionCenterName AS Sede, 
        K.PaymentMethodName AS FormaDePago, 
        L.BillingGroup AS GrupoFacturacion,
		TSS.Hiring CodigoContratacion
    FROM dbo.TB_Request A
    INNER JOIN dbo.TB_AttentionCenter BC ON A.IdAttentionCenter = BC.IdAttentionCenter
    LEFT JOIN dbo.TB_RequestStatus N ON N.IdRequestStatus = A.IdRequestStatus
    LEFT JOIN dbo.TB_Patient_Copi PA ON A.IdPatient = PA.IdPatient
    LEFT JOIN dbo.TB_IdentificationType IT ON PA.IdIdentificationType = IT.IdIdentificationType
    INNER JOIN dbo.TR_Request_Exam B ON B.IdRequest = A.IdRequest AND B.Active = 1 AND B.Value IS NOT NULL
    INNER JOIN dbo.TB_Exam C ON C.IdExam = B.IdExam
    INNER JOIN dbo.TR_BillingOfSale_Request E ON E.IdRequest = A.IdRequest
    INNER JOIN dbo.TB_BillingOfSale F ON F.IdBillingOfSale = E.IdBillingOfSale
    INNER JOIN dbo.TB_Contract H ON H.IdContract = A.IdContract
    INNER JOIN dbo.TB_Company I ON I.IdCompany = H.IdCompany
    LEFT JOIN dbo.TB_ElectronicBilling G ON G.IdElectronicBilling = F.IdElectronicBilling
    LEFT JOIN dbo.TB_InvoiceStatus J ON J.IdInvoiceStatus = G.IdInvoiceStatus
    INNER JOIN dbo.TB_TariffScheme TS ON H.IdTariffScheme = TS.IdTariffScheme
    LEFT JOIN dbo.TR_TariffScheme_Service TSS ON TS.IdTariffScheme = TSS.IdTariffScheme AND C.IdExam = TSS.IdExamGroup AND TSS.Active = 1
    LEFT JOIN dbo.TB_Service D ON D.IdService = B.IdService
    LEFT JOIN dbo.TB_PaymentMethod K ON K.IdPaymentMethod = H.IdPaymentMethod
    LEFT JOIN dbo.TB_BillingGroup L ON L.IdBillingGroup = H.IdBillingGroup
    WHERE  (cast(A.RequestDate as date) between isnull(@InitialDate, cast(A.RequestDate as date)) and isnull(@FinalDate, cast(A.RequestDate as date)))
	AND NOT EXISTS 
        (SELECT 1 
         FROM dbo.TB_HistoryBillingReport HBR
         WHERE HBR.NumeroSolicitud = A.RequestNumber
           AND HBR.CodigoExamen = C.ExamCode
           AND HBR.IdRequest_Exam = B.IdRequest_Exam
           AND HBR.IdBillingOfSale_Request = E.IdBillingOfSale_Request)
    UNION ALL
    SELECT 
        I.IdCompany, 
        H.IdContract, 
        B.IdRequest_Exam,
        E.IdBillingOfSale_Request,
        I.NIT, 
        YEAR(G.ElectronicBillingDate) AS ANO, 
        MONTH(G.ElectronicBillingDate) AS MES, 
        DAY(G.ElectronicBillingDate) AS DIA, 
        G.ElectronicBillingDate AS FechaFactura, 
        G.ERPBillingDate AS FechaRecepcion, 
        A.RequestDate AS FechaSolicitud, 
        A.RequestNumber AS NumeroSolicitud, 
        A.RequestNumAlternative AS SolicitudExterna, 
        CONCAT_WS('', PA.FirstName, ' ', PA.SecondName, ' ', PA.FirstLastName, ' ', PA.SecondLastName) AS Paciente, 
        IT.IdentificationTypeCode AS Identificacion, 
        PA.IdentificationNumber AS NumeroIdentificacion, 
        C.ExamGroupCode AS CodigoExamen, 
        C.ExamGroupName AS NombreExamen,
        ISNULL(CASE WHEN TSS.Hiring = '' THEN NULL ELSE TSS.Hiring END, 
               ISNULL(CASE WHEN D.CUPS = '' THEN NULL ELSE D.CUPS END, 
                      (SELECT TOP 1 S.CUPS 
                       FROM dbo.TR_Service_Exam E 
                       INNER JOIN dbo.TB_Service S ON E.IdService = S.IdService 
                       WHERE E.IdExam = C.IdExamGroup AND E.Active = 1 AND E.Principal = 1))) AS CUPS,
        G.InvoiceNumber AS NumeroFactura, 
        B.Value AS Valor, 
        CASE WHEN B.IdGenerateCopay_CM = 2 THEN E.TotalValuePatient ELSE 0 END AS Copago,
        CASE WHEN B.IdGenerateCopay_CM = 3 THEN E.TotalValuePatient ELSE 0 END AS CM, 
        H.ContractCode AS CodigoPlan, 
        H.ContractName AS NombrePlan, 
        I.CompanyName AS Tercero, 
        N.RequestStatus AS EstadoSolicitud, 
        J.InvoiceStatus AS EstadoFactura, 
        BC.AttentionCenterName AS Sede, 
        K.PaymentMethodName AS FormaDePago, 
        L.BillingGroup AS GrupoFacturacion, 
		TSS.Hiring CodigoContratacion
    FROM dbo.TB_Request A
    INNER JOIN dbo.TB_AttentionCenter BC ON A.IdAttentionCenter = BC.IdAttentionCenter
    LEFT JOIN dbo.TB_RequestStatus N ON N.IdRequestStatus = A.IdRequestStatus
    LEFT JOIN dbo.TB_Patient_Copi PA ON A.IdPatient = PA.IdPatient
    LEFT JOIN dbo.TB_IdentificationType IT ON PA.IdIdentificationType = IT.IdIdentificationType
    INNER JOIN dbo.TR_Request_Exam B ON B.IdRequest = A.IdRequest AND B.Active = 1 AND B.Value IS NOT NULL
    INNER JOIN dbo.TB_ExamGroup C ON C.IdExamGroup = B.IdExamGroup
    INNER JOIN dbo.TR_BillingOfSale_Request E ON E.IdRequest = A.IdRequest
    INNER JOIN dbo.TB_BillingOfSale F ON F.IdBillingOfSale = E.IdBillingOfSale
    INNER JOIN dbo.TB_Contract H ON H.IdContract = A.IdContract
    INNER JOIN dbo.TB_Company I ON I.IdCompany = H.IdCompany
    LEFT JOIN dbo.TB_ElectronicBilling G ON G.IdElectronicBilling = F.IdElectronicBilling
    LEFT JOIN dbo.TB_InvoiceStatus J ON J.IdInvoiceStatus = G.IdInvoiceStatus
    INNER JOIN dbo.TB_TariffScheme TS ON H.IdTariffScheme = TS.IdTariffScheme
    LEFT JOIN dbo.TR_TariffScheme_Service TSS ON TS.IdTariffScheme = TSS.IdTariffScheme AND C.IdExamGroup = TSS.IdExamGroup AND TSS.Active = 1
    LEFT JOIN dbo.TB_Service D ON D.IdService = B.IdService
    LEFT JOIN dbo.TB_PaymentMethod K ON K.IdPaymentMethod = H.IdPaymentMethod
    LEFT JOIN dbo.TB_BillingGroup L ON L.IdBillingGroup = H.IdBillingGroup
    WHERE  (cast(A.RequestDate as date) between isnull(@InitialDate, cast(A.RequestDate as date)) and isnull(@FinalDate, cast(A.RequestDate as date)))
	AND NOT EXISTS 
        (SELECT 1 
         FROM dbo.TB_HistoryBillingReport HBR
         WHERE HBR.NumeroSolicitud = A.RequestNumber
           AND HBR.CodigoExamen = C.ExamGroupCode
           AND HBR.IdRequest_Exam = B.IdRequest_Exam
           AND HBR.IdBillingOfSale_Request = E.IdBillingOfSale_Request);
END;
GO
