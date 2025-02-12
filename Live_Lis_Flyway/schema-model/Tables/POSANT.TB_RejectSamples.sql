CREATE TABLE [POSANT].[TB_RejectSamples]
(
[IdRejectSamples] [int] NOT NULL IDENTITY(1, 1),
[SampleNumber] [varchar] (15) NOT NULL,
[IdPatient] [int] NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [POSANT].[TB_RejectSamples] ADD CONSTRAINT [PK__TB_Rejec__303EF1286549266B] PRIMARY KEY CLUSTERED ([IdRejectSamples])
GO
