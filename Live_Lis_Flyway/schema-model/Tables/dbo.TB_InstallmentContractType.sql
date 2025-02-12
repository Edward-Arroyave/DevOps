CREATE TABLE [dbo].[TB_InstallmentContractType]
(
[IdInstallmentContractType] [tinyint] NOT NULL IDENTITY(1, 1),
[InstallmentContractType] [varchar] (20) NULL
)
GO
ALTER TABLE [dbo].[TB_InstallmentContractType] ADD CONSTRAINT [PK_TB_InstallmentContractType] PRIMARY KEY CLUSTERED ([IdInstallmentContractType])
GO
