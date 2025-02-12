CREATE TABLE [dbo].[TB_TransactionStatus]
(
[IdTransactionStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[TransactionStatus] [varchar] (10) NOT NULL,
[TransactionStatusDesc] [varchar] (90) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_TransactionStatus] ADD CONSTRAINT [PK_TB_TransactionStatus] PRIMARY KEY CLUSTERED ([IdTransactionStatus])
GO
