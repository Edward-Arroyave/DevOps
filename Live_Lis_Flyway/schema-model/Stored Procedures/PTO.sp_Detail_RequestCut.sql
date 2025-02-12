SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/06/2022
-- Description: Procedimiento almacenado para retornar detalle de solicitud de corte.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_RequestCut]
(
	@IdRequestCut int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdRequestCut, IdBlockFractions, IdLeafFractions, IdTypesOfCuts, BarCode, CuttingQuality, Requested, RequestDate, IdRequestUser, ObservationRequest, Delivered, DateOfDelivery, IdDeliveryUser, Received, ReceivedDate, IdReceivedUser, ObservationReceived, Recoil, DateRecoil, IdRecoilUser, ObservationRecoil
	FROM PTO.TB_RequestCut
	WHERE IdRequestCut = @IdRequestCut
END


GO
