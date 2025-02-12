CREATE TABLE [dbo].[TB_PaymentMethod]
(
[IdPaymentMethod] [tinyint] NOT NULL IDENTITY(1, 1),
[PaymentMethodCode] [varchar] (2) NULL,
[PaymentMethodName] [varchar] (40) NOT NULL,
[Image] [varchar] (40) NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[PayTYL] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_PaymentMethod] ADD CONSTRAINT [PK_TB_PaymentMethod] PRIMARY KEY CLUSTERED ([IdPaymentMethod])
GO
ALTER TABLE [dbo].[TB_PaymentMethod] ADD CONSTRAINT [FK_TB_PaymentMethod_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
