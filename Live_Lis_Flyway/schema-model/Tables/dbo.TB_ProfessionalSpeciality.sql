CREATE TABLE [dbo].[TB_ProfessionalSpeciality]
(
[IdProfessionalSpeciality] [smallint] NOT NULL IDENTITY(1, 1),
[ProfessionalSpecialityCode] [varchar] (10) NOT NULL,
[ProfessionalSpecialityName] [varchar] (60) NOT NULL,
[IdTraditionalGrouping] [tinyint] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ProfessionalSpeciality] ADD CONSTRAINT [PK_TB_Speciality] PRIMARY KEY CLUSTERED ([IdProfessionalSpeciality])
GO
ALTER TABLE [dbo].[TB_ProfessionalSpeciality] ADD CONSTRAINT [FK_TB_ProfessionalSpeciality_TB_TraditionalGrouping] FOREIGN KEY ([IdTraditionalGrouping]) REFERENCES [dbo].[TB_TraditionalGrouping] ([IdTraditionalGrouping])
GO
