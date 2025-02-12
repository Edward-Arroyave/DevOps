CREATE TABLE [INT].[TB_Analyte_Interface]
(
[IdAnalyteInterface] [int] NOT NULL IDENTITY(1, 1),
[IdDispositive] [int] NOT NULL,
[IdAnalyte] [int] NOT NULL,
[AnalyteCode] [varchar] (15) NOT NULL,
[Comportamiento] [varchar] (15) NOT NULL,
[Decimales] [numeric] (18, 0) NOT NULL,
[CodeHostquery] [varchar] (15) NULL,
[Active] [bit] NOT NULL,
[CreateDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NOT NULL,
[Hostquery] [bit] NULL
)
GO
ALTER TABLE [INT].[TB_Analyte_Interface] ADD CONSTRAINT [PK__TB_Analy__8DBD6FE3AE40B767] PRIMARY KEY CLUSTERED ([IdAnalyteInterface])
GO
ALTER TABLE [INT].[TB_Analyte_Interface] ADD CONSTRAINT [FK_TB_Analyte_Interface_REFERENCE_TB_Analyte] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [INT].[TB_Analyte_Interface] ADD CONSTRAINT [FK_TB_Analyte_Interface_REFERENCE_TB_MedicalDevice_Conf] FOREIGN KEY ([IdDispositive]) REFERENCES [INT].[TB_MedicalDevice_Conf] ([IdDispositive])
GO
