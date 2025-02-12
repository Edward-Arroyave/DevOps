CREATE TABLE [dbo].[TB_TransactionalLog_CredBank]
(
[IdTransactionalLog] [int] NOT NULL IDENTITY(1, 1),
[IdBillingOfSale] [int] NULL,
[TransactionProcess] [varchar] (25) NULL,
[TransactionResponseCode] [varchar] (10) NULL,
[ResponseTransaction] [varchar] (120) NULL,
[IdTransaction] [varchar] (10) NULL,
[ApprovalNumber] [varchar] (10) NULL,
[IdUser] [int] NULL,
[TransactionDate] [datetime] NULL,
[ReceiptNumber] [varchar] (10) NULL,
[DataResponse] [varchar] (100) NULL,
[TotalValue] [bigint] NULL
)
GO
ALTER TABLE [dbo].[TB_TransactionalLog_CredBank] ADD CONSTRAINT [PK_TB_TransactionalLog] PRIMARY KEY CLUSTERED ([IdTransactionalLog])
GO
ALTER TABLE [dbo].[TB_TransactionalLog_CredBank] ADD CONSTRAINT [FK_TB_TransactionalLog_CredBank_TB_BillingOfSale] FOREIGN KEY ([IdBillingOfSale]) REFERENCES [dbo].[TB_BillingOfSale] ([IdBillingOfSale])
GO
ALTER TABLE [dbo].[TB_TransactionalLog_CredBank] ADD CONSTRAINT [FK_TB_TransactionalLog_CredBank_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
