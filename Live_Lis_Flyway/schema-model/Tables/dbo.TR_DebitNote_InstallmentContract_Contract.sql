CREATE TABLE [dbo].[TR_DebitNote_InstallmentContract_Contract]
(
[IdDebitNote_InstallmentContract_Contract] [int] NOT NULL IDENTITY(1, 1),
[IdDebitNote] [int] NOT NULL,
[IdInstallmentContract_Contract] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TR_DebitNote_InstallmentContract_Contract] ADD CONSTRAINT [PK__TR_Debit__CA5DDFCAE724779F] PRIMARY KEY CLUSTERED ([IdDebitNote_InstallmentContract_Contract])
GO
