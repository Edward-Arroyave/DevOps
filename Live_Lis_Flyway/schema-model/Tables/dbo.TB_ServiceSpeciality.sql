CREATE TABLE [dbo].[TB_ServiceSpeciality]
(
[IdServiceSpeciality] [tinyint] NOT NULL IDENTITY(1, 1),
[ServiceSpeciality] [varchar] (100) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_ServiceSpeciality] ADD CONSTRAINT [PK_TB_ServiceSpeciality] PRIMARY KEY CLUSTERED ([IdServiceSpeciality])
GO
