SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacendo para crear un centro de atención
-- =============================================
--DECLARE @IdAttentCenter int, @Message varchar(100), @Flag bit
--EXEC [sp_Create_AttentionCenter] 173,'1234','CodigoHab123','Sede 123',1,1,1,100,50,'Calle 123','954528554',4, @IdAttentCenter out,@Message out, @Flag out
--SELECT @IdAttentCenter, @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_AttentionCenter]
(
	@IdAttentionCenter int,
	@AttentionCenterCode varchar(10),
	@AuthorizationCode varchar(15),
	@AttentionCenterName varchar(50),
	@IdBillingResolution int,
	@IdDetailBillingResolution int,
	@InitialNumber int,
	@FinalNumber int,
	@IdCity int,
	@Address varchar(100),
	@TelephoneNumber varchar(20),
	@IdUserAction int,
	@IdAttentCenter int out,
	@Message varchar(100) out,
	@Flag bit out
)
AS
	DECLARE @IdCityOld int
BEGIN
    SET NOCOUNT ON

	IF(@IdAttentionCenter = 0)
		BEGIN
			IF NOT EXISTS (SELECT AttentionCenterCode FROM TB_AttentionCenter WHERE AttentionCenterCode = @AttentionCenterCode)
				BEGIN
					IF NOT EXISTS (SELECT AuthorizationCode FROM TB_AttentionCenter WHERE AuthorizationCode = @AuthorizationCode)
						BEGIN
							IF NOT EXISTS (SELECT AttentionCenterName FROM TB_AttentionCenter WHERE AttentionCenterName = @AttentionCenterName AND IdCity = @IdCity)
								BEGIN
									INSERT INTO TB_AttentionCenter(AttentionCenterCode, AuthorizationCode, AttentionCenterName, IdBillingResolution, IdDetailBillingResolution, InitialNumber, FinalNumber, IdCity, Address, TelephoneNumber, CreationDate, IdUserAction, Active)
									VALUES (@AttentionCenterCode, @AuthorizationCode, @AttentionCenterName, @IdBillingResolution, @IdDetailBillingResolution, @InitialNumber, @FinalNumber, @IdCity, @Address, @TelephoneNumber, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)

									SET @IdAttentCenter = IDENT_CURRENT('TB_AttentionCenter')
									SET @Message = 'Successfully created AttentionCenter'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = CONCAT('Attention center name already exists in the city ', @IdCity)
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Authorization code already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'AttentionCenter code already exists'
					SET @Flag = 0
				END
		END
	ELSE IF @IdAttentionCenter != 0
		BEGIN
			SET @IdCityOld = (SELECT isnull(IdCity,0) FROM TB_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)

			IF NOT EXISTS (SELECT AuthorizationCode FROM TB_AttentionCenter WHERE AuthorizationCode = @AuthorizationCode AND IdAttentionCenter != @IdAttentionCenter)
				BEGIN
					IF @IdCityOld <> @IdCity
						BEGIN
							IF NOT EXISTS (SELECT IdAttentionCenter FROM TB_AttentionCenter WHERE AttentionCenterName = @AttentionCenterName AND  IdCity = @IdCity)
								BEGIN
									UPDATE TB_AttentionCenter
										SET AttentionCenterCode = @AttentionCenterCode,
											AuthorizationCode =  @AuthorizationCode,
											AttentionCenterName = @AttentionCenterName,
											IdBillingResolution = @IdBillingResolution,
											IdDetailBillingResolution = @IdDetailBillingResolution,
											InitialNumber = @InitialNumber,
											FinalNumber = @FinalNumber,
											IdCity = @IdCity, 
											Address = @Address,
											TelephoneNumber = @TelephoneNumber,
											IdUserAction = @IdUserAction,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()) 
									WHERE IdAttentionCenter = @IdAttentionCenter

									SET @IdAttentCenter = @IdAttentionCenter
									SET @Message = 'Successfully updated AttentionCenter'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = CONCAT('Attention center name already exists in the city ', @IdCity)
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							IF NOT EXISTS (SELECT IdAttentionCenter FROM TB_AttentionCenter WHERE AttentionCenterName = @AttentionCenterName AND IdCity = @IdCity AND IdAttentionCenter != @IdAttentionCenter)
								BEGIN
									UPDATE TB_AttentionCenter
										SET AttentionCenterCode = @AttentionCenterCode,
											AuthorizationCode =  @AuthorizationCode,
											AttentionCenterName = @AttentionCenterName,
											IdBillingResolution = @IdBillingResolution,
											IdDetailBillingResolution = @IdDetailBillingResolution,
											InitialNumber = @InitialNumber,
											FinalNumber = @FinalNumber,
											Address = @Address,
											TelephoneNumber = @TelephoneNumber,
											IdUserAction = @IdUserAction,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()) 
									WHERE IdAttentionCenter = @IdAttentionCenter

									SET @IdAttentCenter = @IdAttentionCenter
									SET @Message = 'Successfully updated AttentionCenter'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = CONCAT('Attention center name already exists in the city ', @IdCity)
									SET @Flag = 0
								END
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Authorization code already exists'
					SET @Flag = 0
				END
		END
END
GO
