CREATE TABLE [TYL].[TB_RegisterMoney]
(
[IdRegisterMoney] [int] NOT NULL IDENTITY(1, 1),
[IdAttentionCenter] [smallint] NOT NULL,
[IdBillingBox] [int] NOT NULL,
[IdReceptionType] [int] NOT NULL,
[FullPayment] [bigint] NULL,
[ReferenceNumber] [varchar] (20) NULL,
[IdUser] [int] NOT NULL,
[IdClient] [int] NOT NULL,
[CreateDate] [datetime] NOT NULL
)
GO
ALTER TABLE [TYL].[TB_RegisterMoney] ADD CONSTRAINT [PK__TB_Regis__B062A28E20B40345] PRIMARY KEY CLUSTERED ([IdRegisterMoney])
GO
ALTER TABLE [TYL].[TB_RegisterMoney] ADD CONSTRAINT [FK_TB_RegisterMoney_TB_BillingBox] FOREIGN KEY ([IdBillingBox]) REFERENCES [dbo].[TB_BillingBox] ([IdBillingBox])
GO
ALTER TABLE [TYL].[TB_RegisterMoney] ADD CONSTRAINT [FK_TB_RegisterMoney_TB_ReceptionType] FOREIGN KEY ([IdReceptionType]) REFERENCES [TYL].[TB_ReceptionType] ([IdReceptionType])
GO
ALTER TABLE [TYL].[TB_RegisterMoney] ADD CONSTRAINT [FK_TB_RegisterMoney_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
