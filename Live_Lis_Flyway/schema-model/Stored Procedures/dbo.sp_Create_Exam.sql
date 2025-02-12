SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/10/2022	
-- Description: Procedimiento almacenado para crear venta a un paciente.
--=============================================

-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Exam]
(
	@IdExam int, 
	@GroupType bit,
	@ExamCode varchar(10), 
	@ExamName varchar(500), 
	@LevelOfComplexity int, 
	@IdExamType tinyint, 
	@IdSection int, 
	@IdBiologicalSex int, 
	@MinAge int = NULL, 
	@MaxAge int = NULL, 
	@IdAgeUnit int = NULL, 
	@Priority bit,
	--@Exam_SampleType Exam_SampleType READONLY,
	--@AmbientTemperature varchar(15) = NULL, 
	--@RefrigeratedTemperture varchar(15) = NULL, 
	--@FrozenTemperature varchar(15) = NULL, 
	@SampleConditions varchar(255), 
	@IdExamTechnique int = NULL,
	@DeliveryOpportunity varchar(20),
	@ControlOpportunity varchar(20),
	@ResultsFormula varchar(50) = NULL, 
	@Comment varchar(max) = NULL,
	@VisibleResult bit = NULL,
	@Decimal int, 
	@Monday bit, 
	@Tuesday bit, 
	@Wednesday bit, 
	@Thursday bit, 
	@Friday bit, 
	@Saturday bit, 
	@Sunday bit, 
	@Confidential bit, 
	@PreparationOrObservation varchar(max) = NULL, 
	@ClinicalImportance varchar(max) = NULL, 
	@OtherObservations varchar(max) = NULL, 
	@TestComponents varchar(255) = NULL, 
	@PBS bit = NULL, 
	@SOATCode varchar(12) = NULL, 
	@EpidemiologicalNotification bit,
	@TakingFrequency int = NULL,
	@IdTimeUnit int = NULL,
	@Exam_CUPS_OST_AttentCenter Exam_CUPS_OST_AttentCenter READONLY,
	@IdUserAction int,
	@IdTemplate int = null,
	@TemplateStartDate datetime = null,
	@Score int = null,
	@PlanValidity tinyint = null,
	@IdValidityFormat tinyint = null,
	@ActiveValidity tinyint = null,
	@IdExamOut int out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
/*
begin tran
DECLARE @Exam_CUPS_OST_AttentCenter Exam_CUPS_OST_AttentCenter,  @IdExamOut int, @Message varchar(50), @Flag bit

INSERT INTO @Exam_CUPS_OST_AttentCenter (Id, TableOption) VALUES 
(1,1), (1,2), (2,3)

EXEC [dbo].[sp_Create_Exam] 3833,1,'C56','Test Exam 2025',3,1,2,2,NULL,NULL,NULL,1,'QWERTY',2,1,2,'5','ss',1,2,1,1,1,0,0,0,0,0,'sss','sss',NULL,'sss',1,0,3,2,1,@Exam_CUPS_OST_AttentCenter,63,1,'2024-01-01',null,null,null,null,
							@IdExamOut out, @Message out, @Flag out
SELECT	@IdExamOut, @Message, @Flag
rollback
*/
	DECLARE @IdAnalyte int, @GroupTypeOld bit
BEGIN
    SET NOCOUNT ON

	IF @IdExam = 0
		BEGIN
			IF NOT EXISTS (SELECT IdExam FROM TB_Exam WHERE ExamCode = @ExamCode AND ExamName = @ExamName)
				BEGIN
					IF NOT EXISTS (SELECT ExamCode FROM TB_Exam WHERE ExamCode = @ExamCode)
						BEGIN
							IF NOT EXISTS (SELECT ExamName FROM TB_Exam WHERE ExamName = @ExamName)
								BEGIN
									--INSERT INTO TB_Exam (GroupType, IdTypeOfProcedure, ExamCode, ExamName, LevelOfComplexity, IdExamType, IdSection, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, Priority, AmbientTemperature, RefrigeratedTemperture, FrozenTemperature, SampleConditions, IdExamTechnique, DeliveryOpportunity, ControlOpportunity, ResultsFormula, Comment, VisibleResult, Decimal, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, Confidential, PreparationOrObservation, ClinicalImportance, OtherObservations, TestComponents, PBS, SOATCode, EpidemiologicalNotification, TakingFrequency, IdTimeUnit, Active, CreationDate,IdUserAction, IdTemplate)
									--VALUES (@GroupType, 1, @ExamCode, @ExamName, @LevelOfComplexity, @IdExamType, @IdSection, @IdBiologicalSex, @MinAge, @MaxAge, @IdAgeUnit, @Priority, @AmbientTemperature, @RefrigeratedTemperture, @FrozenTemperature, @SampleConditions, @IdExamTechnique, @DeliveryOpportunity, @ControlOpportunity, @ResultsFormula, @Comment, @VisibleResult, @Decimal, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday, @Confidential, @PreparationOrObservation, @ClinicalImportance, @OtherObservations, @TestComponents, @PBS, @SOATCode, @EpidemiologicalNotification, @TakingFrequency, @IdTimeUnit, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, @IdTemplate)

									INSERT INTO TB_Exam (GroupType, IdTypeOfProcedure, ExamCode, ExamName, LevelOfComplexity, IdExamType, IdSection, IdBiologicalSex, MinAge, MaxAge, 
									IdAgeTimeUnit, Priority, SampleConditions, IdExamTechnique, DeliveryOpportunity, ControlOpportunity, ResultsFormula, Comment, VisibleResult, Decimal, 
									Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, Confidential, PreparationOrObservation, ClinicalImportance, OtherObservations, 
									TestComponents, PBS, SOATCode, EpidemiologicalNotification, TakingFrequency, IdTimeUnit, Active, 
									CreationDate,IdUserAction, IdTemplate, Score, PlanValidity, IdValidityFormat, ActiveValidity)
									VALUES (@GroupType, 1, @ExamCode, @ExamName, @LevelOfComplexity, @IdExamType, @IdSection, @IdBiologicalSex, @MinAge, @MaxAge, 
									@IdAgeUnit, @Priority, @SampleConditions, @IdExamTechnique, @DeliveryOpportunity, @ControlOpportunity, @ResultsFormula, @Comment, @VisibleResult, 
									@Decimal, @Monday, @Tuesday, @Wednesday, @Thursday, @Friday, @Saturday, @Sunday, @Confidential, @PreparationOrObservation, 
									@ClinicalImportance, @OtherObservations, @TestComponents, @PBS, @SOATCode, @EpidemiologicalNotification, @TakingFrequency, @IdTimeUnit, 1, 
									DATEADD(HOUR,-5,GETDATE()), @IdUserAction, @IdTemplate, @Score ,@PlanValidity ,@IdValidityFormat ,@ActiveValidity )

									SET @IdExam = SCOPE_IDENTITY()

									--- TableOption = 1 → Relación de examen con CUPS
									MERGE TR_Service_Exam AS TARGET
									USING (SELECT Id, TableOption, Principal FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 1) SOURCE
										ON TARGET.IdExam = @IdExam
											AND TARGET.IdService = SOURCE.Id
									WHEN NOT MATCHED BY TARGET
									THEN
										INSERT (IdExam, IdService, Active, Principal)
										VALUES(
											@IdExam,
											SOURCE.Id,
											1,
											SOURCE.Principal
											)
									WHEN MATCHED
									THEN
										UPDATE
											SET TARGET.Active = 1, TARGET.Principal = SOURCE.Principal
									WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
										THEN
											UPDATE	
												SET TARGET.Active = 0, TARGET.Principal = null;

									--- TableOption = 2 → Relación de examen con Temperatura Optima de Envio
									MERGE TR_Exam_OptShippingTemp AS TARGET
									USING (SELECT Id, TableOption FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 2) SOURCE
										ON TARGET.IdExam = @IdExam
											AND TARGET.IdOptimumShippingTemperature = SOURCE.Id
									WHEN NOT MATCHED BY TARGET
									THEN
										INSERT (IdExam, IdOptimumShippingTemperature, Active)
										VALUES(
											@IdExam,
											SOURCE.Id,
											1
											)
									WHEN MATCHED
									THEN
										UPDATE
											SET TARGET.Active = 1
									WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
										THEN
											UPDATE	
												SET TARGET.Active = 0;

									--- TableOption = 3 → Relación de examen con Sedes de Atención
									MERGE TR_Exam_AttentionCenter AS TARGET
									USING (SELECT Id, TableOption FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 3) SOURCE
										ON TARGET.IdExam = @IdExam
											AND TARGET.IdAttentionCenter = SOURCE.Id
									WHEN NOT MATCHED BY TARGET
									THEN
										INSERT (IdExam, IdAttentionCenter, Active)
										VALUES(
											@IdExam,
											SOURCE.Id,
											1
											)
									WHEN MATCHED
									THEN
										UPDATE
											SET TARGET.Active = 1
									WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
										THEN
											UPDATE	
												SET TARGET.Active = 0;

									IF(SELECT COUNT(*) FROM TR_TEMPLATE_EXAM WHERE IDEXAM = @IDEXAM AND TEMPLATEENDDATE IS NULL)=1
										BEGIN 
											UPDATE	TR_TEMPLATE_EXAM SET TEMPLATEENDDATE = DATEADD (DAY,-1,@TEMPLATESTARTDATE), IdUserAction = @IdUserAction
											WHERE	IDEXAM = @IDEXAM 
											AND		TEMPLATEENDDATE IS NULL

											INSERT INTO TR_TEMPLATE_EXAM (IDEXAM, IDTEMPLATE, TEMPLATESTARTDATE, IdUserAction)
											VALUES	(@IDEXAM, @IDTEMPLATE, @TEMPLATESTARTDATE, @IdUserAction)
										END
										ELSE
										BEGIN
											INSERT INTO TR_TEMPLATE_EXAM (IDEXAM, IDTEMPLATE, TEMPLATESTARTDATE, IdUserAction)
											VALUES	(@IDEXAM, @IDTEMPLATE, @TEMPLATESTARTDATE, @IdUserAction)
									END
									--- Diligenciamiento de Gestión de Muestras
									--MERGE TR_Exam_SampleType AS TARGET
									--USING @Exam_SampleType SOURCE
									--	ON TARGET.IdExam = @IdExam
									--		AND TARGET.IdSampleType = SOURCE.IdSampleType
									--WHEN NOT MATCHED BY TARGET
									--THEN
									--	INSERT (IdExam, IdSampleType, IdContainerType, Volume, IdVolumeMeasure, Active, AmbientTemperature, RefrigeratedTemperture, FrozenTemperature,
									--			Required)
									--	VALUES(
									--		@IdExam,
									--		SOURCE.IdSampleType, 
									--		SOURCE.IdContainerType, 
									--		SOURCE.Volume, 
									--		SOURCE.IdVolumeMeasure,
									--		1,
									--		SOURCE.AmbientTemperature, 
									--		SOURCE.RefrigeratedTemperture, 
									--		SOURCE.FrozenTemperature,
									--		SOURCE.Required
									--		)
									--WHEN MATCHED
									--THEN
									--	UPDATE
									--		SET TARGET.IdContainerType = SOURCE.IdContainerType,
									--			TARGET.Volume = SOURCE.Volume,
									--			TARGET.IdVolumeMeasure = SOURCE.IdVolumeMeasure,
									--			TARGET.Active = 1
									--WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
									--	THEN
									--		UPDATE	
									--			SET TARGET.Active = 0;

									-- Creación de Analito cuando examen no es "Tipo grupo"
									--INSERT INTO TB_Analyte (IdExam, AnalyteCode, AnalyteName, IdSampleType, IdExamTechnique, Visible, Active, CreationDate, IdUserAction)
									--VALUES (@IdExam, @ExamCode, @ExamName, (SELECT TOP 1 IdSampleType FROM @Exam_SampleType), @IdExamTechnique, 1, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

									SET @Message = 'Successfully created exam'
									SET @Flag = 1
									SET @IdExamOut = @IdExam
								END
							ELSE
								BEGIN
									SET @Message = 'Exam name already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Exam code already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT IdExam FROM TB_Exam WHERE ExamCode = @ExamCode AND ExamName = @ExamName AND Active = 'False')
						BEGIN
							UPDATE TB_Exam
								SET GroupType = @GroupType, 
									ExamName = @ExamName, 
									LevelOfComplexity = @LevelOfComplexity, 
									IdExamType = @IdExamType,
									IdSection = @IdSection,
									IdBiologicalSex = @IdBiologicalSex,
									MinAge = @MinAge,
									MaxAge = @MaxAge,
									IdAgeTimeUnit = @IdAgeUnit,
									Priority = @Priority,
									--AmbientTemperature = @AmbientTemperature,
									--RefrigeratedTemperture = @RefrigeratedTemperture,
									--FrozenTemperature = @FrozenTemperature,
									SampleConditions = @SampleConditions,
									IdExamTechnique = @IdExamTechnique,
									DeliveryOpportunity = @DeliveryOpportunity,
									ControlOpportunity = @ControlOpportunity,
									ResultsFormula = @ResultsFormula, 
									Comment = @Comment,
									VisibleResult = @VisibleResult,
									Decimal = @Decimal, 
									Monday = @Monday,
									Tuesday = @Tuesday,
									Wednesday = @Wednesday,
									Thursday = @Thursday,
									Friday = @Friday,
									Saturday = @Saturday,
									Sunday = @Sunday,
									Confidential = @Confidential,
									PreparationOrObservation = @PreparationOrObservation,
									ClinicalImportance = @ClinicalImportance,
									OtherObservations = @OtherObservations,
									TestComponents = @TestComponents,
									PBS = @PBS,
									SOATCode = @SOATCode,
									EpidemiologicalNotification = @EpidemiologicalNotification, 
									TakingFrequency = @TakingFrequency,
									IdTimeUnit = @IdTimeUnit,
									Active = 1,
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction,
									IdTemplate = @IdTemplate,
									Score = @Score, 
									PlanValidity = @PlanValidity, 
									IdValidityFormat = @IdValidityFormat, 
									ActiveValidity = @ActiveValidity
							WHERE ExamCode = @ExamCode 
								AND ExamName = @ExamName 

							SET @IdExam = (SELECT IdExam FROM TB_Exam WHERE ExamCode = @ExamCode AND ExamName = @ExamName)

							--- Relación de examen con CUPS
							MERGE TR_Service_Exam AS TARGET
							USING (SELECT Id, TableOption, Principal FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 1) SOURCE
								ON TARGET.IdExam = @IdExam
									AND TARGET.IdService = SOURCE.Id
							WHEN NOT MATCHED BY TARGET
							THEN
								INSERT (IdExam, IdService, Active, Principal)
								VALUES(
									@IdExam,
									SOURCE.Id,
									1,
									SOURCE.Principal
									)
							WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Active = 1, TARGET.Principal = SOURCE.Principal
							WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
								THEN
									UPDATE	
										SET TARGET.Active = 0, TARGET.Principal = null;

							--- Relación de examen con Temperatura Optima de Envio
							MERGE TR_Exam_OptShippingTemp AS TARGET
							USING (SELECT Id, TableOption FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 2) SOURCE
								ON TARGET.IdExam = @IdExam
									AND TARGET.IdOptimumShippingTemperature = SOURCE.Id
							WHEN NOT MATCHED BY TARGET
							THEN
								INSERT (IdExam, IdOptimumShippingTemperature, Active)
								VALUES(
									@IdExam,
									SOURCE.Id,
									1
									)
							WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Active = 1
							WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
								THEN
									UPDATE	
										SET TARGET.Active = 0;

							--- Relación de examen con Sedes de Atención
							MERGE TR_Exam_AttentionCenter AS TARGET
							USING (SELECT Id, TableOption FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 3) SOURCE
								ON TARGET.IdExam = @IdExam
									AND TARGET.IdAttentionCenter = SOURCE.Id
							WHEN NOT MATCHED BY TARGET
							THEN
								INSERT (IdExam, IdAttentionCenter, Active)
								VALUES(
									@IdExam,
									SOURCE.Id,
									1
									)
							WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Active = 1
							WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
								THEN
									UPDATE	
										SET TARGET.Active = 0;


							--- Diligenciamiento de Gestión de Muestras
							--MERGE TR_Exam_SampleType AS TARGET
							--USING @Exam_SampleType SOURCE
							--	ON TARGET.IdExam = @IdExam
							--		AND TARGET.IdSampleType = SOURCE.IdSampleType
							--WHEN NOT MATCHED BY TARGET
							--THEN
							--	INSERT (IdExam, IdSampleType, IdContainerType, Volume, IdVolumeMeasure, Active, AmbientTemperature, RefrigeratedTemperture, FrozenTemperature,
							--			Required)
							--	VALUES(
							--		@IdExam,
							--		SOURCE.IdSampleType, 
							--		SOURCE.IdContainerType, 
							--		SOURCE.Volume, 
							--		SOURCE.IdVolumeMeasure,
							--		1,
							--		SOURCE.AmbientTemperature, 
							--		SOURCE.RefrigeratedTemperture, 
							--		SOURCE.FrozenTemperature,
							--		SOURCE.Required
							--		)
							--WHEN MATCHED
							--THEN
							--	UPDATE
							--		SET TARGET.IdContainerType = SOURCE.IdContainerType,
							--			TARGET.Volume = SOURCE.Volume,
							--			TARGET.IdVolumeMeasure = SOURCE.IdVolumeMeasure,
							--			TARGET.Active = 1
							--WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
							--	THEN
							--		UPDATE	
							--			SET TARGET.Active = 0;

							-- Creación de Analito cuando examen no es "Tipo grupo"
							IF @GroupType <> @GroupTypeOld
								BEGIN
									IF @GroupType = 0
										BEGIN
											IF EXISTS (SELECT DISTINCT IdAnalyte FROM TB_Analyte WHERE IdExam = @IdExam AND AnalyteCode = @ExamCode)
												BEGIN
													SET @IdAnalyte = (SELECT IdAnalyte FROM TB_Analyte WHERE IdExam = @IdExam AND AnalyteCode = @ExamCode)
													
													UPDATE TB_Analyte
														SET Active = 'True',
															UpdateDate = DATEADD (HOUR,-5,GETDATE()),
															IdUserAction = @IdUserAction
													WHERE IdAnalyte = @IdAnalyte

													UPDATE TB_Analyte
														SET Active = 'False',
															UpdateDate = DATEADD (HOUR,-5,GETDATE()),
															IdUserAction = @IdUserAction
													WHERE IdExam = @IdExam
														AND IdAnalyte != @IdAnalyte
												END
											--ELSE
												--BEGIN
												--	UPDATE TB_Analyte
												--		SET Active = 'False',
												--			UpdateDate = DATEADD (HOUR,-5,GETDATE()),
												--			IdUserAction = @IdUserAction
												--	WHERE IdExam = @IdExam

												--	INSERT INTO TB_Analyte (IdExam, AnalyteCode, AnalyteName, IdSampleType, IdExamTechnique, Visible, Active, CreationDate, IdUserAction)
												--	VALUES (@IdExam, @ExamCode, @ExamName, (SELECT TOP 1 IdSampleType FROM @Exam_SampleType), @IdExamTechnique, 1, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
												--END
										END
								END
	

							SET @Message = 'Successfully created exam'
							SET @Flag = 1
							SET @IdExamOut = @IdExam
						END
					ELSE
						BEGIN
							SET @Message = 'Exam code and name already exists'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			SET @GroupTypeOld = (SELECT GroupType FROM TB_Exam WHERE IdExam = @IdExam)

			IF NOT EXISTS (SELECT ExamCode FROM TB_Exam WHERE ExamCode = @ExamCode AND IdExam != @IdExam  and Active=1)
				BEGIN
					IF NOT EXISTS (SELECT ExamName FROM TB_Exam WHERE ExamName = @ExamName AND IdExam != @IdExam  and Active=1)
						BEGIN
							UPDATE TB_Exam
								SET GroupType = @GroupType,
									ExamName = @ExamName,
									LevelOfComplexity = @LevelOfComplexity, 
									IdExamType = @IdExamType,
									IdSection = @IdSection,
									IdBiologicalSex = @IdBiologicalSex,
									MinAge = @MinAge,
									MaxAge = @MaxAge,
									IdAgeTimeUnit = @IdAgeUnit,
									Priority = @Priority,
									--AmbientTemperature = @AmbientTemperature,
									--RefrigeratedTemperture = @RefrigeratedTemperture,
									--FrozenTemperature = @FrozenTemperature,
									SampleConditions = @SampleConditions,
									IdExamTechnique = @IdExamTechnique,
									DeliveryOpportunity = @DeliveryOpportunity,
									ControlOpportunity = @ControlOpportunity,
									ResultsFormula = @ResultsFormula, 
									Comment = @Comment,
									VisibleResult = @VisibleResult,
									Decimal = @Decimal, 
									Monday = @Monday,
									Tuesday = @Tuesday,
									Wednesday = @Wednesday,
									Thursday = @Thursday,
									Friday = @Friday,
									Saturday = @Saturday,
									Sunday = @Sunday,
									Confidential = @Confidential,
									PreparationOrObservation = @PreparationOrObservation,
									ClinicalImportance = @ClinicalImportance,
									OtherObservations = @OtherObservations,
									TestComponents = @TestComponents,
									PBS = @PBS,
									SOATCode = @SOATCode,
									EpidemiologicalNotification = @EpidemiologicalNotification, 
									TakingFrequency = @TakingFrequency,
									IdTimeUnit = @IdTimeUnit,
									Active = 1,
									UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction,
									IdTemplate = @IdTemplate,
									Score = @Score, 
									PlanValidity = @PlanValidity, 
									IdValidityFormat = @IdValidityFormat, 
									ActiveValidity = @ActiveValidity
							WHERE IdExam = @IdExam

							--- Relación de examen con CUPS
							MERGE TR_Service_Exam AS TARGET
							USING (SELECT Id, TableOption, Principal FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 1) SOURCE
								ON TARGET.IdExam = @IdExam
									AND TARGET.IdService = SOURCE.Id
							WHEN NOT MATCHED BY TARGET
							THEN
								INSERT (IdExam, IdService, Active, Principal)
								VALUES(
									@IdExam,
									SOURCE.Id,
									1,
									SOURCE.Principal
									)
							WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Active = 1, TARGET.Principal = SOURCE.Principal
							WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
								THEN
									UPDATE	
										SET TARGET.Active = 0, TARGET.Principal = null;

							--- Relación de examen con Temperatura Optima de Envio
							MERGE TR_Exam_OptShippingTemp AS TARGET
							USING (SELECT Id, TableOption FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 2) SOURCE
								ON TARGET.IdExam = @IdExam
									AND TARGET.IdOptimumShippingTemperature = SOURCE.Id
							WHEN NOT MATCHED BY TARGET
							THEN
								INSERT (IdExam, IdOptimumShippingTemperature, Active)
								VALUES(
									@IdExam,
									SOURCE.Id,
									1
									)
							WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Active = 1
							WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
								THEN
									UPDATE	
										SET TARGET.Active = 0;

							--- Relación de examen con Sedes de Atención
							MERGE TR_Exam_AttentionCenter AS TARGET
							USING (SELECT Id, TableOption FROM @Exam_CUPS_OST_AttentCenter WHERE TableOption = 3) SOURCE
								ON TARGET.IdExam = @IdExam
									AND TARGET.IdAttentionCenter = SOURCE.Id
							WHEN NOT MATCHED BY TARGET
							THEN
								INSERT (IdExam, IdAttentionCenter, Active)
								VALUES(
									@IdExam,
									SOURCE.Id,
									1
									)
							WHEN MATCHED
							THEN
								UPDATE
									SET TARGET.Active = 1
							WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
								THEN
									UPDATE	
										SET TARGET.Active = 0;

							--- Diligenciamiento de Gestión de Muestras
							--MERGE TR_Exam_SampleType AS TARGET
							--USING @Exam_SampleType SOURCE
							--	ON TARGET.IdExam = @IdExam
							--		AND TARGET.IdSampleType = SOURCE.IdSampleType
							--WHEN NOT MATCHED BY TARGET
							--THEN
							--	INSERT (IdExam, IdSampleType, IdContainerType, Volume, IdVolumeMeasure, Active, AmbientTemperature, RefrigeratedTemperture, FrozenTemperature,
							--			Required)
							--	VALUES(
							--		@IdExam,
							--		SOURCE.IdSampleType, 
							--		SOURCE.IdContainerType, 
							--		SOURCE.Volume, 
							--		SOURCE.IdVolumeMeasure,
							--		1,
							--		SOURCE.AmbientTemperature, 
							--		SOURCE.RefrigeratedTemperture, 
							--		SOURCE.FrozenTemperature,
							--		SOURCE.Required
							--		)
							--WHEN MATCHED
							--THEN
							--	UPDATE
							--		SET TARGET.IdContainerType = SOURCE.IdContainerType,
							--			TARGET.Volume = SOURCE.Volume,
							--			TARGET.IdVolumeMeasure = SOURCE.IdVolumeMeasure,
							--			TARGET.Active = 1
							--WHEN NOT MATCHED BY SOURCE AND TARGET.IdExam = @IdExam AND TARGET.Active = 1
							--	THEN
							--		UPDATE	
							--			SET TARGET.Active = 0;
												
							-- Creación de Analito cuando examen no es "Tipo grupo"
							IF @GroupType <> @GroupTypeOld
								BEGIN
									IF @GroupType = 0
										BEGIN
											IF EXISTS (SELECT DISTINCT IdAnalyte FROM TB_Analyte WHERE IdExam = @IdExam AND AnalyteCode = @ExamCode)
												BEGIN
													SET @IdAnalyte = (SELECT IdAnalyte FROM TB_Analyte WHERE IdExam = @IdExam AND AnalyteCode = @ExamCode)
													
													UPDATE TB_Analyte
														SET Active = 'True',
															UpdateDate = DATEADD (HOUR,-5,GETDATE()),
															IdUserAction = @IdUserAction
													WHERE IdAnalyte = @IdAnalyte

													UPDATE TB_Analyte
														SET Active = 'False',
															UpdateDate = DATEADD (HOUR,-5,GETDATE()),
															IdUserAction = @IdUserAction
													WHERE IdExam = @IdExam
														AND IdAnalyte != @IdAnalyte
												END
											--ELSE
											--	BEGIN
											--		UPDATE TB_Analyte
											--			SET Active = 'False',
											--				UpdateDate = DATEADD (HOUR,-5,GETDATE()),
											--				IdUserAction = @IdUserAction
											--		WHERE IdExam = @IdExam

											--		INSERT INTO TB_Analyte (IdExam, AnalyteCode, AnalyteName, IdSampleType, IdExamTechnique, Visible, Active, CreationDate, IdUserAction)
											--		VALUES (@IdExam, @ExamCode, @ExamName, (SELECT TOP 1 IdSampleType FROM @Exam_SampleType), @IdExamTechnique, 1, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)
											--	END
										END
								END

								IF(SELECT COUNT(*) FROM TR_TEMPLATE_EXAM WHERE IDEXAM = @IDEXAM AND TEMPLATEENDDATE IS NULL)=1
									BEGIN 
										UPDATE	TR_TEMPLATE_EXAM SET TEMPLATEENDDATE = DATEADD (SECOND,-1,@TEMPLATESTARTDATE), IdUserAction = @IdUserAction
										WHERE	IDEXAM = @IDEXAM 
										AND		TEMPLATEENDDATE IS NULL

										INSERT INTO TR_TEMPLATE_EXAM (IDEXAM, IDTEMPLATE, TEMPLATESTARTDATE, IdUserAction)
										VALUES	(@IDEXAM, @IDTEMPLATE, @TEMPLATESTARTDATE, @IdUserAction)
									END
									ELSE
									BEGIN
										INSERT INTO TR_TEMPLATE_EXAM (IDEXAM, IDTEMPLATE, TEMPLATESTARTDATE, IdUserAction)
										VALUES	(@IDEXAM, @IDTEMPLATE, @TEMPLATESTARTDATE, @IdUserAction)
									END

							SET @Message = 'Successfully updated exam'
							SET @Flag = 1
							SET @IdExamOut = @IdExam
						END
					ELSE
						BEGIN
							SET @Message = 'Exam code already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Exam name already exists'
					SET @Flag = 0
				END
		END
END
GO
