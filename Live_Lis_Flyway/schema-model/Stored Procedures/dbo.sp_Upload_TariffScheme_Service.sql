SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/08/2022
-- Description: Procedimiento almacenado para cargue masivo de servicios a esquema tarifario.
-- =============================================
--DECLARE @TariffScheme_Service TariffScheme_Service, @Message varchar(50), @Flag bit 

--INSERT INTO @TariffScheme_Service (IdTariffScheme_Service, IdTariffScheme, IdTypeOfProcedure, CUPS, ExamCode, ExamGroupCode, ServiceName, Value, Value_UVR)
--VALUES (1,1,4,NULL,NULL,'P190','PERFIL GENERAL',40000,100)--, 
--	--	(2,1,890202,'0037',NULL,'SEROTONINA EN SUEROL',3001,0,1020)--, (3,1,'890201',NULL,'Service-Exam Prueba2',5500,'Ninguno',85,44)

--EXEC [sp_Upload_TariffScheme_Service] @TariffScheme_Service, NULL,1020, @Message out, @Flag out

--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Upload_TariffScheme_Service]
(
	@TariffScheme_Service TariffScheme_Service READONLY,
	@InitialVigenceDate date = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdTariffScheme int, @IdTariffSchemeService int
BEGIN
    SET NOCOUNT ON

    SET @IdTariffScheme = (SELECT DISTINCT IdTariffScheme FROM @TariffScheme_Service)

	IF EXISTS (SELECT IdTariffScheme FROM TB_TariffScheme WHERE IdTariffScheme = @IdTariffScheme)
		BEGIN
			TRUNCATE TABLE TR_TariffScheme_Service_Tmp

			INSERT INTO TR_TariffScheme_Service_Tmp (IdTariffScheme_Service, IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, ServiceName, Value, Value_UVR, InitialVigenceDate, IdUserAction, Hiring)
			(SELECT DISTINCT IdTariffScheme_Service, IdTariffScheme, IdTypeOfProcedure, CUPS, ExamCode, ExamGroupCode, ServiceName, Value, CASE WHEN Value_UVR BETWEEN 0 AND 100  THEN Value_UVR ELSE NULL END, @InitialVigenceDate, @IdUserAction, Hiring FROM @TariffScheme_Service)

			---- Actualización de estado de carga a base de datos
			UPDATE TR_TariffScheme_Service_Tmp
				SET Status = (CASE WHEN IdTypeOfProcedure IS NULL OR (IdService IS NULL AND IdExam IS NULL AND IdExamGroup IS NULL) OR ServiceName IS NULL OR Value IS NULL OR Value_UVR IS NULL THEN 'False' ELSE 'True'  END)

			--- Actualizar a ID del servicio
			UPDATE A
				SET A.IdService = C.IdService,
					A.Status = CASE WHEN B.CUPS IS NOT NULL THEN CASE WHEN C.IdService IS NOT NULL THEN 1 ELSE 0 END ELSE 1 END
			FROM TR_TariffScheme_Service_Tmp A
			INNER JOIN @TariffScheme_Service B
				ON B.IdTariffScheme_Service = A.IdTariffScheme_Service
			LEFT JOIN TB_Service C
				ON C.CUPS = B.CUPS
			WHERE A.Status = 'True'

			--- Actualizar a ID del examen
			UPDATE A
				SET A.IdExam = C.IdExam,
					A.Status = CASE WHEN B.ExamCode IS NOT NULL THEN CASE WHEN C.IdExam IS NOT NULL THEN 1 ELSE 0 END ELSE 1 END
			FROM TR_TariffScheme_Service_Tmp A
			INNER JOIN @TariffScheme_Service B
				ON B.IdTariffScheme_Service = A.IdTariffScheme_Service
			LEFT JOIN TB_Exam C
				ON C.ExamCode = B.ExamCode
			WHERE A.Status = 'True'

			--- Actualizar a ID del grupo de exámenes
			UPDATE A
				SET A.IdExamGroup = C.IdExamGroup,
					A.Status = CASE WHEN B.ExamGroupCode IS NOT NULL THEN CASE WHEN C.IdExamGroup IS NOT NULL THEN 1 ELSE 0 END ELSE 1 END
			FROM TR_TariffScheme_Service_Tmp A
			INNER JOIN @TariffScheme_Service B
				ON B.IdTariffScheme_Service = A.IdTariffScheme_Service
			LEFT JOIN TB_ExamGroup C
				ON C.ExamGroupCode = B.ExamGroupCode
			WHERE A.Status = 'True'

			UPDATE TR_TariffScheme_Service_Tmp
				SET Status = 'False'
			WHERE IdTypeOfProcedure != 1
				AND IdExamGroup IS NULL

			----Validar registros repetidos
			UPDATE A
				SET A.Status = 'False'
			FROM TR_TariffScheme_Service_Tmp A
			INNER JOIN (
						SELECT IdTariffScheme_Service, IdService, IdExam, IdExamGroup, ROW_NUMBER() OVER (PARTITION BY IdService, IdExam, IdExamGroup, Hiring ORDER BY IdExam) Total
						FROM TR_TariffScheme_Service_Tmp 
						) B
				ON B.IdTariffScheme_Service = A.IdTariffScheme_Service
			WHERE Total >= 2

			-----------------------------------------------------------INSERTAR INFORMACIÓN -----------------------------------------------------------------		
			------ INSERTAR/ACTUALIZAR SERVICIOS DE ESQUEMA TARIFARIO
			IF @InitialVigenceDate <= CONVERT(DATE,DATEADD(HOUR,-5,GETDATE())) OR @InitialVigenceDate IS NULL OR @InitialVigenceDate = ''
				BEGIN
					MERGE TR_TariffScheme_Service AS TARGET
					USING (SELECT DISTINCT IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, @InitialVigenceDate AS InitialVigenceDate, IdUserAction, Hiring FROM TR_TariffScheme_Service_Tmp WHERE Status = 'True') SOURCE
						ON TARGET.IdTariffScheme = SOURCE.IdTariffScheme
							AND TARGET.IdTypeOfProcedure = SOURCE.IdTypeOfProcedure
							AND ISNULL(TARGET.IdService,0) = ISNULL(SOURCE.IdService,0)
							AND ISNULL(TARGET.IdExam,0) = ISNULL(SOURCE.IdExam,0)
							AND ISNULL(TARGET.IdExamGroup,0) = ISNULL(SOURCE.IdExamGroup,0)
					WHEN NOT MATCHED BY TARGET
					THEN
						INSERT (IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, InitialVigenceDate, Active, CreationDate, IdUserAction, Hiring)
						VALUES
							(
							SOURCE.IdTariffScheme, 
							SOURCE.IdTypeOfProcedure,
							SOURCE.IdService,
							SOURCE.IdExam,
							SOURCE.IdExamGroup,
							SOURCE.Value,
							SOURCE.Value_UVR,
							SOURCE.InitialVigenceDate,
							1,
							DATEADD(HOUR,-5,GETDATE()),
							SOURCE.IdUserAction,
							SOURCE.Hiring
							)
						WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Value = SOURCE.Value,
										TARGET.Value_UVR = SOURCE.Value_UVR,
										TARGET.InitialVigenceDate = SOURCE.InitialVigenceDate,
										TARGET.Active = 1,
										TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
										TARGET.IdUserAction = SOURCE.IdUserAction,
										TARGET.Hiring = SOURCE.Hiring;
				END
			ELSE
				BEGIN
					MERGE TB_TariffServiceChange AS TARGET
					USING (SELECT DISTINCT IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, @InitialVigenceDate AS InitialVigenceDate, IdUserAction, Hiring FROM TR_TariffScheme_Service_Tmp WHERE Status = 'True') SOURCE
						ON TARGET.IdTariffScheme = SOURCE.IdTariffScheme
							AND TARGET.IdTypeOfProcedure = SOURCE.IdTypeOfProcedure
							AND ISNULL(TARGET.IdService,0) = ISNULL(SOURCE.IdService,0)
							AND ISNULL(TARGET.IdExam,0) = ISNULL(SOURCE.IdExam,0)
							AND ISNULL(TARGET.IdExamGroup,0) = ISNULL(SOURCE.IdExamGroup,0)
					WHEN NOT MATCHED BY TARGET
					THEN
						INSERT (IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, InitialVigenceDate, CreationDate, IdUserAction, Hiring)
						VALUES
							(
							SOURCE.IdTariffScheme, 
							SOURCE.IdTypeOfProcedure,
							SOURCE.IdService,
							SOURCE.IdExam,
							SOURCE.IdExamGroup,
							SOURCE.Value,
							SOURCE.Value_UVR, 
							SOURCE.InitialVigenceDate,
							DATEADD(HOUR,-5,GETDATE()),
							SOURCE.IdUserAction,
							SOURCE.Hiring
							)
						WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Value = SOURCE.Value,
										TARGET.Value_UVR = SOURCE.Value_UVR,
										TARGET.InitialVigenceDate = SOURCE.InitialVigenceDate,
										TARGET.IdUserAction = SOURCE.IdUserAction,
										TARGET.Hiring = SOURCE.Hiring;
				END
/*-------------- hay que hacer pruebas de esta actualizacion para los registros repetidos		
				WITH cte AS (
					SELECT IdTariffSchemeService, IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, InitialVigenceDate, CreationDate, IdUserAction, Hiring, active,
						ROW_NUMBER() OVER (
							PARTITION BY
								IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, InitialVigenceDate, CreationDate, IdUserAction, Hiring
							ORDER BY
								IdTariffSchemeService, IdTariffScheme, IdTypeOfProcedure, IdService, IdExam, IdExamGroup, Value, Value_UVR, InitialVigenceDate, CreationDate, IdUserAction, Hiring desc
						) row_num
						FROM
						TR_TariffScheme_Service
				)
				UPDATE cte set active = 0
				FROM cte
				WHERE row_num > 1;
*/
			-----------------------------------------------------------RETORNO DE INFORMACIÓN CARGADA Y NO CARGADA -----------------------------------------------------------------
			SELECT B.IdTariffScheme_Service, C.TypeOfProcedure, B.CUPS, B.Hiring, B.ExamCode, B.ExamGroupCode, B.ServiceName, B.Value, B.Value_UVR, A.Status
			FROM TR_TariffScheme_Service_Tmp A
			INNER JOIN @TariffScheme_Service B
				ON B.IdTariffScheme_Service = A.IdTariffScheme_Service
			INNER JOIN TB_TypeOfProcedure C
				ON C.IdTypeOfProcedure = A.IdTypeOfProcedure

			SET @Message = 'Services successfully charged of the tariff scheme'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Tariff scheme does not exist'
			SET @Flag = 0
		END
END
GO
