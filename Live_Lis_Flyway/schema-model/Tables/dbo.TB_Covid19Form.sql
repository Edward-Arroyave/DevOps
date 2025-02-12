CREATE TABLE [dbo].[TB_Covid19Form]
(
[IdCovid19Form] [int] NOT NULL IDENTITY(1, 1),
[IdCovid19FormType] [tinyint] NOT NULL,
[IdPatient] [int] NOT NULL,
[IdRequest_Exam] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdNationality] [int] NULL,
[IdHealthProviderEntity] [int] NOT NULL,
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
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [PK_TB_Covid19Form] PRIMARY KEY CLUSTERED ([IdCovid19Form])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_AffiliationType] FOREIGN KEY ([IdAffiliationType]) REFERENCES [dbo].[TB_AffiliationType] ([IdAffiliationType])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_CitySample] FOREIGN KEY ([IdCitySample]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_CityTravel] FOREIGN KEY ([IdTravelCity]) REFERENCES [dbo].[TB_City] ([IdCity])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_ConsultationType] FOREIGN KEY ([IdConsultationType]) REFERENCES [dbo].[TB_ConsultationType] ([IdConsultationType])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_CountryNationality] FOREIGN KEY ([IdNationality]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_CountryOfOrigin] FOREIGN KEY ([IdCountryOfOrigin]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_CountryOfResidence] FOREIGN KEY ([IdCountryOfResidence]) REFERENCES [dbo].[TB_Country] ([IdCountry])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_Covid19FormType] FOREIGN KEY ([IdCovid19FormType]) REFERENCES [dbo].[TB_Covid19FormType] ([IdCovid19FormType])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_Occupation] FOREIGN KEY ([IdOccupation]) REFERENCES [dbo].[TB_Occupation] ([IdOccupation])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_TypeOfStratefy] FOREIGN KEY ([IdTypeOfStratefy]) REFERENCES [dbo].[TB_TypeOfStratefy] ([IdTypeOfStratefy])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_TypeOfTest] FOREIGN KEY ([IdTypeOfTest]) REFERENCES [dbo].[TB_TypeOfTest] ([IdTypeOfTest])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_TypeOfTraveler] FOREIGN KEY ([IdTypeOfTraveler]) REFERENCES [dbo].[TB_TypeOfTraveler] ([IdTypeOfTraveler])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_Covid19Form] ADD CONSTRAINT [FK_TB_Covid19Form_TR_Request_Exam] FOREIGN KEY ([IdRequest_Exam]) REFERENCES [dbo].[TR_Request_Exam] ([IdRequest_Exam])
GO
