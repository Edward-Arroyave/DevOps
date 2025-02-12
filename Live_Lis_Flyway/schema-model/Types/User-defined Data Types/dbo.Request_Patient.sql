CREATE TYPE [dbo].[Request_Patient] AS TABLE
(
[IdPatient] [int] NULL,
[Titular] [bit] NULL,
[IdRelationship] [int] NULL,
[IdPlaceDeliveryResults] [int] NULL,
[IdSampleType] [int] NULL,
[IdPersonInCharge] [int] NULL,
[SampleChangeReason] [varchar] (max) NULL,
[IdUserActionUpdate] [int] NULL
)
GO
