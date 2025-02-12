CREATE TABLE [GLO].[TB_SpecificConcepts]
(
[IdSpecificConcept] [int] NOT NULL IDENTITY(1, 1),
[IdGeneralConcept] [int] NOT NULL,
[NameSpecificConcept] [varchar] (150) NULL
)
GO
ALTER TABLE [GLO].[TB_SpecificConcepts] ADD CONSTRAINT [PK__TB_Speci__A50108024A43455A] PRIMARY KEY CLUSTERED ([IdSpecificConcept])
GO
ALTER TABLE [GLO].[TB_SpecificConcepts] ADD CONSTRAINT [FK_TB_SpecificConcepts_TB_TB_GeneralConcepts] FOREIGN KEY ([IdGeneralConcept]) REFERENCES [GLO].[TB_GeneralConcept] ([IdGeneralConcept])
GO
