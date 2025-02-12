SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Reports].[sp_ElectronicFilingReport]
(
    @InitialDate date = '',
 @FinalDate date = '',
 @InitialBillingDate date = '',
 @FinalBillingDate date = '',
 @IsAuditory bit = false
)
AS
 -- DECLARE @FinalDateTime datetime, @FinalBillingDateTime datetime
BEGIN
    SET NOCOUNT ON

 IF @InitialDate != '' AND @FinalDate != '' AND @IsAuditory = 1
 BEGIN 
  --SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
  SET @FinalDate = DATEADD(DAY,1,@FinalDate)
  --set @FinalDate = DATEADD(DAY,1,@FinalDate)
 END
 
 IF @InitialBillingDate != '' AND @FinalBillingDate != '' AND @IsAuditory = 1
 BEGIN
  --SET @FinalBillingDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@InitialBillingDate)))
  --SET @FinalBillingDateTime = DATEADD(DAY,1,@FinalBillingDate)
  SET @FinalBillingDate = DATEADD(DAY,1,@FinalBillingDate)
 END

 SELECT 
  DISTINCT
  A.ElectronicBillingDate AS FechaFactura,
  A.InvoiceNumber AS NumeroFactura,
  FORMAT(C.FilingDate, 'yyyy-MM-dd') AS FechaRadicacion,
  C.IdFiling AS NumeroRadicacion,
  --E.TotalValueCompany AS Valor, 
  A.TotalValue AS Valor,
  G.ContractCode AS IdPlan,
  G.ContractName AS NombrePlan,
  H.NIT AS Nit,
  I.BillingGroup AS NombreGrupoFacturacion,
  K.PaymentMethodName AS NombreFormaPago,
  CONCAT(L.SellerCode ,' - ', L.advisory) AS NombreCodigoVendedor,
  M.MarketGroup AS NombreGrupoMercado,
  N.CompanySegment AS NombreSegmento,
  CONCAT(Q.Name, ' ', Q.LastName) AS UsuarioFactura,
  P.InvoiceStatus AS EstadoFactura
 FROM TB_ElectronicBilling A
 INNER JOIN TB_InvoiceFiling B
  ON A.IdElectronicBilling = B.IdElectronicBilling
 INNER JOIN TB_Filing C
  ON B.IdFiling = C.IdFiling
 INNER JOIN TB_BillingOfSale D
  ON D.IdElectronicBilling = A.IdElectronicBilling
 INNER JOIN TR_BillingOfSale_Request E
  ON  D.IdBillingOfSale = E.IdBillingOfSale
 INNER JOIN TB_Request F
  ON E.IdRequest = F.IdRequest
 INNER JOIN TB_Contract G
  ON F.IdContract = G.IdContract
 INNER JOIN TB_Company H
  ON G.IdCompany = H.IdCompany
 LEFT JOIN TB_BillingGroup I
  ON G.IdBillingGroup = I.IdBillingGroup
 --LEFT JOIN TB_BillOfSalePayment J
 -- ON 
 --  D.IdBillingOfSale = J.IdBillingOfSale AND 
 --  J.Active = 1
 LEFT JOIN TB_PaymentMethod K
  ON G.IdPaymentMethod = K.IdPaymentMethod
 LEFT JOIN TB_SellerCode L
  ON G.IdSellerCode = L.IdSellerCode
 LEFT JOIN TB_MarketGroup M
  ON H.IdMarketGroup = M.IdMarketGroup
 LEFT JOIN TB_CompanySegment N
  ON H.IdCompanySegment = N.IdCompanySegment
 --INNER JOIN TR_Request_Exam O
 -- ON 
 --  F.IdRequest = O.IdRequest AND 
 --  O.Active = 1 AND 
 --  O.Value IS NOT NULL
 LEFT JOIN TB_InvoiceStatus P
  ON A.IdInvoiceStatus = P.IdInvoiceStatus
 LEFT JOIN TB_User Q
  ON A.IdUserAction = Q.IdUser
 WHERE
    ( 
        (@InitialDate != '' AND @FinalDate != '' AND F.RequestDate BETWEEN @InitialDate AND @FinalDate)
        OR
        (@InitialDate = '' AND @FinalDate = '')
    ) 
  AND
    (
  (@InitialBillingDate != '' AND @FinalBillingDate != '' AND A.ElectronicBillingDate >= @InitialBillingDate AND A.ElectronicBillingDate < @FinalBillingDate)
        OR
        (@InitialBillingDate = '' AND @FinalBillingDate = '')
    )
 ORDER BY A.ElectronicBillingDate ASC
END

GO
