CREATE TYPE [dbo].[TR_TransferAmount_Contract] AS TABLE
(
[IdTransferAmount_Contract] [int] NULL,
[IdTransfer] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[IdContractType] [tinyint] NOT NULL,
[ContractAmount] [bigint] NOT NULL
)
GO
