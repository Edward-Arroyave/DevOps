CREATE TYPE [TYL].[TB_FridgeContent] AS TABLE
(
[IdFridgeContent] [int] NULL,
[IdRouteFridge] [int] NULL,
[IdFridgeType] [int] NULL,
[IdFridgeCode] [int] NULL,
[InitialTemperature] [decimal] (4, 2) NULL,
[IntermediateTemperature] [decimal] (4, 2) NULL,
[FinalTemperature] [decimal] (4, 2) NULL,
[DateInitialTemperature] [datetime] NULL,
[DateInitermediateTemperature] [datetime] NULL,
[DateFinalTemperature] [datetime] NULL,
[CreatedDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[Active] [bit] NULL,
[IdUserAction] [int] NULL
)
GO
