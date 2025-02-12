CREATE TABLE [dbo].[TR_PaymentMethodMenu]
(
[IdPaymentMethodMenu] [int] NOT NULL IDENTITY(1, 1),
[IdPaymentMethod] [tinyint] NOT NULL,
[IdMenu] [smallint] NOT NULL,
[Active] [bit] NULL
)
GO
