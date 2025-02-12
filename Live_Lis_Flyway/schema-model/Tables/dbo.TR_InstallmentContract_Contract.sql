CREATE TABLE [dbo].[TR_InstallmentContract_Contract]
(
[IdInstallmentContract_Contract] [int] NOT NULL IDENTITY(1, 1),
[IdInstallmentContract] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[IdInstallmentContractType] [tinyint] NULL,
[ContractAmount] [decimal] (20, 2) NULL,
[Crossway] [bit] NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
ALTER TABLE [dbo].[TR_InstallmentContract_Contract] ADD CONSTRAINT [PK_TR_InstallmentContract_Contract] PRIMARY KEY CLUSTERED ([IdInstallmentContract_Contract])
GO
ALTER TABLE [dbo].[TR_InstallmentContract_Contract] ADD CONSTRAINT [FK_TR_InstallmentContract_Contract_TB_InstallmentContract] FOREIGN KEY ([IdInstallmentContract]) REFERENCES [dbo].[TB_InstallmentContract] ([IdInstallmentContract])
GO
ALTER TABLE [dbo].[TR_InstallmentContract_Contract] ADD CONSTRAINT [FK_TR_InstallmentContract_Contract_TB_InstallmentContractType] FOREIGN KEY ([IdInstallmentContractType]) REFERENCES [dbo].[TB_InstallmentContractType] ([IdInstallmentContractType])
GO
ALTER TABLE [dbo].[TR_InstallmentContract_Contract] ADD CONSTRAINT [FK_TR_InstallmentContract_Contract_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
