CREATE TABLE [dbo].[TB_ResultPaterReqStatus]
(
[IdResultPaterReqStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[ResultPaterReqStatus] [varchar] (19) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ResultPaterReqStatus] ADD CONSTRAINT [PK_TB_ResultPaterReqStatus] PRIMARY KEY CLUSTERED ([IdResultPaterReqStatus])
GO
