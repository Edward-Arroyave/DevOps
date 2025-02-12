CREATE TABLE [dbo].[TB_CancellationReasonType]
(
[IdCancellationReasonType] [tinyint] NOT NULL IDENTITY(1, 1),
[CancellationReasonType] [varchar] (45) NOT NULL,
[CreditNoteTypeOdoo] [varchar] (2) NULL
)
GO
ALTER TABLE [dbo].[TB_CancellationReasonType] ADD CONSTRAINT [PK_TB_CancellationReasonType] PRIMARY KEY CLUSTERED ([IdCancellationReasonType])
GO
