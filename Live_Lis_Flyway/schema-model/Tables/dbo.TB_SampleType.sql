CREATE TABLE [dbo].[TB_SampleType]
(
[IdSampleType] [int] NOT NULL IDENTITY(1, 1),
[AlternativeCode] [int] NULL,
[SampleType] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_SampleType] ADD CONSTRAINT [PK_TB_SampleType] PRIMARY KEY CLUSTERED ([IdSampleType])
GO
ALTER TABLE [dbo].[TB_SampleType] ADD CONSTRAINT [FK_TB_SampleType_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
