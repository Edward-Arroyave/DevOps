CREATE TABLE [POSANT].[TB_SampleSupportNetwork]
(
[IdSampleSupportNetwork] [int] NOT NULL IDENTITY(1, 1),
[SampleNumber] [varchar] (50) NOT NULL,
[IdSupportNetwork] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [POSANT].[TB_SampleSupportNetwork] ADD CONSTRAINT [PK__TB_Sampl__4FEF8F1B6D0D6388] PRIMARY KEY CLUSTERED ([IdSampleSupportNetwork])
GO
ALTER TABLE [POSANT].[TB_SampleSupportNetwork] ADD CONSTRAINT [FK__TB_Sample__IdUse__7153907B] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
ALTER TABLE [POSANT].[TB_SampleSupportNetwork] ADD CONSTRAINT [FK__TB_Sample__IdSup__0A54486F] FOREIGN KEY ([IdSupportNetwork]) REFERENCES [POSANT].[TB_SupportNetwork] ([IdSupportNetwork])
GO
