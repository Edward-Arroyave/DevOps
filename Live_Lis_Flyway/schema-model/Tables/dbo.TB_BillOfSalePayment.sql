CREATE TABLE [dbo].[TB_BillOfSalePayment]
(
[IdBillOfSalePayment] [int] NOT NULL IDENTITY(1, 1),
[IdBillingOfSale] [int] NOT NULL,
[BillOfSalePaymentDate] [datetime] NOT NULL,
[IdPaymentMethod] [tinyint] NOT NULL,
[PaymentValue] [bigint] NOT NULL,
[ReferenceNumber_CUS] [varchar] (20) NULL,
[IdBankAccount] [int] NULL,
[IdBillingBox] [int] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Active] DEFAULT ((1)),
[IdUserAction] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TB_BillOfSalePayment] ADD CONSTRAINT [PK_TB_BillOfSalePayment] PRIMARY KEY CLUSTERED ([IdBillOfSalePayment])
GO
ALTER TABLE [dbo].[TB_BillOfSalePayment] ADD CONSTRAINT [FK_TB_BillOfSalePayment_TB_BankAccount] FOREIGN KEY ([IdBankAccount]) REFERENCES [dbo].[TB_BankAccount] ([IdBankAccount])
GO
ALTER TABLE [dbo].[TB_BillOfSalePayment] ADD CONSTRAINT [FK_TB_BillOfSalePayment_TB_BillingBox] FOREIGN KEY ([IdBillingBox]) REFERENCES [dbo].[TB_BillingBox] ([IdBillingBox])
GO
ALTER TABLE [dbo].[TB_BillOfSalePayment] ADD CONSTRAINT [FK_TB_BillOfSalePayment_TB_BillingOfSale] FOREIGN KEY ([IdBillingOfSale]) REFERENCES [dbo].[TB_BillingOfSale] ([IdBillingOfSale])
GO
ALTER TABLE [dbo].[TB_BillOfSalePayment] ADD CONSTRAINT [FK_TB_BillOfSalePayment_TB_PaymentMethod] FOREIGN KEY ([IdPaymentMethod]) REFERENCES [dbo].[TB_PaymentMethod] ([IdPaymentMethod])
GO
ALTER TABLE [dbo].[TB_BillOfSalePayment] ADD CONSTRAINT [FK_TB_BillOfSalePayment_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
