CREATE TABLE [dbo].[TR_User_ProfessionalSpeciality]
(
[IdUser_ProfessionalSpeciality] [int] NOT NULL IDENTITY(1, 1),
[IdUser] [int] NOT NULL,
[IdProfessionalSpeciality] [smallint] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_User_ProfessionalSpeciality] ADD CONSTRAINT [PK_TR_User_ProfessionalSpeciality] PRIMARY KEY CLUSTERED ([IdUser_ProfessionalSpeciality])
GO
ALTER TABLE [dbo].[TR_User_ProfessionalSpeciality] ADD CONSTRAINT [FK_TR_User_ProfessionalSpeciality_TB_ProfessionalSpeciality] FOREIGN KEY ([IdProfessionalSpeciality]) REFERENCES [dbo].[TB_ProfessionalSpeciality] ([IdProfessionalSpeciality])
GO
ALTER TABLE [dbo].[TR_User_ProfessionalSpeciality] ADD CONSTRAINT [FK_TR_User_ProfessionalSpeciality_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
