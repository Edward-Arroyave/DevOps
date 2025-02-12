SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 28/08/2022
-- Description: Procedimiento almacenado para crear detalle de resolución de facturación.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_DetailBillingResolution]
(
	@IdDetailBillingResolution int,
	@IdBillingResolution int, 
	@DetailName varchar(50),
	@Prefix varchar(10),
	@PrefixCN varchar(10),
	@Consecutive int,
	@InitialNumber int,
	@FinalNumber int,
	@InitialDate datetime,
	@FinalDate datetime,
	@IdEconomicActivity int,
	@ResolutionText varchar(255),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdDetailBillingResolution  = 0
		BEGIN
			INSERT INTO TB_DetailBillingResolution (IdBillingResolution, DetailName, Prefix, PrefixCN, Consecutive, InitialNumber, FinalNumber, InitialDate, FinalDate, IdEconomicActivity, ResolutionText, Active, CreationDate, IdUserAction)
			VALUES (@IdBillingResolution, @DetailName, @Prefix, @PrefixCN, @Consecutive, @InitialNumber, @FinalNumber, @InitialDate, @FinalDate, @IdEconomicActivity, @ResolutionText, 1, DATEADD(HOUR,-5,GETDATE()),@IdUserAction)

			SET @Message = 'Successfully created detail billing resolution'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE TB_DetailBillingResolution
				SET IdBillingResolution = @IdBillingResolution,
					DetailName = @DetailName,
					Prefix = @Prefix,
					PrefixCN = @PrefixCN,
					Consecutive = @Consecutive, 
					InitialNumber = @InitialNumber,
					FinalNumber = @FinalNumber,
					InitialDate = @InitialDate,
					FinalDate = @FinalDate,
					IdEconomicActivity = @IdEconomicActivity,
					ResolutionText = @ResolutionText,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			WHERE IdDetailBillingResolution = @IdDetailBillingResolution

			SET @Message = 'Successfully updated detail billing resolution'
			SET @Flag = 1
		END
END
GO
