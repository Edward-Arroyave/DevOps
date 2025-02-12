CREATE TABLE [dbo].[TB_BankAccount]
(
[IdBankAccount] [int] NOT NULL IDENTITY(1, 1),
[Bank] [varchar] (50) NOT NULL,
[Account] [varchar] (20) NOT NULL,
[NIT] [varchar] (10) NOT NULL,
[IdPaymentMethod] [tinyint] NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_BankAccount] ADD CONSTRAINT [PK_TB_BankAccount] PRIMARY KEY CLUSTERED ([IdBankAccount])
GO
ALTER TABLE [dbo].[TB_BankAccount] ADD CONSTRAINT [FK_TB_BankAccount_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
