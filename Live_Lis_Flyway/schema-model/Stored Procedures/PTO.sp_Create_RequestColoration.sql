SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [PTO].[sp_Create_RequestColoration]
(
	@IdRequestColoration int,
	@IdLeafFractions int = NULL,
	@IdBlockFractions int,  
	@IdTypesOfColorations int, 
	@BarCode varchar(30), 
	@CuttingQuality varchar(30) = NULL,
	@Requested bit = NULL, 
	@RequestDate datetime = NULL, 
	@IdRequestUser int,
	@ObservationRequest text = NULL, 
	@Delivered bit = NULL, 
	@DateOfDelivery datetime = NULL, 
	@IdDeliveyUser int =NULL,
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

	IF @IdRequestColoration = 0
		BEGIN
			INSERT INTO PTO.TB_RequestColoration(IdLeafFractions, IdBlockFractions, IdTypesOfColorations, BarCode, CuttingQuality, Requested, RequestDate, IdRequestUser, ObservationRequest, Delivered, DateOfDelivery, IdDeliveryUser, Received, ReceivedDate, IdReceivedUser, ObservationReceived, Recoil, DateRecoil,  IdRecoilUser, ObservationRecoil, CreationDate, IdUserAction)
			VALUES (@IdLeafFractions, @IdBlockFractions, @IdTypesOfColorations, @BarCode, @CuttingQuality, @Requested, @RequestDate, @IdRequestUser, @ObservationRequest, @Delivered, @DateOfDelivery, @IdDeliveyUser, @Received, @ReceivedDate, @IdReceivedUser, @ObservationReceived, @Recoil, @DateRecoil, @IdRecoilUser, @ObservationRecoil, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

			SET @Message = 'Successfully created Request Coloration'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_RequestColoration
				SET IdLeafFractions = @IdLeafFractions, 
					IdBlockFractions = @IdBlockFractions, 
					IdTypesOfColorations = @IdTypesOfColorations, 
					BarCode = @BarCode, 
					CuttingQuality = @CuttingQuality, 
					Requested = @Requested, 
					RequestDate = @RequestDate, 
					IdRequestUser = @IdRequestUser, 
					ObservationRequest = @ObservationRequest, 
					Delivered = @Delivered, 
					DateOfDelivery = @DateOfDelivery, 
					IdDeliveryUser = @IdDeliveyUser, 
					Received = @Received, 
					ReceivedDate = @ReceivedDate, 
					IdReceivedUser = @IdReceivedUser, 
					ObservationReceived = @ObservationReceived, 
					Recoil = @Recoil, 
					DateRecoil = @DateRecoil,  
					IdRecoilUser = @IdRecoilUser, 
					ObservationRecoil = @ObservationRecoil, 
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdRequestColoration = @IdRequestColoration

			SET @Message = 'Successfully updated Request Coloration'
			SET @Flag = 1
		END
END
GO
