CREATE TYPE [dbo].[TariffScheme_Service] AS TABLE
(
[IdTariffScheme_Service] [int] NULL,
[IdTariffScheme] [int] NULL,
[IdTypeOfProcedure] [tinyint] NULL,
[CUPS] [varchar] (100) NULL,
[ExamCode] [varchar] (100) NULL,
[ExamGroupCode] [varchar] (100) NULL,
[ServiceName] [varchar] (500) NULL,
[Value] [decimal] (20, 3) NULL,
[Value_UVR] [decimal] (20, 3) NULL,
[Hiring] [varchar] (10) NULL
)
GO
