CREATE TABLE [TYL].[TB_TemperatureClient]
(
[IdTemperatureClient] [int] NOT NULL IDENTITY(1, 1),
[IdRegisterClient] [int] NULL,
[IdFridgeType] [int] NULL,
[Temperature] [decimal] (4, 2) NULL
)
GO
ALTER TABLE [TYL].[TB_TemperatureClient] ADD CONSTRAINT [PK__TB_Tempe__7E0F8CEDC89E1C6D] PRIMARY KEY CLUSTERED ([IdTemperatureClient])
GO
ALTER TABLE [TYL].[TB_TemperatureClient] ADD CONSTRAINT [FK_TB_RegisterClient_TB_FridgeType] FOREIGN KEY ([IdFridgeType]) REFERENCES [TYL].[TB_FridgeType] ([IdFridgeType])
GO
ALTER TABLE [TYL].[TB_TemperatureClient] ADD CONSTRAINT [FK_TB_TemperatureClient_TB_RegisterClient] FOREIGN KEY ([IdRegisterClient]) REFERENCES [TYL].[TB_RegisterClient] ([IdRegisterClient])
GO
