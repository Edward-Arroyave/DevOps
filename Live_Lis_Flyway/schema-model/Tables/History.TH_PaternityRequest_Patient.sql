CREATE TABLE [History].[TH_PaternityRequest_Patient]
(
[IdPaternityRequest_Patient] [int] NOT NULL IDENTITY(1, 1),
[ActionDate] [datetime] NOT NULL,
[Action] [varchar] (10) NOT NULL,
[RequestNumber] [varchar] (20) NOT NULL,
[IdRequest_Patient] [int] NOT NULL,
[IdRequest] [int] NOT NULL,
[IdPatient] [int] NOT NULL,
[Titular] [bit] NULL,
[IdRelationship] [tinyint] NULL,
[IdPlaceDeliveryResults] [tinyint] NULL,
[IdSampleType] [int] NULL,
[IdUserAction] [int] NOT NULL,
[SampleChangeReason] [varchar] (max) NULL,
[IdUserActionUpdate] [int] NULL
)
GO
ALTER TABLE [History].[TH_PaternityRequest_Patient] ADD CONSTRAINT [PK_TH_PaternityRequest_Patient] PRIMARY KEY CLUSTERED ([IdPaternityRequest_Patient])
GO
