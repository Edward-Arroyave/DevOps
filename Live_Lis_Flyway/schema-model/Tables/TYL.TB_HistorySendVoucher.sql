CREATE TABLE [TYL].[TB_HistorySendVoucher]
(
[IDHistorySendVoucher] [int] NOT NULL IDENTITY(1, 1),
[IdRegisterMoney] [int] NOT NULL,
[Email] [varchar] (60) NULL,
[IdUser] [int] NOT NULL
)
GO
ALTER TABLE [TYL].[TB_HistorySendVoucher] ADD CONSTRAINT [PK__TB_Histo__510CC0D49F1DF658] PRIMARY KEY CLUSTERED ([IDHistorySendVoucher])
GO
ALTER TABLE [TYL].[TB_HistorySendVoucher] ADD CONSTRAINT [FK_TB_HistoryRegisterMoney_TB_RegisterMoney] FOREIGN KEY ([IdRegisterMoney]) REFERENCES [TYL].[TB_RegisterMoney] ([IdRegisterMoney])
GO
