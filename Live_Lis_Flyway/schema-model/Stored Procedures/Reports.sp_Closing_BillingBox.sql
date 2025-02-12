SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/02/2023
-- Description: Procedimiento almacenado para reporte de cierre de cajas.
-- =============================================
--EXEC [Reports].[sp_Closing_BillingBox] '2023-02-04', '2023-04-06'
-- =============================================
CREATE PROCEDURE [Reports].[sp_Closing_BillingBox]
(
	@InitialDate date,
	@FinalDate date
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime, @ConsultSQL NVARCHAR(4000), @User varchar(50)
BEGIN
    SET NOCOUNT ON

	SET @InitialDateTime = @InitialDate
	SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))

	SET @ConsultSQL = 'SELECT A.ClosingNumber, A.ClosingDate, A.BalancingDate, CONCAT_WS('' '',B.Name, B.LastName) Cashier, B.UserName, C.AttentionCenterName
						FROM TB_BillingBox A
						INNER JOIN TB_User B
							ON B.IdUser = A.IdUser
						INNER JOIN TB_AttentionCenter C
							ON C.IdAttentionCenter = A.IdAttentionCenter
						WHERE A.BillingBoxStatus = 0
							AND CONVERT(varchar(25),A.ClosingDate,20) BETWEEN '''+CONVERT(varchar(25),@InitialDateTime,20)+''' AND '''+CONVERT(varchar(25),@FinalDateTime,20)+'''
						ORDER BY 2 ASC'

	EXEC (@ConsultSQL)
END
GO
