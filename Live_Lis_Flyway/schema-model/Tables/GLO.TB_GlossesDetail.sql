CREATE TABLE [GLO].[TB_GlossesDetail]
(
[IdGlosseDetail] [int] NOT NULL IDENTITY(1, 1),
[IdGlosse] [int] NOT NULL,
[IdRequest_Exam] [int] NULL,
[GlosseValue] [decimal] (20, 2) NULL,
[AceptedGlosseValue] [decimal] (20, 2) NULL,
[IdReason] [int] NULL,
[Createdate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[State] [int] NOT NULL,
[IdRequest] [int] NULL,
[IdExam] [int] NULL
)
GO
ALTER TABLE [GLO].[TB_GlossesDetail] ADD CONSTRAINT [PK__TB_Gloss__BC69C047E2FFEFC2] PRIMARY KEY CLUSTERED ([IdGlosseDetail])
GO
ALTER TABLE [GLO].[TB_GlossesDetail] ADD CONSTRAINT [FK_TB_GlossesDetail_TB_Glosses] FOREIGN KEY ([IdGlosse]) REFERENCES [GLO].[TB_Glosses] ([IDGlosse])
GO
ALTER TABLE [GLO].[TB_GlossesDetail] ADD CONSTRAINT [FK_TB_GlossesDetail_TB_Reason] FOREIGN KEY ([IdReason]) REFERENCES [GLO].[TB_Reason] ([IdReason])
GO
ALTER TABLE [GLO].[TB_GlossesDetail] ADD CONSTRAINT [FK_TB_GlossesDetail_TR_Request_Exam] FOREIGN KEY ([IdRequest_Exam]) REFERENCES [dbo].[TR_Request_Exam] ([IdRequest_Exam])
GO
