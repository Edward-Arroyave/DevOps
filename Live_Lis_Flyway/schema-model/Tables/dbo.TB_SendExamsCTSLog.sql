CREATE TABLE [dbo].[TB_SendExamsCTSLog]
(
[IdSendExamsCTSLog] [int] NOT NULL IDENTITY(1, 1),
[IdResults] [varchar] (max) NULL,
[Error] [varchar] (max) NULL,
[CreationDate] [datetime] NOT NULL,
[IdUser] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_SendExamsCTSLog] ADD CONSTRAINT [PK__TB_SendE__3447EC6743FB3E21] PRIMARY KEY CLUSTERED ([IdSendExamsCTSLog])
GO
ALTER TABLE [dbo].[TB_SendExamsCTSLog] ADD CONSTRAINT [TB_SendExamsCTSLog_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
