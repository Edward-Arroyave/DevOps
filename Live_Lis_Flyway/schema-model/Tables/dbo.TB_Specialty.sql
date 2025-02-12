CREATE TABLE [dbo].[TB_Specialty]
(
[IdSpecialty] [tinyint] NOT NULL IDENTITY(1, 1),
[Specialty] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__TB_Specia__Activ__53CE1A8C] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TB_Specialty] ADD CONSTRAINT [PK__TB_Speci__D4CA6FA8B41FF8CE] PRIMARY KEY CLUSTERED ([IdSpecialty])
GO
