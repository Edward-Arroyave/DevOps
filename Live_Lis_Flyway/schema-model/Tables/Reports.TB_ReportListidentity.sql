CREATE TABLE [Reports].[TB_ReportListidentity]
(
[IdReport] [int] NOT NULL IDENTITY(1, 1),
[ReportName] [varchar] (50) NOT NULL,
[IdMenu] [int] NULL,
[IdProfile] [tinyint] NOT NULL,
[Active] [bit] NOT NULL
)
GO
