CREATE TABLE [PTO].[TB_Assignment]
(
[IdAssignment] [int] NOT NULL IDENTITY(1, 1),
[IdPatient_Exam] [int] NULL,
[IdUser] [int] NULL,
[AssignmentDateAndTime] [date] NULL,
[IdPathologyProcess] [int] NULL
)
GO
ALTER TABLE [PTO].[TB_Assignment] ADD CONSTRAINT [PK_TB_ASSIGNMENT] PRIMARY KEY CLUSTERED ([IdAssignment])
GO
ALTER TABLE [PTO].[TB_Assignment] ADD CONSTRAINT [FK_TB_Assignment_TB_PathologyProcess] FOREIGN KEY ([IdPathologyProcess]) REFERENCES [PTO].[TB_PathologyProcess] ([IdPathologyProcess])
GO
ALTER TABLE [PTO].[TB_Assignment] ADD CONSTRAINT [FK_TB_Assignment_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [PTO].[TB_Assignment] ADD CONSTRAINT [FK_TB_Assignment_TR_Patient_Exam] FOREIGN KEY ([IdPatient_Exam]) REFERENCES [dbo].[TR_Patient_Exam] ([IdPatient_Exam])
GO
