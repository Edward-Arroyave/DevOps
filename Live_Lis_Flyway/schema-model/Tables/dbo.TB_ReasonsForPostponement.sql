CREATE TABLE [dbo].[TB_ReasonsForPostponement]
(
[IdReasonsForPostponement] [int] NOT NULL IDENTITY(1, 1),
[PostponementCode] [varchar] (10) NULL,
[PostponementName] [varchar] (200) NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TB_Reason__Creat__66F5FD99] DEFAULT (dateadd(hour,(-5),getdate())),
[IdUserCreation] [int] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserUpdate] [int] NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_ReasonsForPostponement] ADD CONSTRAINT [PK__TB_Reaso__37FCA9E4618386F6] PRIMARY KEY CLUSTERED ([IdReasonsForPostponement])
GO
ALTER TABLE [dbo].[TB_ReasonsForPostponement] ADD CONSTRAINT [FK_TB_ReasonsForPostponement_TB_User] FOREIGN KEY ([IdUserCreation]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_ReasonsForPostponement] ADD CONSTRAINT [FK_TB_ReasonsForPostponement_TB_UserUpdate] FOREIGN KEY ([IdUserUpdate]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
