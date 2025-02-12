CREATE TABLE [dbo].[TB_Transfer]
(
[IdTransfer] [int] NOT NULL IDENTITY(1, 1),
[IdCompany] [int] NOT NULL,
[TransferCode] [varchar] (20) NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[Amount] [bigint] NOT NULL,
[AmountAvailable] [bigint] NULL,
[TotalAmountTransfer] [bigint] NULL,
[RemainingAmount] [bigint] NULL,
[IdContractOri] [int] NOT NULL,
[IdContractDes] [int] NOT NULL,
[IdStatus] [tinyint] NOT NULL,
[IdUserAction] [int] NULL,
[CancellationReason] [varchar] (500) NULL
)
GO
ALTER TABLE [dbo].[TB_Transfer] ADD CONSTRAINT [PK__TB_Trans__274BCBFC17A7C471] PRIMARY KEY CLUSTERED ([IdTransfer])
GO
ALTER TABLE [dbo].[TB_Transfer] ADD CONSTRAINT [TB_Transfer_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_Transfer] ADD CONSTRAINT [TB_Transfer_TB_ContractDes] FOREIGN KEY ([IdContractDes]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TB_Transfer] ADD CONSTRAINT [TB_Transfer_TB_ContractOri] FOREIGN KEY ([IdContractOri]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TB_Transfer] ADD CONSTRAINT [TB_Transfer_TB_TransferStatus] FOREIGN KEY ([IdStatus]) REFERENCES [dbo].[TB_TransferStatus] ([IdTransferStatus])
GO
