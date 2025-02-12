CREATE TABLE [dbo].[TB_CriticalDates]
(
[IdCriticalDates] [int] NOT NULL IDENTITY(1, 1),
[IdAnalyte] [int] NOT NULL,
[IdDataType] [tinyint] NOT NULL,
[InitialValue] [decimal] (7, 3) NULL,
[FinalValue] [decimal] (7, 3) NULL,
[IdExpectedValue] [smallint] NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TB_Critic__Creat__6BBAB2B6] DEFAULT (dateadd(hour,(-5),getdate())),
[IdUserCreation] [int] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserUpdate] [int] NULL,
[Active] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_CriticalDates] ADD CONSTRAINT [PK__TB_Criti__387AC463AA057FAC] PRIMARY KEY CLUSTERED ([IdCriticalDates])
GO
ALTER TABLE [dbo].[TB_CriticalDates] ADD CONSTRAINT [FK_TB_CriticalDates_TB_Analyte] FOREIGN KEY ([IdAnalyte]) REFERENCES [dbo].[TB_Analyte] ([IdAnalyte])
GO
ALTER TABLE [dbo].[TB_CriticalDates] ADD CONSTRAINT [FK_TB_CriticalDates_TB_DataType] FOREIGN KEY ([IdDataType]) REFERENCES [dbo].[TB_DataType] ([IdDataType])
GO
ALTER TABLE [dbo].[TB_CriticalDates] ADD CONSTRAINT [FK_TB_CriticalDates_TB_ExpectedValue] FOREIGN KEY ([IdExpectedValue]) REFERENCES [dbo].[TB_ExpectedValue] ([IdExpectedValue])
GO
ALTER TABLE [dbo].[TB_CriticalDates] ADD CONSTRAINT [FK_TB_CriticalDates_TB_UserUpdate] FOREIGN KEY ([IdUserUpdate]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [dbo].[TB_CriticalDates] ADD CONSTRAINT [FK_TTB_CriticalDates_TB_UserCreation] FOREIGN KEY ([IdUserCreation]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
