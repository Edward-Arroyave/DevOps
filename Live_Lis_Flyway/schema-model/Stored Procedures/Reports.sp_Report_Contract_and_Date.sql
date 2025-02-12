SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/05/2022
-- Description: Procedimiento almacenado para generar reporte "Reporte por Plan y Fecha".
-- =============================================
-- EXEC [Reports].[sp_Report_Contract_and_Date] '2024-03-18','2024-03-18'
-- =============================================
CREATE PROCEDURE [Reports].[sp_Report_Contract_and_Date]
(
	@InitialDate date,
	@FinalDate date
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime, @ConsultSQL NVARCHAR(4000), @Contract varchar(50)
BEGIN
    SET NOCOUNT ON
	
	SET @InitialDateTime = @InitialDate
	SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))

	SET @ConsultSQL = 'SELECT DISTINCT CONVERT(varchar(6), A.RequestDate,112) AS Month, CONVERT(varchar(10), A.RequestDate,112) AS Prefijo, A.RequestNumber, A.IdPatient,
							F.InvoiceNumber, F.ElectronicBillingDate, ISNULL(F.TotalValue, E.TotalValueCompany) AS TotalValue, B.contractcode as IdContract, B.ContractName
						FROM TB_Request A
						INNER JOIN TB_Contract B
							ON B.IdContract = A.IdContract
						INNER JOIN TR_BillingOfSale_Request G
							ON G.IdRequest = A.IdRequest
						INNER JOIN TB_BillingOfSale E
							ON E.IdBillingOfSale = G.IdBillingOfSale
						LEFT JOIN TB_ElectronicBilling F
							ON F.IdElectronicBilling = E.IdElectronicBilling
						WHERE CONVERT(varchar(25),A.RequestDate,20) BETWEEN '''+CONVERT(varchar(25),@InitialDateTime,20)+''' AND '''+CONVERT(varchar(25),@FinalDateTime,20)+'''
						ORDER BY 1'

	EXEC (@ConsultSQL)

END
GO
