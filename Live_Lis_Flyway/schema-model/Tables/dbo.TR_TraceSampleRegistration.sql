CREATE TABLE [dbo].[TR_TraceSampleRegistration]
(
[IdTraceSampleRegistration] [int] NOT NULL IDENTITY(1, 1),
[IdSampleRegistration] [int] NOT NULL,
[OriginOfPostponement] [varchar] (50) NOT NULL,
[IdUserPostponement] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TR_TraceS__Creat__7A08D20D] DEFAULT (dateadd(hour,(-5),getdate())),
[IdReasonsForPostponement] [int] NOT NULL,
[Reason] [varchar] (max) NULL,
[IdOriginOfPostponement] [int] NULL,
[IdSampleRegistrationStatus] [int] NULL
)
GO
ALTER TABLE [dbo].[TR_TraceSampleRegistration] ADD CONSTRAINT [PK__TR_Trace__65CFD2909D78353F] PRIMARY KEY CLUSTERED ([IdTraceSampleRegistration])
GO
ALTER TABLE [dbo].[TR_TraceSampleRegistration] ADD CONSTRAINT [FK_TraceSampleRegistration_TB_SampleRegistration] FOREIGN KEY ([IdSampleRegistration]) REFERENCES [dbo].[TB_SampleRegistration] ([IdSampleRegistration])
GO
