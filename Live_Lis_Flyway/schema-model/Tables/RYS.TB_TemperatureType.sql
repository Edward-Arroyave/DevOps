CREATE TABLE [RYS].[TB_TemperatureType]
(
[IdTemperatureType] [int] NOT NULL IDENTITY(1, 1),
[NameTemperature] [varchar] (50) NULL
)
GO
ALTER TABLE [RYS].[TB_TemperatureType] ADD CONSTRAINT [PK__TB_Tempe__7D2C662C68216C02] PRIMARY KEY CLUSTERED ([IdTemperatureType])
GO
