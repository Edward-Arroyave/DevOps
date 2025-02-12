SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para crear resolución de facturación.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_BillingResolution]
(
	@IdBillingResolution int,
	@Number varchar(15),
	@RegisterName varchar(60), 
	@NIT varchar(12),
	@Address varchar(100),
	@Date date,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN

    SET NOCOUNT ON

	IF @IdBillingResolution = 0
		BEGIN
			IF NOT EXISTS (SELECT Number FROM TB_BillingResolution WHERE Number = @Number)
				BEGIN
					IF NOT EXISTS (SELECT RegisteredName FROM TB_BillingResolution WHERE RegisteredName = @RegisterName)
						BEGIN
							IF NOT EXISTS (SELECT NIT FROM TB_BillingResolution WHERE NIT = @NIT)
								BEGIN
									INSERT INTO TB_BillingResolution (Number, RegisteredName, NIT, Address, Date, Active, CreationDate, IdUserAction)
									VALUES (@Number, @RegisterName, @NIT, @Address, @Date, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

									SET @Message = 'Successfully created billing resolution'
									SET @Flag = 1
								END
							ELSE	
								BEGIN
									SET @Message = 'Billing resolution NIT already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Billing resolution Registered Name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Billing resolution number already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT Number FROM TB_BillingResolution WHERE Number = @Number AND IdBillingResolution != @IdBillingResolution)
				BEGIN
					IF NOT EXISTS (SELECT RegisteredName FROM TB_BillingResolution WHERE RegisteredName = @RegisterName AND IdBillingResolution != @IdBillingResolution)
						BEGIN
							IF NOT EXISTS (SELECT NIT FROM TB_BillingResolution WHERE NIT = @NIT AND IdBillingResolution != @IdBillingResolution)
								BEGIN
									UPDATE TB_BillingResolution
										SET Number = @Number,
											RegisteredName = @RegisterName,
											NIT = @NIT,
											Address = @Address,
											Date = @Date,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction
									WHERE IdBillingResolution = @IdBillingResolution

									SET @Message = 'Successfully updated billing resolution'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'Billing resolution NIT already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Billing resolution Registered Name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Billing resolution number already exists'
					SET @Flag = 0
				END
		END
END
GO
