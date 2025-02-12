CREATE TABLE [TYL].[TB_DetailPyment]
(
[IdDetailPayment] [int] NOT NULL IDENTITY(1, 1),
[IdPaymentMethod] [tinyint] NULL,
[AmountPayment] [int] NULL,
[IdRegisterMoney] [int] NOT NULL,
[UpdateDate] [datetime] NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [TYL].[TB_DetailPyment] ADD CONSTRAINT [PK__TB_Detai__EBD2AB46E9AFDFBF] PRIMARY KEY CLUSTERED ([IdDetailPayment])
GO
ALTER TABLE [TYL].[TB_DetailPyment] ADD CONSTRAINT [FK_TB_DetailPyment_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
ALTER TABLE [TYL].[TB_DetailPyment] ADD CONSTRAINT [FK_TB_DetailPyment_TB_RegisterMoney] FOREIGN KEY ([IdRegisterMoney]) REFERENCES [TYL].[TB_RegisterMoney] ([IdRegisterMoney])
GO
