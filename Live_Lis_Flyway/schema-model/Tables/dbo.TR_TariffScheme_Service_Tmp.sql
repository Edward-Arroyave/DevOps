CREATE TABLE [dbo].[TR_TariffScheme_Service_Tmp]
(
[IdTariffScheme_Service] [int] NOT NULL,
[IdTariffScheme] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NULL,
[IdService] [varchar] (100) NULL,
[IdExam] [varchar] (100) NULL,
[IdExamGroup] [varchar] (100) NULL,
[ServiceName] [varchar] (500) NULL,
[Value] [decimal] (20, 3) NULL,
[Value_UVR] [decimal] (20, 3) NULL,
[Status] [bit] NULL,
[InitialVigenceDate] [date] NULL,
[IdUserAction] [int] NOT NULL,
[Hiring] [varchar] (100) NULL
)
GO
ALTER TABLE [dbo].[TR_TariffScheme_Service_Tmp] ADD CONSTRAINT [PK_TR_TariffScheme_Service_Tmp] PRIMARY KEY CLUSTERED ([IdTariffScheme_Service])
GO
