CREATE TABLE [dbo].[TB_TariffServiceChange]
(
[IdTariffServiceChange] [int] NOT NULL IDENTITY(1, 1),
[IdTariffScheme] [int] NOT NULL,
[IdTypeOfProcedure] [tinyint] NOT NULL,
[IdService] [int] NULL,
[IdExam] [int] NULL,
[IdExamGroup] [int] NULL,
[Value] [bigint] NOT NULL,
[Value_UVR] [decimal] (5, 2) NOT NULL,
[InitialVigenceDate] [date] NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL,
[Hiring] [varchar] (100) NULL
)
GO
ALTER TABLE [dbo].[TB_TariffServiceChange] ADD CONSTRAINT [PK_TB_TariffServiceChange] PRIMARY KEY CLUSTERED ([IdTariffServiceChange])
GO
ALTER TABLE [dbo].[TB_TariffServiceChange] ADD CONSTRAINT [FK_TB_TariffServiceChange_TB_TariffScheme] FOREIGN KEY ([IdTariffScheme]) REFERENCES [dbo].[TB_TariffScheme] ([IdTariffScheme])
GO
ALTER TABLE [dbo].[TB_TariffServiceChange] ADD CONSTRAINT [FK_TB_TariffServiceChange_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
