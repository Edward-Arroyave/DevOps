CREATE TABLE [dbo].[TB_DebitNoteConcept]
(
[IdDebitNoteConcept] [smallint] NOT NULL IDENTITY(1, 1),
[ConceptName] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DebitNoteConcept] ADD CONSTRAINT [PK__TB_Debit__28D2D5125E0BD56D] PRIMARY KEY CLUSTERED ([IdDebitNoteConcept])
GO
