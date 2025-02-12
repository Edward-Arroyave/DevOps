CREATE TABLE [INTER].[PatientOrder]
(
[IdPatientOrder] [int] NOT NULL IDENTITY(1, 1),
[IdPatient] [int] NOT NULL,
[BirthDate] [datetime] NOT NULL,
[IdBiologicalSex] [tinyint] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [INTER].[PatientOrder] ADD CONSTRAINT [PK__PatientO__C54E27C9375A3481] PRIMARY KEY CLUSTERED ([IdPatientOrder])
GO
ALTER TABLE [INTER].[PatientOrder] ADD CONSTRAINT [UQ__PatientO__B7E7B5A5A0C02ABB] UNIQUE NONCLUSTERED ([IdPatient])
GO
ALTER TABLE [INTER].[PatientOrder] ADD CONSTRAINT [FK_BiologicalSex_INTER_PatientOrder] FOREIGN KEY ([IdBiologicalSex]) REFERENCES [dbo].[TB_BiologicalSex] ([IdBiologicalSex])
GO
ALTER TABLE [INTER].[PatientOrder] ADD CONSTRAINT [FK_User_INTER_PatientOrder] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
