CREATE TABLE [dbo].[TB_ServiceDescription]
(
[IdServiceDescription] [tinyint] NOT NULL IDENTITY(1, 1),
[ServiceDescription] [varchar] (100) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceDescription] ADD CONSTRAINT [PK_TB_DescriptionService] PRIMARY KEY CLUSTERED ([IdServiceDescription])
GO
