SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para cargar detalle de resolución de facturación.
-- =============================================
--DECLARE @DetailBillingResolution DetailBillingResolution, @Message varchar(50), @Flag bit

--INSERT INTO @DetailBillingResolution (IdDetailBillingResolution, IdBillingResolution, DetailName, Prefix, Consecutive, InitialNumber, FinalNumber, InitialDate, FinalDate, EconomicActivity, ResolutionText, IdUserAction) VALUES
--(166,1,'test','f',85,1000,10000, '2023-06-01','2023-12-31',2,'13062023',1020)

--EXEC [sp_Charge_DetailBillingResolution] @DetailBillingResolution, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Upload_DetailBillingResolution]
(
	@DetailBillingResolution DetailBillingResolution READONLY,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT B.IdBillingResolution FROM TB_BillingResolution A INNER JOIN @DetailBillingResolution B ON B.IdBillingResolution = A.IdBillingResolution)
		BEGIN
			TRUNCATE TABLE TB_DetailBillingResolution_Tmp
			
			INSERT INTO TB_DetailBillingResolution_Tmp (IdDetailBillingResolution, IdBillingResolution, DetailName, Prefix, PrefixCN, Consecutive, InitialNumber, FinalNumber, InitialDate, FinalDate, EconomicActivity, ResolutionText, IdUserAction)
			(SELECT IdDetailBillingResolution, IdBillingResolution, DetailName, Prefix, PrefixCN, Consecutive, InitialNumber, FinalNumber, InitialDate, FinalDate, EconomicActivity, ResolutionText, IdUserAction FROM @DetailBillingResolution)
		
			--- Actualizar a ID de la actividad economica.
			UPDATE A
				SET A.EconomicActivity = C.IdEconomicActivity
			FROM TB_DetailBillingResolution_Tmp A
			INNER JOIN @DetailBillingResolution B
				ON B.IdDetailBillingResolution = A.IdDetailBillingResolution
			INNER JOIN TB_EconomicActivity C
				ON C.EconomicActivityName = A.EconomicActivity
			WHERE C.Active = 'True'

			UPDATE TB_DetailBillingResolution_Tmp
				SET Status = (CASE WHEN (IdBillingResolution IS NULL OR DetailName IS NULL OR Prefix IS NULL OR Consecutive IS NULL OR InitialNumber IS NULL OR FinalNumber IS NULL OR InitialDate IS NULL OR FinalDate IS NULL OR EconomicActivity IS NULL OR ResolutionText IS NULL) THEN 'False' ELSE 'True' END)


							---- Insertar Código Institucional
			MERGE TB_DetailBillingResolution AS TARGET
			USING 
				(SELECT DISTINCT IdBillingResolution, DetailName, Prefix, PrefixCN, Consecutive, InitialNumber, FinalNumber, InitialDate, FinalDate, EconomicActivity, ResolutionText, IdUserAction FROM TB_DetailBillingResolution_Tmp WHERE Status = 'True') SOURCE
			ON TARGET.IdBillingResolution = SOURCE.IdBillingResolution
				AND TARGET.DetailName = SOURCE.DetailName
			WHEN NOT MATCHED BY TARGET
			THEN
				INSERT (IdBillingResolution, DetailName, Prefix, PrefixCN, Consecutive, InitialNumber, FinalNumber, InitialDate, FinalDate, IdEconomicActivity, ResolutionText, Active, CreationDate, IdUserAction)
				VALUES
					(
					SOURCE.IdBillingResolution, 
					SOURCE.DetailName,
					SOURCE.Prefix,
					SOURCE.PrefixCN,
					SOURCE.Consecutive,
					SOURCE.InitialNumber, 
					SOURCE.FinalNumber, 
					SOURCE.InitialDate, 
					SOURCE.FinalDate, 
					SOURCE.EconomicActivity, 
					SOURCE.ResolutionText, 
					1,
					DATEADD(HOUR,-5,GETDATE()),
					SOURCE.IdUserAction
					)
				WHEN MATCHED
					THEN
						UPDATE
							SET TARGET.DetailName = SOURCE.DetailName,
								TARGET.Prefix = SOURCE.Prefix, 
								TARGET.PrefixCN = SOURCE.PrefixCN, 
								TARGET.Consecutive = SOURCE.Consecutive,
								TARGET.InitialNumber = SOURCE.InitialNumber,
								TARGET.FinalNumber = SOURCE.FinalNumber,
								TARGET.InitialDate = SOURCE.InitialDate,
								TARGET.FinalDate = SOURCE.FinalDate,
								TARGET.IdEconomicActivity = SOURCE.EconomicActivity,
								TARGET.ResolutionText = SOURCE.ResolutionText,
								TARGET.Active = 1,
								TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
								TARGET.IdUserAction = SOURCE.IdUserAction;


			SELECT B.IdDetailBillingResolution, B.IdBillingResolution, B.DetailName, B.Prefix, B.PrefixCN, B.Consecutive, B.InitialNumber, B.FinalNumber, B.InitialDate, B.FinalDate, C.IdEconomicActivity, C.EconomicActivityName AS EconomicActivity, B.ResolutionText, A.Status
			FROM TB_DetailBillingResolution_Tmp A
			INNER JOIN @DetailBillingResolution B
				ON B.IdDetailBillingResolution = A.IdDetailBillingResolution
			INNER JOIN TB_EconomicActivity C
				ON C.IdEconomicActivity = A.EconomicActivity

			SET @Message = 'Billing resolution detail uploaded successfully'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Billing resolution not found'
			SET @Flag = 0
		END
END
GO
