SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/02/2023
-- Description: Procedimiento almacenado para consultar arqueo de una caja.
-- =============================================
--EXEC [sp_Consult_BillingBox] 2,'','','','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_BillingBox]
(
	@Source int,
	@InitialDate date,
	@FinalDate date,
	@IdAttentionCenter VARCHAR(5),
	@BalancingStatus VARCHAR(1) = NULL,
	@IdUser varchar(5) = NULL
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

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

	---Consultar Arqueos.
	IF @Source = 1
		BEGIN
			SELECT A.IdBillingBox, A.ClosingNumber, A.IdAttentionCenter, B.AttentionCenterName, A.IdUser, CONCAT_WS(' ', C.Name, C.LastName) AS Cashier, A.BalancingDate,
				CASE WHEN A.BalancingStatus = 1 THEN 'Confirmado' ELSE 'Pendiente' END AS BalancingStatus
			FROM TB_BillingBox A
			INNER JOIN TB_AttentionCenter B
				ON B.IdAttentionCenter = A.IdAttentionCenter
			INNER JOIN TB_User C
				ON C.IdUser = A.IdUser
			WHERE A.BillingBoxStatus = 0
				AND ((A.ClosingDate BETWEEN @InitialDateTime AND @FinalDateTime)
				AND (@InitialDateTime != '' OR @FinalDateTime != '')
					OR (@InitialDateTime = '' AND @FinalDateTime = ''))
				AND CASE WHEN @IdAttentionCenter = '' THEN '' ELSE A.IdAttentionCenter END = @IdAttentionCenter
				AND CASE WHEN @BalancingStatus = '' THEN '' ELSE A.BalancingStatus END = @BalancingStatus
		END
	--- Consultar Cajas.
	ELSE IF @Source = 2
		BEGIN
			SELECT A.IdBillingBox, A.BillingBoxName, A.IdAttentionCenter, B.AttentionCenterName, A.IdUser, CONCAT_WS(' ', C.Name, C.LastName) AS Cashier, A.OpeningDate, A.ClosingDate,
				CASE WHEN A.BillingBoxStatus = 1 THEN 'Abierta' ELSE 'Cerrada' END AS BillingBoxStatus
			FROM TB_BillingBox A
			INNER JOIN TB_AttentionCenter B
				ON B.IdAttentionCenter = A.IdAttentionCenter
			INNER JOIN TB_User C
				ON C.IdUser = A.IdUser
			WHERE ((A.OpeningDate BETWEEN @InitialDateTime AND @FinalDateTime)
				AND (@InitialDateTime != '' OR @FinalDateTime != '')
					OR (@InitialDateTime = '' AND @FinalDateTime = ''))
				AND CASE WHEN @IdAttentionCenter = '' THEN '' ELSE A.IdAttentionCenter END = @IdAttentionCenter
				AND CASE WHEN @IdUser = '' THEN '' ELSE A.IdUser END = @IdUser
		END
END
GO
