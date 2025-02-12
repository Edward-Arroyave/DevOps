CREATE TABLE [dbo].[TB_SampleRegistrationStatus]
(
[IdSampleRegistrationStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[SampleRegistrationStatus] [varchar] (20) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_SampleRegistrationStatus] ADD CONSTRAINT [PK_TB_SampleRegistrationStatus] PRIMARY KEY CLUSTERED ([IdSampleRegistrationStatus])
GO
