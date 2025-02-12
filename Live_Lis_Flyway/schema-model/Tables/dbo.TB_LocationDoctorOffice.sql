CREATE TABLE [dbo].[TB_LocationDoctorOffice]
(
[IdLocationDoctorOffice] [tinyint] NOT NULL IDENTITY(1, 1),
[LocationDoctorOffice] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TB_LocationDoctorOffice] ADD CONSTRAINT [PK_TB_LocationDoctorOffice] PRIMARY KEY CLUSTERED ([IdLocationDoctorOffice])
GO
