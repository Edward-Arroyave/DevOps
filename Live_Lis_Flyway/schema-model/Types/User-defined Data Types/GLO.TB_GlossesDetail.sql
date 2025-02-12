CREATE TYPE [GLO].[TB_GlossesDetail] AS TABLE
(
[IdGlosseDetail] [int] NULL,
[IdGlosse] [int] NULL,
[IdRequest_Exam] [int] NULL,
[IdExam] [int] NULL,
[GlosseValue] [bigint] NULL,
[AceptedGlosseValue] [bigint] NULL,
[IdReason] [int] NULL,
[IdRequest] [int] NULL
)
GO
