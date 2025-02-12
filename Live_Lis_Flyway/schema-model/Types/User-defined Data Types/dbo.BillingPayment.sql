CREATE TYPE [dbo].[BillingPayment] AS TABLE
(
[IdPaymentMethod] [int] NULL,
[PaymentValue] [bigint] NULL,
[ReferenceNumber_CUS] [varchar] (20) NULL,
[IdBankAccount] [int] NULL
)
GO
