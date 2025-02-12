CREATE TABLE [dbo].[TB_TransferStatus]
(
[IdTransferStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[StateName] [varchar] (20) NULL
)
GO
ALTER TABLE [dbo].[TB_TransferStatus] ADD CONSTRAINT [PK__TB_Trans__3643C41549D439AF] PRIMARY KEY CLUSTERED ([IdTransferStatus])
GO
