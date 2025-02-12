CREATE TABLE [dbo].[TB_BillingBoxClosing]
(
[IdBillingBoxClosing] [int] NOT NULL IDENTITY(1, 1),
[IdBillingBox] [int] NOT NULL,
[IdPaymentMethod] [tinyint] NOT NULL,
[AmountSystem] [bigint] NULL,
[AmountBillingBox] [bigint] NULL,
[DifferenceAmounts] [bigint] NULL,
[Comments] [varchar] (max) NULL
)
GO
ALTER TABLE [dbo].[TB_BillingBoxClosing] ADD CONSTRAINT [PK_TB_BillingBoxClosing] PRIMARY KEY CLUSTERED ([IdBillingBoxClosing])
GO
CREATE NONCLUSTERED INDEX [TB_BillingBoxClosing_BillingBox_PaymentM] ON [dbo].[TB_BillingBoxClosing] ([IdBillingBox], [IdPaymentMethod]) INCLUDE ([AmountBillingBox], [AmountSystem], [DifferenceAmounts])
GO
ALTER TABLE [dbo].[TB_BillingBoxClosing] ADD CONSTRAINT [FK_TB_BillingBoxClosing_TB_BillingBox] FOREIGN KEY ([IdBillingBox]) REFERENCES [dbo].[TB_BillingBox] ([IdBillingBox])
GO
ALTER TABLE [dbo].[TB_BillingBoxClosing] ADD CONSTRAINT [FK_TB_BillingBoxClosing_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
