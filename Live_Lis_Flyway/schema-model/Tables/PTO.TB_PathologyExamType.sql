CREATE TABLE [PTO].[TB_PathologyExamType]
(
[IdPathologyExamType] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [PTO].[TB_PathologyExamType] ADD CONSTRAINT [PK_TB_PathologyExamType] PRIMARY KEY CLUSTERED ([IdPathologyExamType])
GO
ALTER TABLE [PTO].[TB_PathologyExamType] ADD CONSTRAINT [FK_TB_PathologyExamType_TB_UserAction] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
