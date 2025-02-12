CREATE TABLE [dbo].[TB_ContractTariffScheme]
(
[IdContractTariffScheme] [int] NOT NULL IDENTITY(1, 1),
[IdContract] [int] NOT NULL,
[IdTariffScheme] [int] NOT NULL,
[InitialValidityTariffServDate] [date] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL,
[Obs] [varchar] (500) NULL,
[Executed] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_ContractTariffScheme] ADD CONSTRAINT [PK_TB_ContractTariffScheme] PRIMARY KEY CLUSTERED ([IdContractTariffScheme])
GO
ALTER TABLE [dbo].[TB_ContractTariffScheme] ADD CONSTRAINT [FK_TB_ContractTariffScheme_TB_TariffScheme] FOREIGN KEY ([IdTariffScheme]) REFERENCES [dbo].[TB_TariffScheme] ([IdTariffScheme])
GO
ALTER TABLE [dbo].[TB_ContractTariffScheme] ADD CONSTRAINT [FK_TB_ContractTariffScheme_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
