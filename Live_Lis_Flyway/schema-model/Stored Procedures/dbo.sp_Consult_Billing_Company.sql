SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/09/2022
-- Description: Procedimientos almacenado para consultar información de facturas de entidades.
-- =============================================
-- EXEC [sp_Consult_Billing_Company] '1760','5493','','','2024-03-23','2024-03-23'
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Billing_Company]
(
	@IdCompany varchar(10), 
	@IdContract varchar(10),
	@IdServiceType varchar(10),
	@Service varchar(100),
	@InitialDate varchar(20),
	@FinalDate varchar(20)
)
AS
	DECLARE @ConsultSQL NVARCHAR(4000)

	
BEGIN
    SET NOCOUNT ON

	SET @ConsultSQL = 'SELECT DISTINCT A.IdBillingOfSale, C.IdContractType, D.CompanyName, C.ContractName, A.IdPatient, 
							B.IdRequest, B.RequestNumber, ISNULL(A.TotalValuePatient,0) Copay_CM,
							--K.TotalValueCompany as ServiceValue, 
							(select sum(isnull(value,0)) from tr_request_exam where idrequest = b.idrequest and active = 1) ServiceValue,
							C.BillToParticular
						FROM TR_BillingOfSale_Request K
						INNER JOIN TB_BillingOfSale A
							ON A.IdBillingOfSale=k.IdBillingOfSale
						INNER JOIN TB_Request B
							ON B.IdRequest = K.IdRequest
						INNER JOIN TB_Contract C
							ON C.IdContract = B.IdContract
						INNER JOIN TB_Company D
							ON D.IdCompany = C.IdCompany
						INNER JOIN TR_Request_Exam E
							ON E.IdRequest = B.IdRequest
								AND E.Active = ''True''
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 29/01/2024
-- Description: se cambia el tipo de union de inner a left para actualizaacion de proceso de facturacion con separacion de servicios
-- Pruebas: Realizadas con la Ingeniera María Paula Rondón
-- Antes: INNER JOIN TB_Exam F
-- Ahora: LEFT JOIN TB_Exam F
-- =============================================
						LEFT JOIN TB_Exam F
							ON F.IdExam = E.IdExam
						LEFT JOIN TR_Service_Exam G
							ON G.IdExam = F.IdExam
						LEFT JOIN TB_Service H
							ON H.IdService = G.IdService
						LEFT JOIN TB_ServiceType J
							ON J.IdServiceType = H.IdServiceType
						WHERE C.IdContractType IN (2,3,4)
							AND A.PreBilling = ''False''
							AND B.IdRequestStatus != 2
							AND D.IdCompany = ' + @IdCompany +'
							AND C.IdContract = ' +@IdContract +'
							AND CASE WHEN CONVERT(varchar(5),'''+@IdServiceType+''') = '''' THEN '''' ELSE CONVERT(varchar(5),H.IdServiceType,20)  END = ''' +@IdServiceType+'''
						--	AND ((CONVERT(varchar(10),A.BillingOfSaleDate,20) BETWEEN CONVERT(VARCHAR(10),'''+@InitialDate+''',20) AND CONVERT(VARCHAR(10),'''+@FinalDate+''',20))
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 28/06/2024
-- Description: se cambia la consulta contra la fecha de la tabla billingof sale por la de la tabla request para filtrar por fechas de solicitud
-- Pruebas: Se ajusta en caso presentado validado con el Inge Oscar Gil
-- Antes: AND ((CONVERT(varchar(10),A.BillingOfSaleDate,20) BETWEEN CONVERT(VARCHAR(10),'''+@InitialDate+''',20) AND CONVERT(VARCHAR(10),'''+@FinalDate+''',20))
-- Ahora: AND ((CONVERT(varchar(10),B.RequestDate,20) BETWEEN CONVERT(VARCHAR(10),'''+@InitialDate+''',20) AND CONVERT(VARCHAR(10),'''+@FinalDate+''',20))
-- =============================================
								AND ((CONVERT(varchar(10),B.RequestDate,20) BETWEEN CONVERT(VARCHAR(10),'''+@InitialDate+''',20) AND CONVERT(VARCHAR(10),'''+@FinalDate+''',20))
								AND ('''+@InitialDate+''' !='''' OR '''+@FinalDate+''' != '''')   
									OR ('''+@InitialDate+''' ='''' AND '''+@FinalDate+''' = '''')
								--	OR CONVERT(varchar(10),B.RequestDate,20) > = '''+@InitialDate+'''
									)
						GROUP BY A.IdBillingOfSale, B.RequestNumber, C.IdContractType, D.CompanyName, C.ContractName, B.IdRequest, A.IdPatient, C.BillToParticular, K.TotalValueCompany, A.TotalValuePatient'

				
	EXEC (@ConsultSQL)
print	@ConsultSQL
END

GO
