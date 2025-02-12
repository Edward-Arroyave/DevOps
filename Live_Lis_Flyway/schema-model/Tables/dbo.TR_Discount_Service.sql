CREATE TABLE [dbo].[TR_Discount_Service]
(
[IdDiscount_Service] [int] NOT NULL IDENTITY(1, 1),
[IdDiscount] [int] NULL,
[IdExam] [int] NULL,
[IdExamGroup] [int] NULL,
[Percentage] [decimal] (5, 2) NULL,
[Active] [bit] NULL CONSTRAINT [DF__TR_Discou__Activ__7015537F] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TR_Discou__Creat__710977B8] DEFAULT (dateadd(hour,(-5),getdate())),
[IdUserCreation] [int] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserUpdate] [int] NULL
)
GO
ALTER TABLE [dbo].[TR_Discount_Service] ADD CONSTRAINT [PK__TR_Disco__3BB2517280B9C5C7] PRIMARY KEY CLUSTERED ([IdDiscount_Service])
GO
ALTER TABLE [dbo].[TR_Discount_Service] ADD CONSTRAINT [FK_TR_Discount_Service_TB_Discount] FOREIGN KEY ([IdDiscount]) REFERENCES [dbo].[TB_Discount] ([IdDiscount])
GO
ALTER TABLE [dbo].[TR_Discount_Service] ADD CONSTRAINT [FK_TR_Discount_Service_TB_Exam] FOREIGN KEY ([IdExam]) REFERENCES [dbo].[TB_Exam] ([IdExam])
GO
ALTER TABLE [dbo].[TR_Discount_Service] ADD CONSTRAINT [FK_TR_Discount_Service_TB_ExamGroup] FOREIGN KEY ([IdExamGroup]) REFERENCES [dbo].[TB_ExamGroup] ([IdExamGroup])
GO
ALTER TABLE [dbo].[TR_Discount_Service] ADD CONSTRAINT [FK_TR_Discount_Service_TB_UserCreation] FOREIGN KEY ([IdUserCreation]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TR_Discount_Service] ADD CONSTRAINT [FK_TR_Discount_Service_TB_UserUpdate] FOREIGN KEY ([IdUserUpdate]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
