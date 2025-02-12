CREATE TABLE [TYL].[TB_ReceptionType]
(
[IdReceptionType] [int] NOT NULL IDENTITY(1, 1),
[ReceptionName] [varchar] (20) NULL
)
GO
ALTER TABLE [TYL].[TB_ReceptionType] ADD CONSTRAINT [PK__TB_Recep__96BFC4682477B6C5] PRIMARY KEY CLUSTERED ([IdReceptionType])
GO
