SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/06/2022
-- Description: Procedimiento almacenado para crear/actualizar solicitudes de corte.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_RequestCut]
(
	@IdRequestCut int,
	@IdBlockFractions int, 
	@IdLeafFractions int = NULL, 
	@IdTypesOfCuts int, 
	@BarCode varchar(30), 
	@CuttingQuality varchar(20) = NULL, 
	@Requested bit = NULL, 
	@RequestDate datetime = NULL, 
	@IdRequestUser int, 
	@ObservationRequest text,
	@Delivered bit = NULL, 
	@DateOfDelivery datetime = NULL, 
	@IdDeliveryUser int = NULL,
	@Received bit = NULL, 
	@ReceivedDate datetime = NULL, 
	@IdReceivedUser int = NULL,
	@ObservationReceived text = NULL,
	@Recoil bit = NULL, 
	@DateRecoil datetime = NULL,
	@IdRecoilUser int = NULL,
	@ObservationRecoil text = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdRequestCut = 0
		BEGIN
			INSERT INTO PTO.TB_RequestCut(IdBlockFractions, IdLeafFractions, IdTypesOfCuts, BarCode, CuttingQuality, Requested, RequestDate, IdRequestUser, ObservationRequest, Delivered, DateOfDelivery, IdDeliveryUser, Received, ReceivedDate, IdReceivedUser, ObservationReceived, Recoil, DateRecoil, IdRecoilUser, ObservationRecoil, CreationDate, IdUserAction)
			VALUES (@IdBlockFractions, @IdLeafFractions, @IdTypesOfCuts, @BarCode, @CuttingQuality, @Requested, @RequestDate, @IdRequestUser, @ObservationRequest, @Delivered, @DateOfDelivery, @IdDeliveryUser, @Received, @ReceivedDate, @IdReceivedUser, @ObservationReceived, @Recoil, @DateRecoil, @IdRecoilUser, @ObservationRecoil, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @Message = 'Successfully created Request Cut'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_RequestCut
				SET IdBlockFractions = @IdBlockFractions, 
					IdLeafFractions = @IdLeafFractions, 
					IdTypesOfCuts = @IdTypesOfCuts, 
					BarCode = @BarCode, 
					CuttingQuality = @CuttingQuality, 
					Requested = @Requested, 
					RequestDate = @RequestDate, 
					IdRequestUser = @IdRequestUser, 
					ObservationRequest = @ObservationRequest, 
					Delivered = @Delivered, 
					DateOfDelivery = @DateOfDelivery, 
					IdDeliveryUser = @IdDeliveryUser, 
					Received = @Received, 
					ReceivedDate = @ReceivedDate, 
					IdReceivedUser = @IdReceivedUser, 
					ObservationReceived = @ObservationReceived, 
					Recoil = @Recoil, 
					DateRecoil = @DateRecoil, 
					IdRecoilUser = @IdRecoilUser, 
					ObservationRecoil = @ObservationRecoil, 
					UpdateDate= DATEADD(HOUR,-5,GETDATE()), 
					IdUserAction = @IdUserAction
			WHERE IdRequestCut = @IdRequestCut

			SET @Message = 'Successfully updated Request Cut'
			SET @Flag = 1
		END
END
GO
