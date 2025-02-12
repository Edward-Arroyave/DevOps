SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/06/2022
-- Description: Procedimiento almacenado para retornar detalle de solicitud de coloración.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_RequestColoration]
(
	@IdRequestColoration int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdRequestColoration, IdLeafFractions, IdBlockFractions, IdTypesOfColorations, BarCode, CuttingQuality, Requested, RequestDate, IdRequestUser ,ObservationRequest, Delivered, DateOfDelivery, IdDeliveryUser, Received, ReceivedDate, IdReceivedUser, ObservationReceived, Recoil, DateRecoil, IdRecoilUser, ObservationRecoil
	FROM PTO.TB_RequestColoration
	WHERE IdRequestColoration = @IdRequestColoration
END
GO
