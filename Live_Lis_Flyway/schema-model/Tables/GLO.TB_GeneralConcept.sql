CREATE TABLE [GLO].[TB_GeneralConcept]
(
[IdGeneralConcept] [int] NOT NULL IDENTITY(1, 1),
[ConceptName] [varchar] (20) NULL
)
GO
ALTER TABLE [GLO].[TB_GeneralConcept] ADD CONSTRAINT [PK__TB_Gener__DE9D61E80A9DB263] PRIMARY KEY CLUSTERED ([IdGeneralConcept])
GO
