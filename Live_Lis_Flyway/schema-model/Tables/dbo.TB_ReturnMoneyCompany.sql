CREATE TABLE [dbo].[TB_ReturnMoneyCompany]
(
[IdReturnMoneyCompany] [int] NOT NULL IDENTITY(1, 1),
[IdCompany] [int] NOT NULL,
[IdContract] [int] NOT NULL,
[Amount] [bigint] NULL,
[IdPaymentMethod] [tinyint] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL,
[IdBillingBox] [int] NULL
)
GO
ALTER TABLE [dbo].[TB_ReturnMoneyCompany] ADD CONSTRAINT [FK_TB_ReturnMoneyCompany_TB_BillingBox] FOREIGN KEY ([IdBillingBox]) REFERENCES [dbo].[TB_BillingBox] ([IdBillingBox])
GO
ALTER TABLE [dbo].[TB_ReturnMoneyCompany] ADD CONSTRAINT [FK_TB_ReturnMoneyCompany_TB_Company] FOREIGN KEY ([IdCompany]) REFERENCES [dbo].[TB_Company] ([IdCompany])
GO
ALTER TABLE [dbo].[TB_ReturnMoneyCompany] ADD CONSTRAINT [FK_TB_ReturnMoneyCompany_TB_Contract] FOREIGN KEY ([IdContract]) REFERENCES [dbo].[TB_Contract] ([IdContract])
GO
ALTER TABLE [dbo].[TB_ReturnMoneyCompany] ADD CONSTRAINT [FK_TB_ReturnMoneyCompany_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
ALTER TABLE [dbo].[TB_ReturnMoneyCompany] ADD CONSTRAINT [FK_TB_ReturnMoneyCompany_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
