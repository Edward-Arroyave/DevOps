CREATE TYPE [TYL].[TB_DetailPyment] AS TABLE
(
[IdDetailPayment] [int] NULL,
[IdPaymentMethod] [int] NULL,
[AmountPayment] [bigint] NULL,
[IdRegisterMoney] [int] NULL,
[UpdateDate] [datetime] NULL,
[Active] [bit] NULL
)
GO
