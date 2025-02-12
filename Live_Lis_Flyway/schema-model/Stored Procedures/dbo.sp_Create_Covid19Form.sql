SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/10/2022
-- Description: Procedimiento almacenado para diligenciar cuestionarios de salud de Covid 19.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Covid19Form]
(
	@Covid19Form Covid19Form READONLY,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	--- Relación de examense de una solicitud
	MERGE TB_Covid19Form AS TARGET
	USING @Covid19Form SOURCE
		ON TARGET.IdRequest_Exam = SOURCE.IdRequest_Exam
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdCovid19FormType, IdPatient, IdRequest_Exam, CreationDate, IdNationality, IdHealthProviderEntity, IdAffiliationType, IdCountryOfResidence, HealthWorker, IdOccupation, ContactWithConfirmedCase, SymptomsStartDate, ClientSender, 
				IdConsultationType, HasHaveSymptoms, PreviousSymptoms, IdTypeOfTraveler, IdCountryOfOrigin, IdTravelCity, ArrivalDate, EndCondition, DeathDate, IdCitySample, SamplingSiteCode, SampleCollectionDate, SampleReceiptDate, 
				INS_SamplesCentralOrderNumber, IdSampleType, GVI_InternalCode, IdTypeOfStratefy, EpidemiologicalFence, PostSymptomatic, IdTypeOfTest, IdUserAction)
		VALUES(
			SOURCE.IdCovid19FormType, 
			SOURCE.IdPatient, 
			SOURCE.IdRequest_Exam, --@IdRequest_Exam, 
			DATEADD(HOUR,-5,GETDATE()), 
			SOURCE.IdNationality, 
			SOURCE.IdHealthProviderEntity, 
			SOURCE.IdAffiliationType, 
			SOURCE.IdCountryOfResidence, 
			SOURCE.HealthWorker, 
			SOURCE.IdOccupation, 
			SOURCE.ContactWithConfirmedCase, 
			SOURCE.SymptomsStartDate, 
			SOURCE.ClientSender, 
			SOURCE.IdConsultationType, 
			SOURCE.HasHaveSymptoms, 
			SOURCE.PreviousSymptoms, 
			SOURCE.IdTypeOfTraveler, 
			SOURCE.IdCountryOfOrigin, 
			SOURCE.IdTravelCity, 
			SOURCE.ArrivalDate, 
			SOURCE.EndCondition, 
			SOURCE.DeathDate, 
			SOURCE.IdCitySample, 
			SOURCE.SamplingSiteCode, 
			SOURCE.SampleCollectionDate, 
			SOURCE.SampleReceiptDate, 
			SOURCE.INS_SamplesCentralOrderNumber, 
			SOURCE.IdSampleType, 
			SOURCE.GVI_InternalCode, 
			SOURCE.IdTypeOfStratefy, 
			SOURCE.EpidemiologicalFence, 
			SOURCE.PostSymptomatic, 
			SOURCE.IdTypeOfTest,
			SOURCE.IdUserAction
			);

	SET @Message = 'Successfully created Covid 19 Form'
	SET @Flag = 1
END
GO
