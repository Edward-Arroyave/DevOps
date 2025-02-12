CREATE TABLE [Reports].[TB_ReportList]
(
[IdReport] [int] NOT NULL IDENTITY(1, 1),
[ReportName] [varchar] (50) NOT NULL,
[IdMenu] [int] NULL,
[IdProfile] [tinyint] NOT NULL,
[Active] [bit] NOT NULL,
[ReportCode] [smallint] NULL
)
GO
ALTER TABLE [Reports].[TB_ReportList] ADD CONSTRAINT [PK_ReportList] PRIMARY KEY CLUSTERED ([IdReport])
GO
