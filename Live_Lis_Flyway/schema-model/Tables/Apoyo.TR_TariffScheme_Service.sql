CREATE TABLE [Apoyo].[TR_TariffScheme_Service]
(
[IdTariffSchemeService] [int] NULL,
[IdTariffScheme] [int] NULL,
[IdService] [int] NULL,
[IdExam] [int] NULL,
[Value] [decimal] (10, 2) NULL,
[Value_UVR] [decimal] (5, 2) NULL,
[InitialVigenceDate] [date] NULL,
[Active] [bit] NULL,
[CreationDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NULL
)
GO
