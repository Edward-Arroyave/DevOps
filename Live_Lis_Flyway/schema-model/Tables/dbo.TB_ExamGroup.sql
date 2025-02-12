CREATE TABLE [dbo].[TB_ExamGroup]
(
[IdExamGroup] [int] NOT NULL IDENTITY(1, 1),
[ExamGroupCode] [varchar] (5) NOT NULL,
[ExamGroupName] [varchar] (150) NOT NULL,
[IdTypeOfProcedure] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_ExamGroup_Active] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_ExamGroup_CreationDate] DEFAULT (dateadd(hour,(-5),getdate())),
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Score] [smallint] NULL,
[PlanValidity] [int] NULL,
[IdValidityFormat] [tinyint] NULL,
[ActiveValidity] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_ExamGroup] ADD CONSTRAINT [PK_TB_ExamGroup] PRIMARY KEY CLUSTERED ([IdExamGroup])
GO
ALTER TABLE [dbo].[TB_ExamGroup] ADD CONSTRAINT [FK_TB_ExamGroup_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
