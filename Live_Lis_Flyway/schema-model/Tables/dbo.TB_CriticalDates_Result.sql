CREATE TABLE [dbo].[TB_CriticalDates_Result]
(
[IdCriticalDates_Result] [int] NOT NULL IDENTITY(1, 1),
[IdResults] [int] NOT NULL,
[Observations] [varchar] (max) NULL,
[CreationDate] [datetime] NOT NULL,
[IdUser] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_CriticalDates_Result] ADD CONSTRAINT [PK__TB_Criti__74D49195382D76FA] PRIMARY KEY CLUSTERED ([IdCriticalDates_Result])
GO
ALTER TABLE [dbo].[TB_CriticalDates_Result] ADD CONSTRAINT [FK_TB_CriticalDates_Result_TB_Results] FOREIGN KEY ([IdResults]) REFERENCES [ANT].[TB_Results] ([IdResults])
GO
ALTER TABLE [dbo].[TB_CriticalDates_Result] ADD CONSTRAINT [FK_TB_CriticalDates_Result_TB_User] FOREIGN KEY ([IdUser]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
