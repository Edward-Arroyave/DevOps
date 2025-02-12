CREATE TABLE [dbo].[TB_Service]
(
[IdService] [int] NOT NULL IDENTITY(1, 1),
[CUPS] [varchar] (6) NOT NULL,
[ServiceName] [varchar] (500) NOT NULL,
[IdServiceDescription] [tinyint] NULL,
[Extra_I] [varchar] (2) NULL,
[Extra_II] [varchar] (1) NULL,
[IdServiceGroupLevel3] [int] NULL,
[IdServiceSubCategory] [int] NULL,
[IdServiceType] [tinyint] NULL,
[IdServiceSpeciality] [tinyint] NULL,
[CreationDate] [datetime] NOT NULL,
[UpdateDate] [datetime] NULL,
[IdUserAction] [int] NOT NULL,
[Active] [bit] NOT NULL,
[ValidityStatus] [bit] NULL
)
GO
ALTER TABLE [dbo].[TB_Service] ADD CONSTRAINT [PK_TB_Service] PRIMARY KEY CLUSTERED ([IdService])
GO
ALTER TABLE [dbo].[TB_Service] ADD CONSTRAINT [FK_TB_Service_TB_ServiceDescription] FOREIGN KEY ([IdServiceDescription]) REFERENCES [dbo].[TB_ServiceDescription] ([IdServiceDescription])
GO
ALTER TABLE [dbo].[TB_Service] ADD CONSTRAINT [FK_TB_Service_TB_ServiceGroupLevel3] FOREIGN KEY ([IdServiceGroupLevel3]) REFERENCES [dbo].[TB_ServiceGroupLevel3] ([IdServiceGroupLevel3])
GO
ALTER TABLE [dbo].[TB_Service] ADD CONSTRAINT [FK_TB_Service_TB_ServiceSpeciality] FOREIGN KEY ([IdServiceSpeciality]) REFERENCES [dbo].[TB_ServiceSpeciality] ([IdServiceSpeciality])
GO
ALTER TABLE [dbo].[TB_Service] ADD CONSTRAINT [FK_TB_Service_TB_ServiceSubCategory] FOREIGN KEY ([IdServiceSubCategory]) REFERENCES [dbo].[TB_ServiceSubCategory] ([IdServiceSubCategory])
GO
ALTER TABLE [dbo].[TB_Service] ADD CONSTRAINT [FK_TB_Service_TB_ServiceType] FOREIGN KEY ([IdServiceType]) REFERENCES [dbo].[TB_ServiceType] ([IdServiceType])
GO
ALTER TABLE [dbo].[TB_Service] ADD CONSTRAINT [FK_TB_Service_TB_User] FOREIGN KEY ([IdUserAction]) REFERENCES [dbo].[TB_User] ([IdUser])
GO
