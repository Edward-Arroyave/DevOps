CREATE TABLE [dbo].[TB_AdmissionStatus]
(
[IdAdmissionStatus] [tinyint] NOT NULL IDENTITY(1, 1),
[AdmissionStatus] [varchar] (30) NOT NULL
)
GO
ALTER TABLE [dbo].[TB_AdmissionStatus] ADD CONSTRAINT [PK_TB_AdmissionStatus] PRIMARY KEY CLUSTERED ([IdAdmissionStatus])
GO
