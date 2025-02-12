CREATE TABLE [dbo].[TR_TransferAmount_Contract]
(
[IdTransferAmount_Contract] [int] NOT NULL IDENTITY(1, 1),
[IdTransfer] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[IdContractType] [tinyint] NULL,
[ContractAmount] [decimal] (20, 2) NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [dbo].[TR_TransferAmount_Contract] ADD CONSTRAINT [PK__TR_Trans__5361A2A68C033FC8] PRIMARY KEY CLUSTERED ([IdTransferAmount_Contract])
GO
ALTER TABLE [dbo].[TR_TransferAmount_Contract] ADD CONSTRAINT [TR_TransferAmount_Contract_TB_ContractType] FOREIGN KEY ([IdContractType]) REFERENCES [dbo].[TB_ContractType] ([IdContractType])
GO
ALTER TABLE [dbo].[TR_TransferAmount_Contract] ADD CONSTRAINT [TR_TransferAmount_Contract_TB_Tranfer] FOREIGN KEY ([IdTransfer]) REFERENCES [dbo].[TB_Transfer] ([IdTransfer])
GO
ALTER TABLE [dbo].[TR_TransferAmount_Contract] ADD CONSTRAINT [TR_TransferAmount_Contract_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_TransferAmount_Contract] ADD CONSTRAINT [TR_TransferAmount_ContractTB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
