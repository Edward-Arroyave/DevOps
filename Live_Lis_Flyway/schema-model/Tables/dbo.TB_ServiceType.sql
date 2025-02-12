CREATE TABLE [dbo].[TB_ServiceType]
(
[IdServiceType] [tinyint] NOT NULL IDENTITY(1, 1),
[ServiceTypeCode] [varchar] (5) NOT NULL,
[ServiceType] [varchar] (50) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceType] ADD CONSTRAINT [PK_TB_ServiceType] PRIMARY KEY CLUSTERED ([IdServiceType])
GO
