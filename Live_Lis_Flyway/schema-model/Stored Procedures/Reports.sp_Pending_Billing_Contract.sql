SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/05/2022
-- Description: Procedimiento almacenado para retornar atenciones realizadas durante determinado segmento de tiempo.
-- =============================================
--

/*
EXEC [Reports].[sp_Pending_Billing_Contract] '2024-06-15','2024-06-15'
*/
-- =============================================
CREATE PROCEDURE [Reports].[sp_Pending_Billing_Contract]
(
	@InitialDate date,
	@FinalDate date
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime, @ConsultSQL NVARCHAR(4000)
BEGIN
    SET NOCOUNT ON

	SET @InitialDateTime = @InitialDate
	SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))

	SET @ConsultSQL = 'SELECT E.RequestDate, E.RequestNumber, F.Value AS ServiceValue, C.TotalValueCompany AS TotalValue, G.UserName, A.IdAttentionCenter, H.AttentionCenterName, 
							E.IdContract, I.ContractName
						FROM TB_BillingBox A
						INNER JOIN TB_BillOfSalePayment B
							ON B.IdBillingBox = A.IdBillingBox
						INNER JOIN TB_BillingOfSale C
							ON C.IdBillingOfSale = B.IdBillingOfSale
						INNER JOIN TR_BillingOfSale_Request D
							ON D.IdRequest = C.IdRequest
						INNER JOIN TB_Request E
							ON E.IdRequest = D.IdRequest
						INNER JOIN TR_Request_Exam F
							ON F.IdRequest = E.IdRequest
						INNER JOIN TB_User G
							ON G.IdUser = A.IdUser
						INNER JOIN TB_AttentionCenter H
							ON H.IdAttentionCenter = A.IdAttentionCenter
						INNER JOIN TB_Contract I
							ON I.IdContract = E.IdContract
						WHERE B.Active = ''True''
							AND CONVERT(varchar(25),E.RequestDate,20) BETWEEN '''+CONVERT(varchar(25),@InitialDateTime,20)+''' AND '''+CONVERT(varchar(25),@FinalDateTime,20)+''''

	EXEC (@ConsultSQL)							
END
GO
