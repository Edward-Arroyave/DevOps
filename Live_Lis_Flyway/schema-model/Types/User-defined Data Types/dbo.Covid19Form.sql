CREATE TYPE [dbo].[Covid19Form] AS TABLE
(
[IdRequest_Exam] [int] NOT NULL,
[IdCovid19FormType] [tinyint] NOT NULL,
[IdPatient] [int] NOT NULL,
[IdNationality] [int] NULL,
[IdHealthProviderEntity] [int] NULL,
[IdAffiliationType] [tinyint] NULL,
[IdCountryOfResidence] [int] NULL,
[HealthWorker] [bit] NULL,
[IdOccupation] [int] NULL,
[ContactWithConfirmedCase] [bit] NULL,
[SymptomsStartDate] [date] NULL,
[ClientSender] [varchar] (60) NULL,
[IdConsultationType] [tinyint] NULL,
[HasHaveSymptoms] [bit] NULL,
[PreviousSymptoms] [bit] NULL,
[IdTypeOfTraveler] [tinyint] NULL,
[IdCountryOfOrigin] [int] NULL,
[IdTravelCity] [int] NULL,
[ArrivalDate] [date] NULL,
[EndCondition] [bit] NULL,
[DeathDate] [date] NULL,
[IdCitySample] [int] NULL,
[SamplingSiteCode] [varchar] (15) NULL,
[SampleCollectionDate] [date] NULL,
[SampleReceiptDate] [date] NULL,
[INS_SamplesCentralOrderNumber] [varchar] (30) NULL,
[IdSampleType] [int] NULL,
[GVI_InternalCode] [varchar] (30) NULL,
[IdTypeOfStratefy] [tinyint] NULL,
[EpidemiologicalFence] [bit] NULL,
[PostSymptomatic] [bit] NULL,
[IdTypeOfTest] [tinyint] NULL,
[IdUserAction] [int] NULL
)
GO
