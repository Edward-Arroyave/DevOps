CREATE TABLE [dbo].[TB_DebitNoteState]
(
[IdDebitNoteState] [smallint] NOT NULL IDENTITY(1, 1),
[StatusName] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_DebitNoteState] ADD CONSTRAINT [PK__TB_Debit__D4CF5110CC8A2961] PRIMARY KEY CLUSTERED ([IdDebitNoteState])
GO
