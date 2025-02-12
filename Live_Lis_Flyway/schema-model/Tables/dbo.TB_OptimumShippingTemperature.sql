CREATE TABLE [dbo].[TB_OptimumShippingTemperature]
(
[IdOptimumShippingTemperature] [tinyint] NOT NULL IDENTITY(1, 1),
[OptimumShippingTemperature] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_OptimumShippingTemperature] ADD CONSTRAINT [PK_TB_OptimumShippingTemperature] PRIMARY KEY CLUSTERED ([IdOptimumShippingTemperature])
GO
